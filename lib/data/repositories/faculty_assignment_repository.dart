import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/faculty_assignment_model.dart';
import '../../presentation/auth/auth_controller.dart';
import '../models/user_model.dart';

final facultyAssignmentRepositoryProvider =
    Provider<FacultyAssignmentRepository>((ref) {
      return FacultyAssignmentRepository(FirebaseFirestore.instance);
    });

// Stream to fetch all faculty members for the current college
final facultyMembersStreamProvider =
    StreamProvider.autoDispose<List<UserModel>>((ref) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;

      if (collegeId == null) return Stream.value([]);

      return FirebaseFirestore.instance
          .collection('users')
          .where('collegeId', isEqualTo: collegeId)
          .where('role', isEqualTo: 'faculty')
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => UserModel.fromJson(doc.data()))
                .toList(),
          );
    });

// Stream to fetch assignments
final assignmentsStreamProvider =
    StreamProvider.autoDispose<List<FacultyAssignmentModel>>((ref) {
      final authState = ref.watch(authStateProvider);
      final collegeId = authState.user?.collegeId;

      if (collegeId == null) return Stream.value([]);

      final repo = ref.watch(facultyAssignmentRepositoryProvider);
      return repo.watchAssignments(collegeId);
    });

class FacultyAssignmentRepository {
  final FirebaseFirestore _firestore;

  FacultyAssignmentRepository(this._firestore);

  Stream<List<FacultyAssignmentModel>> watchAssignments(String collegeId) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('faculty_assignments')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => FacultyAssignmentModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }),
              )
              .toList(),
        );
  }

  Future<void> assignFaculty(
    String collegeId,
    FacultyAssignmentModel assignment,
  ) async {
    final docRef = _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('faculty_assignments')
        .doc();

    final newAssignment = assignment.copyWith(id: docRef.id);
    await docRef.set(newAssignment.toJson());
  }

  Future<void> removeAssignment(String collegeId, String assignmentId) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('faculty_assignments')
        .doc(assignmentId)
        .delete();
  }
}
