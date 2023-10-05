// lib/services/firebase_storage_service.dart
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'firebase_firestore_service.dart';

class FirebaseStorageService {
  FirebaseStorageService._privateConstructor();

  static final FirebaseStorageService instance =
      FirebaseStorageService._privateConstructor();

  Stream<TaskSnapshot> uploadFile(String filePath, String title) async* {
    File file = File(filePath);
    try {
      SettableMetadata metadata = SettableMetadata(
        contentType: 'audio/mpeg',
        customMetadata: <String, String>{'title': title},
      );
      // add to firestore
      String? refId = await FirebaseFirestoreService.instance.addAudio(title);

      // Create a reference to the location you want to upload to in firebase
      Reference ref = FirebaseStorage.instance.ref('audio/$refId.mp3');

      // Upload the file to firebase
      /*UploadTask uploadTask = ref.putFile(
        file,
        metadata,
      );*/
      UploadTask task = ref.putFile(
        file,
        metadata,
      );

      // Waits till the file is uploaded then stores the download url
      /*String downloadUrl = await (await uploadTask).ref.getDownloadURL();*/
      /*String downloadUrl =
          await (await currentUploadTask!).ref.getDownloadURL();

      // Returns the download url
      await FirebaseFirestoreService.instance.updateAudio(refId, downloadUrl);*/
      task.snapshotEvents;
      yield* task.snapshotEvents;
    } catch (e) {
      print(e);
    }
  }
}
