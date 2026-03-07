import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/class_model.dart';
import '../../presentation/auth/auth_controller.dart';

final classRepositoryProvider = Provider<ClassRepository>((ref) {
  return ClassRepository(FirebaseFirestore.instance);
});

final classesStreamProvider = StreamProvider.autoDispose<List<ClassModel>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final collegeId = authState.user?.collegeId;

  if (collegeId == null) return Stream.value([]);

  final repo = ref.watch(classRepositoryProvider);
  return repo.watchClasses(collegeId);
});

class ClassRepository {
  final FirebaseFirestore _firestore;

  ClassRepository(this._firestore);

  Stream<List<ClassModel>> watchClasses(String collegeId) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('classes')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClassModel.fromJson({'id': doc.id, ...doc.data()}))
              .toList(),
        );
  }

  Future<void> addClass(String collegeId, ClassModel classModel) async {
    final docRef = _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('classes')
        .doc();

    final newClass = classModel.copyWith(id: docRef.id);
    await docRef.set(newClass.toJson());
  }

  Future<void> updateClass(String collegeId, ClassModel classModel) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('classes')
        .doc(classModel.id)
        .update(classModel.toJson());
  }

  Future<void> deleteClass(String collegeId, String classId) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('classes')
        .doc(classId)
        .delete();
  }
}
