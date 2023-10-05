import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:my_test_provider/models/audio_file.dart';
import 'package:my_test_provider/providers/audio_files_provider.dart';
import 'package:my_test_provider/views/upload_page.dart';
import 'package:provider/provider.dart';

import '../providers/upload_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void open() async {
    print('open');
    context.read<AudioProvider>().openPlaylist();
  }

  @override
  void initState() {
    open();
/*
    context.read<AudioProvider>().openPlaylist();
*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UploadPage()),
              );
            },
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    context.watch<UploadProvider>().uploadProgress > 0
                        ? ListTile(
                            title: Text(context
                                .watch<UploadProvider>()
                                .getCurrentTitle),
                            trailing: CircularProgressIndicator(
                              value: context
                                  .watch<UploadProvider>()
                                  .uploadProgress,
                            ),
                          )
                        : const SizedBox(),
                    StreamBuilder(
                      stream:
                          context.watch<AudioProvider>().player.stream.playlist,
                      builder: (context, AsyncSnapshot<Playlist> snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }

                        if (snapshot.hasData) {
                          print(snapshot.data);
                          List<Media> medias = snapshot.data!.medias;
                          int currentIndex = snapshot.data!.index;
                          print(medias);
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data?.medias.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                selected: index == currentIndex,
                                onTap: () async {
                                  context
                                      .read<AudioProvider>()
                                      .player
                                      .jump(index);
                                  context
                                      .read<AudioProvider>()
                                      .setIsPlaying(true);
                                },
                                title: Text(
                                    '${snapshot.data?.medias[index].extras!['title']}'),
                                trailing: IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      print('play audio $index');
                                    }),
                              );
                            },
                          );
                        }
                        return const Center(
                          child: Text('No data'),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                shape: BoxShape.rectangle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.9),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              height: 60,
              child: Column(
                children: [
                  StreamBuilder(
                    stream:
                        context.watch<AudioProvider>().player.stream.playlist,
                    builder: (context, AsyncSnapshot<Playlist> snapshot) {
                      if (snapshot.hasData) {
                        List<Media> medias = snapshot.data!.medias;
                        int currentIndex = snapshot.data!.index;
                        return StreamBuilder(
                          stream: context
                              .watch<AudioProvider>()
                              .player
                              .stream
                              .duration,
                          builder: (context,
                              AsyncSnapshot<Duration> snapshotDuration) {
                            if (snapshotDuration.hasData) {
                              return StreamBuilder(
                                stream: context
                                    .watch<AudioProvider>()
                                    .player
                                    .stream
                                    .position,
                                builder: (context,
                                    AsyncSnapshot<Duration> snapshotPosition) {
                                  if (snapshotPosition.hasData) {
                                    return LinearProgressIndicator(
                                      value: snapshotPosition
                                              .data!.inMilliseconds
                                              .toDouble() /
                                          snapshotDuration.data!.inMilliseconds
                                              .toDouble(),
                                    );
                                  }
                                  return const LinearProgressIndicator(
                                    value: 0,
                                  );
                                },
                              );
                            }
                            return const LinearProgressIndicator(value: 0.0);
                          },
                        );
                      }
                      return const LinearProgressIndicator(
                        value: 0.0,
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder(
                          stream: context
                              .watch<AudioProvider>()
                              .player
                              .stream
                              .playlist,
                          builder: (context, AsyncSnapshot<Playlist> snapshot) {
                            if (snapshot.hasData) {
                              List<Media> medias = snapshot.data!.medias;
                              int currentIndex = snapshot.data!.index;
                              print(snapshot.data);
                              return Text(
                                  '${medias[currentIndex].extras!['title']}');
                            }
                            return const Text('0');
                          },
                        ),
                      ),
                      Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                context.read<AudioProvider>().previous();
                              },
                              icon: const Icon(Icons.skip_previous),
                            ),
                            IconButton(
                              onPressed: () {
                                if (context
                                        .read<AudioProvider>()
                                        .isOpenPlaylist ==
                                    false) {
                                  context.read<AudioProvider>().openPlaylist();
                                }
                                context.read<AudioProvider>().play();
                              },
                              icon: context.watch<AudioProvider>().isPlaying
                                  ? Icon(Icons.pause)
                                  : Icon(Icons.play_arrow),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<AudioProvider>().next();
                              },
                              icon: const Icon(Icons.skip_next),
                            ),
                            // button to give a rating to the music (from 0 to 5 stars)
                            IconButton(
                              onPressed: () {
                                context.read<AudioProvider>().next();
                              },
                              icon: const Icon(Icons.star),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
