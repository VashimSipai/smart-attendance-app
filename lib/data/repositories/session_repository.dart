import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session_model.dart';
import '../models/attendance_model.dart';
import '../../presentation/auth/auth_controller.dart';

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(FirebaseFirestore.instance);
});

/// Stream of the currently active session for a faculty member's assignment
final activeSessionStreamProvider = StreamProvider.autoDispose
    .family<SessionModel?, String>((ref, assignmentId) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;
      if (collegeId == null) return Stream.value(null);
      return ref
          .watch(sessionRepositoryProvider)
          .watchActiveSessionForAssignment(collegeId, assignmentId);
    });

/// Stream of attendance for a live session
final attendanceStreamProvider = StreamProvider.autoDispose
    .family<List<AttendanceModel>, String>((ref, sessionId) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;
      if (collegeId == null) return Stream.value([]);
      return ref
          .watch(sessionRepositoryProvider)
          .watchAttendance(collegeId, sessionId);
    });

class SessionRepository {
  final FirebaseFirestore _firestore;
  static const _hmacSecret =
      'smart_attend_secret_2024'; // In production, use remote config

  SessionRepository(this._firestore);

  /// Generates a time-based HMAC token that rotates every 2 minutes
  static String generateQrToken(String sessionId) {
    // Round to nearest 2-minute window so token is stable within window
    final windowMs = (DateTime.now().millisecondsSinceEpoch ~/ 120000) * 120000;
    final data = '$sessionId:$windowMs:$_hmacSecret';
    final hmac = Hmac(sha256, utf8.encode(_hmacSecret));
    final digest = hmac.convert(utf8.encode(data));
    return '$sessionId:$windowMs:${digest.toString().substring(0, 16)}';
  }

  /// Validates a scanned QR token
  static bool validateQrToken(String scannedToken, String sessionId) {
    final parts = scannedToken.split(':');
    if (parts.length < 3) return false;

    final tokenSessionId = parts[0];
    if (tokenSessionId != sessionId) return false;

    final tokenWindow = int.tryParse(parts[1]);
    if (tokenWindow == null) return false;

    // Accept current window and one previous window (2-4 min tolerance)
    final currentWindow =
        (DateTime.now().millisecondsSinceEpoch ~/ 120000) * 120000;
    final prevWindow = currentWindow - 120000;

    if (tokenWindow != currentWindow && tokenWindow != prevWindow) return false;

    // Re-generate to verify HMAC
    final data = '$sessionId:$tokenWindow:$_hmacSecret';
    final hmac = Hmac(sha256, utf8.encode(_hmacSecret));
    final digest = hmac.convert(utf8.encode(data));
    final expectedToken =
        '$sessionId:$tokenWindow:${digest.toString().substring(0, 16)}';

    return scannedToken == expectedToken;
  }

  Future<SessionModel> startSession({
    required String collegeId,
    required String timetableId,
    required String facultyId,
    required String subjectId,
    required String classId,
  }) async {
    // End any previously active session for this faculty
    await _endExistingActiveSessions(collegeId, facultyId);

    final docRef = _firestore.collection('sessions').doc();
    final now = DateTime.now();
    final token = generateQrToken(docRef.id);

    final session = SessionModel(
      id: docRef.id,
      collegeId: collegeId,
      timetableId: timetableId,
      facultyId: facultyId,
      subjectId: subjectId,
      classId: classId,
      startTime: now,
      expiryTime: now.add(const Duration(hours: 2)),
      qrToken: token,
      isActive: true,
    );

    await docRef.set(session.toJson());
    return session;
  }

  Future<void> _endExistingActiveSessions(
    String collegeId,
    String facultyId,
  ) async {
    final existing = await _firestore
        .collection('sessions')
        .where('facultyId', isEqualTo: facultyId)
        .where('isActive', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    for (final doc in existing.docs) {
      batch.update(doc.reference, {'isActive': false});
    }
    await batch.commit();
  }

  Future<void> endSession(String sessionId) async {
    await _firestore.collection('sessions').doc(sessionId).update({
      'isActive': false,
    });
  }

  Stream<SessionModel?> watchActiveSessionForAssignment(
    String collegeId,
    String assignmentId,
  ) {
    return _firestore
        .collection('sessions')
        .where('timetableId', isEqualTo: assignmentId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          return SessionModel.fromJson({
            'id': snap.docs.first.id,
            ...snap.docs.first.data(),
          });
        });
  }

  Stream<SessionModel?> watchActiveSessionForFaculty(String facultyId) {
    return _firestore
        .collection('sessions')
        .where('facultyId', isEqualTo: facultyId)
        .where('isActive', isEqualTo: true)
        .limit(1)
        .snapshots()
        .map((snap) {
          if (snap.docs.isEmpty) return null;
          return SessionModel.fromJson({
            'id': snap.docs.first.id,
            ...snap.docs.first.data(),
          });
        });
  }

  /// Mark attendance for a student — returns error string or null on success
  Future<String?> markAttendance({
    required String collegeId,
    required String sessionId,
    required String studentUid,
    required String scannedToken,
    String? deviceId,
  }) async {
    // 1. Validate the QR token
    if (!validateQrToken(scannedToken, sessionId)) {
      return 'QR code is expired or invalid. Please scan the current code.';
    }

    // 2. Check the session is still active
    final sessionDoc = await _firestore
        .collection('sessions')
        .doc(sessionId)
        .get();
    if (!sessionDoc.exists) return 'Session not found.';
    final session = SessionModel.fromJson({
      'id': sessionDoc.id,
      ...sessionDoc.data()!,
    });
    if (!session.isActive) return 'This session has already ended.';

    // 3. Prevent duplicate attendance
    final existing = await _firestore
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .doc(studentUid)
        .get();

    if (existing.exists) return 'Attendance already recorded for this session.';

    // 4. Write attendance
    final record = AttendanceModel(
      studentUid: studentUid,
      sessionId: sessionId,
      timestamp: DateTime.now(),
      deviceId: deviceId,
    );

    await _firestore
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .doc(studentUid)
        .set(record.toJson());

    return null; // success
  }

  Stream<List<AttendanceModel>> watchAttendance(
    String collegeId,
    String sessionId,
  ) {
    return _firestore
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => AttendanceModel.fromJson(doc.data()))
              .toList(),
        );
  }

  /// Stream for student to check if they already attended a session
  Future<bool> hasStudentAttended(String sessionId, String studentUid) async {
    final doc = await _firestore
        .collection('sessions')
        .doc(sessionId)
        .collection('attendance')
        .doc(studentUid)
        .get();
    return doc.exists;
  }

  /// Get all sessions for a faculty member
  Stream<List<SessionModel>> watchFacultySessions(String facultyId) {
    return _firestore
        .collection('sessions')
        .where('facultyId', isEqualTo: facultyId)
        .orderBy('startTime', descending: true)
        .limit(20)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => SessionModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  /// Stream of active sessions for a specific class (used by Student Dashboard)
  Stream<List<SessionModel>> watchActiveSessionsForClass(String classId) {
    return _firestore
        .collection('sessions')
        .where('classId', isEqualTo: classId)
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map(
                (doc) => SessionModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }
}

final facultyActiveSessionProvider = StreamProvider.autoDispose<SessionModel?>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final facultyId = authState.user?.uid;
  if (facultyId == null) return Stream.value(null);
  return ref
      .watch(sessionRepositoryProvider)
      .watchActiveSessionForFaculty(facultyId);
});
