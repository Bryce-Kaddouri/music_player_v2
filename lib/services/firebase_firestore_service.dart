// lib/services/firebase_firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._privateConstructor();

  static final FirebaseFirestoreService instance =
      FirebaseFirestoreService._privateConstructor();

  final _firestore = FirebaseFirestore.instance;

  Future<String?> addAudio(String title) async {
    try {
      DocumentReference ref = await _firestore.collection('audio').add({
        'title': title,
        'createdAt': FieldValue.serverTimestamp(),
        'downloadUrl': '',
      });
      return ref.id;
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateAudio(String id, String downloadUrl) async {
    try {
      await _firestore.collection('audio').doc(id).update({
        'downloadUrl': downloadUrl,
      });
    } catch (e) {
      print(e);
    }
  }
}
