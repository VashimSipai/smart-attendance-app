import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/timetable_model.dart';
import '../../presentation/auth/auth_controller.dart';

final timetableRepositoryProvider = Provider<TimetableRepository>((ref) {
  return TimetableRepository(FirebaseFirestore.instance);
});

final timetableStreamProvider = StreamProvider.autoDispose
    .family<List<TimetableModel>, String>((ref, classId) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;

      if (collegeId == null) return Stream.value([]);

      final repo = ref.watch(timetableRepositoryProvider);
      return repo.watchTimetable(collegeId, classId);
    });

final facultyTimetableStreamProvider = StreamProvider.autoDispose
    .family<List<TimetableModel>, String>((ref, facultyId) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;

      if (collegeId == null) return Stream.value([]);

      final repo = ref.watch(timetableRepositoryProvider);
      return repo.watchTimetableForFaculty(collegeId, facultyId);
    });

/// Streams the timetable config (time slots, working days, holidays) for a specific program
final timetableConfigProvider = StreamProvider.autoDispose
    .family<TimetableConfig, String>((ref, programId) {
      final collegeId = ref.watch(authControllerProvider).user?.collegeId;
      if (collegeId == null) return Stream.value(TimetableConfig.defaults());
      return ref
          .watch(timetableRepositoryProvider)
          .watchConfig(collegeId, programId);
    });

/// Simple config object — not Freezed, just a plain class
class TimetableConfig {
  final List<String> workingDays;
  final List<String> timeSlots; // e.g. '09:00 - 10:00'
  final List<Map<String, dynamic>>
  holidays; // {date: '2026-01-26', name: 'Republic Day'}

  TimetableConfig({
    required this.workingDays,
    required this.timeSlots,
    required this.holidays,
  });

  factory TimetableConfig.defaults() => TimetableConfig(
    workingDays: [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ],
    timeSlots: [
      '09:00 - 10:00',
      '10:00 - 11:00',
      '11:15 - 12:15',
      '12:15 - 01:15',
      '02:00 - 03:00',
      '03:00 - 04:00',
    ],
    holidays: [],
  );

  factory TimetableConfig.fromMap(Map<String, dynamic> map) => TimetableConfig(
    workingDays: List<String>.from(map['workingDays'] ?? []),
    timeSlots: List<String>.from(map['timeSlots'] ?? []),
    holidays: List<Map<String, dynamic>>.from(
      (map['holidays'] as List? ?? []).map((h) => Map<String, dynamic>.from(h)),
    ),
  );

  Map<String, dynamic> toMap() => {
    'workingDays': workingDays,
    'timeSlots': timeSlots,
    'holidays': holidays,
  };
}

class TimetableRepository {
  final FirebaseFirestore _firestore;

  TimetableRepository(this._firestore);

  // ── Config ────────────────────────────────────────────────────────
  DocumentReference _configDoc(String collegeId, String programId) => _firestore
      .collection('colleges')
      .doc(collegeId)
      .collection('config')
      .doc('timetable_$programId');

  Stream<TimetableConfig> watchConfig(String collegeId, String programId) {
    return _configDoc(collegeId, programId).snapshots().map((snap) {
      if (!snap.exists || snap.data() == null) {
        return TimetableConfig.defaults();
      }
      return TimetableConfig.fromMap(snap.data()! as Map<String, dynamic>);
    });
  }

  Future<void> saveConfig(
    String collegeId,
    String programId,
    TimetableConfig config,
  ) async {
    await _configDoc(
      collegeId,
      programId,
    ).set(config.toMap(), SetOptions(merge: true));
  }

  // ── Timetable slots ───────────────────────────────────────────────
  Stream<List<TimetableModel>> watchTimetable(
    String collegeId,
    String classId,
  ) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('timetables')
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TimetableModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  Stream<List<TimetableModel>> watchTimetableForFaculty(
    String collegeId,
    String facultyId,
  ) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('timetables')
        .where('facultyId', isEqualTo: facultyId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TimetableModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  Future<void> saveTimetableSlot(String collegeId, TimetableModel slot) async {
    final docRef = _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('timetables')
        .doc();

    final newSlot = slot.copyWith(id: docRef.id);
    await docRef.set(newSlot.toJson());
  }

  Future<void> deleteTimetableSlot(String collegeId, String slotId) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('timetables')
        .doc(slotId)
        .delete();
  }
}
