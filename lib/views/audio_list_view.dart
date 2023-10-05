import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_test_provider/providers/upload_provider.dart';

import '../providers/audio_files_provider.dart';

class AudioListView extends StatefulWidget {
  const AudioListView({super.key});

  @override
  State<AudioListView> createState() => _AudioListViewState();
}

class _AudioListViewState extends State<AudioListView> {
  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);

    return ListView(
      children: [
        ListTile(
          title: const Text('Audio 1'),
          trailing: IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () {
                print('play audio 1');
              }),
        ),
      ],
    );
  }
}
