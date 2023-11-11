import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImagePost {
  final String id;
  final String url;
  final String name;
  final DateTime uploadTime;
  ImagePost({
    required this.id,
    required this.url,
    required this.name,
    required this.uploadTime,
  });

  ImagePost copyWith({
    String? id,
    String? url,
    String? name,
    DateTime? uploadTime,
  }) {
    return ImagePost(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'name': name,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
    };
  }

  factory ImagePost.fromMap(Map<String, dynamic> map) {
    return ImagePost(
      id: map['id'] as String,
      url: map['url'] as String,
      name: map['name'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
    );
  }

  @override
  String toString() {
    return 'ImagePost(id: $id, url: $url, name: $name, uploadTime: $uploadTime)';
  }

  @override
  bool operator ==(covariant ImagePost other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.url == url &&
        other.name == name &&
        other.uploadTime == uploadTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^ url.hashCode ^ name.hashCode ^ uploadTime.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory ImagePost.fromJson(String source) =>
      ImagePost.fromMap(json.decode(source) as Map<String, dynamic>);
}
