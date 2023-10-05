// lib/services/media_kit_service.dart
import 'package:media_kit/media_kit.dart';

class MediaKitService {
  MediaKitService._privateConstructor();

  static final MediaKitService instance = MediaKitService._privateConstructor();

  final player = Player();

  Future<void> play(String url) async {
    await player.open(Media(url));
  }

  Future<void> playPlaylist(List<String> urls) async {
    final playlist = Playlist(urls.map((url) => Media(url)).toList());
    await player.open(playlist);
  }
}
