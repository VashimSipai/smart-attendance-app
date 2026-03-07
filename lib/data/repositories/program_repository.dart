import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/program_model.dart';
import '../../presentation/auth/auth_controller.dart';

final programRepositoryProvider = Provider<ProgramRepository>((ref) {
  return ProgramRepository(FirebaseFirestore.instance);
});

final programsStreamProvider = StreamProvider.autoDispose<List<ProgramModel>>((
  ref,
) {
  final authState = ref.watch(authStateProvider);
  final collegeId = authState.user?.collegeId;

  if (collegeId == null) return Stream.value([]);

  final repo = ref.watch(programRepositoryProvider);
  return repo.watchPrograms(collegeId);
});

class ProgramRepository {
  final FirebaseFirestore _firestore;

  ProgramRepository(this._firestore);

  Stream<List<ProgramModel>> watchPrograms(String collegeId) {
    return _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('programs')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ProgramModel.fromJson({'id': doc.id, ...doc.data()}),
              )
              .toList(),
        );
  }

  Future<void> addProgram(String collegeId, ProgramModel program) async {
    final docRef = _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('programs')
        .doc();

    final newProgram = program.copyWith(id: docRef.id);
    await docRef.set(newProgram.toJson());
  }

  Future<void> updateProgram(String collegeId, ProgramModel program) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('programs')
        .doc(program.id)
        .update(program.toJson());
  }

  Future<void> deleteProgram(String collegeId, String programId) async {
    await _firestore
        .collection('colleges')
        .doc(collegeId)
        .collection('programs')
        .doc(programId)
        .delete();
  }
}
