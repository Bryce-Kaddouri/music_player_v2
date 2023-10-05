import 'package:cloud_firestore/cloud_firestore.dart';

class AudioModel {
  final String title;
  final String downloadUrl;
  final String id;
  Timestamp createdAt;

  AudioModel({
    required this.title,
    required this.downloadUrl,
    required this.id,
    required this.createdAt,
  });

  factory AudioModel.fromMap(Map<String, dynamic> map) {
    return AudioModel(
      title: map['title'],
      downloadUrl: map['downloadUrl'],
      id: 'trest',
      createdAt: map['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'downloadUrl': downloadUrl,
      'id': 'tet',
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return 'AudioModel(title: $title, downloadUrl: $downloadUrl, id: $id, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioModel &&
        other.title == title &&
        other.downloadUrl == downloadUrl &&
        other.id == id &&
        other.createdAt == createdAt;
  }

  @override
  String get getTitle => title;

  @override
  String get getDownloadUrl => downloadUrl;

  @override
  String get getId => id;

  @override
  Timestamp get getCreatedAt => createdAt;
}
