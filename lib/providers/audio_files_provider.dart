// lib/providers/upload_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:my_test_provider/models/audio_file.dart';
import '/services/firebase_storage_service.dart';
import 'dart:io';

class AudioProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  final Player _player = Player();
  Player get player => _player;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }

  bool _isOpenPlaylist = false;
  bool get isOpenPlaylist => _isOpenPlaylist;

  void setIsOpenPlaylist(bool isOpenPlaylist) {
    _isOpenPlaylist = isOpenPlaylist;
    notifyListeners();
  }

  final int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  final double _currentPosition = 0;
  double get currentPosition => _currentPosition;

  final double _duration = 0;
  double get duration => _duration;

  final List<AudioModel> _audioFiles = [];
  List<AudioModel> get audioFiles => _audioFiles;

  void openPlaylist() async {
    try {
      final snapshot = _firestore.collection('audio').snapshots();
      snapshot.listen((event) async {
        final datas = event.docs.map((e) => e.data()).toList();

        Playlist _playlist = Playlist(datas
            .map((data) => Media(data['downloadUrl'], extras: {
                  'title': data['title'],
                  'createdAt': data['createdAt'],
                }))
            .toList());
        if (_isOpenPlaylist == false) {
          await _player.open(
            _playlist,
            play: false,
          );
          _player.setPlaylistMode(PlaylistMode.loop);

          setIsOpenPlaylist(true);
        } else {
          print('playlist is already open');
          print('song is added');
          print('event : $event');
          Media media = Media(event.docs.last.data()['downloadUrl'], extras: {
            'title': event.docs.last.data()['title'],
            'createdAt': event.docs.last.data()['createdAt'],
          });
          await _player.add(media);
          notifyListeners();
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void play() async {
    try {
      await _player.playOrPause();
      setIsPlaying(_player.state.playing);
    } catch (e) {
      print(e);
    }
  }

  void pause() async {
    try {
      await _player.pause();
    } catch (e) {
      print(e);
    }
  }

  void next() async {
    try {
      await _player.next();
    } catch (e) {
      print(e);
    }
  }

  void previous() async {
    try {
      await _player.previous();
    } catch (e) {
      print(e);
    }
  }
}
