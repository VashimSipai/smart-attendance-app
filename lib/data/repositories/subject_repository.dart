import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/subject_model.dart';
import '../../presentation/auth/auth_controller.dart';

final subjectRepositoryProvider = Provider<SubjectRepository>((ref) {
  return SubjectRepository(FirebaseFirestore.instance);
});

final subjectsStreamProvider = StreamProvider.autoDispose<List<SubjectModel>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final collegeId = authState.user?.collegeId;

  if (collegeId == null) return Stream.value([]);

  final repo = ref.watch(subjectRepositoryProvider);
  return repo.watchSubjects(collegeId);
});

class SubjectRepository {
  final FirebaseFirestore _firestore;

  SubjectRepository(this._firestore);

  Stream<List<SubjectModel>> watchSubjects(String collegeId) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('subjects')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => SubjectModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  Future<void> addSubject(String collegeId, SubjectModel subject) async {
    final docRef = _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('subjects')
        .doc();

    final newSubject = subject.copyWith(id: docRef.id);
    await docRef.set(newSubject.toJson());
  }

  Future<void> updateSubject(String collegeId, SubjectModel subject) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('subjects')
        .doc(subject.id)
        .update(subject.toJson());
  }

  Future<void> deleteSubject(String collegeId, String subjectId) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('subjects')
        .doc(subjectId)
        .delete();
  }
}
