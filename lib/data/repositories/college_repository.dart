import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/college_model.dart';

final collegeRepositoryProvider = Provider<CollegeRepository>((ref) {
  return CollegeRepository(FirebaseFirestore.instance);
});

class CollegeRepository {
  final FirebaseFirestore _firestore;

  CollegeRepository(this._firestore);

  Future<CollegeModel?> getCollege(String collegeId) async {
    final doc = await _firestore.collection('colleges').doc(collegeId).get();
    if (doc.exists && doc.data() != null) {
      return CollegeModel.fromJson(doc.data()!);
    }
    return null;
  }

  // Admin feature
  Future<void> createCollege(CollegeModel college) async {
    await _firestore
        .collection('colleges')
        .doc(college.id)
        .set(college.toJson());
  }
}
