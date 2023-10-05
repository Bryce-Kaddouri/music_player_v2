import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_test_provider/providers/audio_files_provider.dart';
import 'package:my_test_provider/providers/upload_provider.dart';
import 'package:my_test_provider/services/firebase_storage_service.dart';
import 'package:my_test_provider/services/media_kit_service.dart';
import 'package:my_test_provider/views/home_page.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UploadProvider()),
      ChangeNotifierProvider(create: (_) => AudioProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String _title = 'My Test Provider';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: const HomePage(),
    );
  }
}
