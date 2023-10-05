import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImagePost {
  final String id;
  final String url;
  final String name;
  ImagePost({
    required this.id,
    required this.url,
    required this.name,
  });

  ImagePost copyWith({
    String? id,
    String? url,
    String? name,
  }) {
    return ImagePost(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'url': url,
      'name': name,
    };
  }

  factory ImagePost.fromMap(Map<String, dynamic> map) {
    return ImagePost(
      id: map['id'] as String,
      url: map['url'] as String,
      name: map['name'] as String,
    );
  }

  @override
  String toString() => 'ImagePost(id: $id, url: $url, name: $name)';

  @override
  bool operator ==(covariant ImagePost other) {
    if (identical(this, other)) return true;

    return other.id == id && other.url == url && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ name.hashCode;

  String toJson() => json.encode(toMap());

  factory ImagePost.fromJson(String source) =>
      ImagePost.fromMap(json.decode(source) as Map<String, dynamic>);
}
