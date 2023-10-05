// lib/providers/upload_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:my_test_provider/providers/audio_files_provider.dart';
import '../services/firebase_firestore_service.dart';
import '/services/firebase_storage_service.dart';
import 'dart:io';

class UploadProvider with ChangeNotifier {
  final _storageService = FirebaseStorageService.instance;

  double _uploadProgress = 0;
  double get uploadProgress => _uploadProgress;

  String currentTitle = '';
  String get getCurrentTitle => currentTitle;

  void setCurrentTitle(String title) {
    currentTitle = title;
  }

  void uploadFile(String path, String title) async {
    try {
      String? id = await FirebaseFirestoreService.instance.addAudio('$title');
      final ref = FirebaseStorage.instance.ref('audio/$id.mp3');
      final uploadTask = ref.putFile(
        File(path),
        SettableMetadata(
          contentType: 'audio/mpeg',
        ),
      );
      uploadTask.snapshotEvents.listen((event) async {
        setCurrentTitle(title);
        _uploadProgress = event.bytesTransferred / event.totalBytes;
        notifyListeners();
        if (event.state == TaskState.success) {
          print('Upload complete');
          final downloadUrl = await ref.getDownloadURL();
          await FirebaseFirestoreService.instance.updateAudio(id!, downloadUrl);
          _uploadProgress = 0;
          setCurrentTitle('');
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void updateFile(String id, String? title, String? path) async {
    try {
      final ref = FirebaseStorage.instance.ref('audio/$id.mp3');
      if (title != null) {
        await FirebaseFirestoreService.instance.updateAudio(id, title);
      } else if (path != null) {
        final uploadTask = ref.putFile(
          File(path),
          SettableMetadata(
            contentType: 'audio/mpeg',
          ),
        );
        uploadTask.snapshotEvents.listen((event) async {
          _uploadProgress = event.bytesTransferred / event.totalBytes;
          notifyListeners();
          if (event.state == TaskState.success) {
            print('Upload complete');
            final downloadUrl = await ref.getDownloadURL();
            await FirebaseFirestoreService.instance
                .updateAudio(id, downloadUrl);

            _uploadProgress = 0;
            notifyListeners();
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  DownloadTask getFile(String idFile) {
    print('audio/$idFile.mp3');
    PlatformFile? returnFile;

    DownloadTask file =
        FirebaseStorage.instance.ref('audio/$idFile.mp3').writeToFile(
              File(
                  '/data/user/0/com.example.my_test_provider/cache/file_picker/$idFile.mp3'),
            );

    /*   file.snapshotEvents.listen((event) {
      if (event.state == TaskState.success) {
        print('Download complete');
        PlatformFile platformFile = PlatformFile(
          path:
              '/data/user/0/com.example.my_test_provider/cache/file_picker/$idFile.mp3',
          name: '$idFile.mp3',
          size: event.totalBytes,
        );
        returnFile = platformFile;
      }
    });*/
    return file;
  }
}
