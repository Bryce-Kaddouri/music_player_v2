// import 'package:flutter/services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
//
// class PermissionProvider with ChangeNotifier {
//   bool _audioIsGranted = false;
//   bool get audioIsGranted => _audioIsGranted;
//
//   void setAudioIsGranted(bool isGranted) {
//     _audioIsGranted = isGranted;
//     notifyListeners();
//   }
//
//   bool _storageIsGranted = false;
//   bool get storageIsGranted => _storageIsGranted;
//
//   void setStorageIsGranted(bool isGranted) {
//     _storageIsGranted = isGranted;
//     notifyListeners();
//   }
//
//   Future<void> requestPermission() async {
//     try {
//       if (await Permission.audio.isDenied ||
//           await Permission.audio.isPermanentlyDenied) {
//         final state = await Permission.audio.request();
//         if (!state.isGranted) {
//           print('Permission.audio.isDenied');
//           await SystemNavigator.pop();
//         } else {
//           setAudioIsGranted(true);
//         }
//       }
//       if (await Permission.storage.isDenied ||
//           await Permission.storage.isPermanentlyDenied) {
//         final state = await Permission.storage.request();
//         if (!state.isGranted) {
//           print('Permission.storage.isDenied');
//           await SystemNavigator.pop();
//         } else {
//           setStorageIsGranted(true);
//         }
//       }
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
// }
