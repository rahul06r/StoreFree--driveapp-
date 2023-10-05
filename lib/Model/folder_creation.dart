import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class FolderCreate {
  final String folderId;
  final DateTime createdAt;
  final int noOfImages;
  final String folderName;
  FolderCreate({
    required this.folderId,
    required this.createdAt,
    required this.noOfImages,
    required this.folderName,
  });

  FolderCreate copyWith({
    String? folderId,
    DateTime? createdAt,
    int? noOfImages,
    String? folderName,
  }) {
    return FolderCreate(
      folderId: folderId ?? this.folderId,
      createdAt: createdAt ?? this.createdAt,
      noOfImages: noOfImages ?? this.noOfImages,
      folderName: folderName ?? this.folderName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'folderId': folderId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'noOfImages': noOfImages,
      'folderName': folderName,
    };
  }

  factory FolderCreate.fromMap(Map<String, dynamic> map) {
    return FolderCreate(
      folderId: map['folderId'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      noOfImages: map['noOfImages'] as int,
      folderName: map['folderName'] as String,
    );
  }

  @override
  String toString() {
    return 'FolderCreate(folderId: $folderId, createdAt: $createdAt, noOfImages: $noOfImages, folderName: $folderName)';
  }

  @override
  bool operator ==(covariant FolderCreate other) {
    if (identical(this, other)) return true;

    return other.folderId == folderId &&
        other.createdAt == createdAt &&
        other.noOfImages == noOfImages &&
        other.folderName == folderName;
  }

  @override
  int get hashCode {
    return folderId.hashCode ^
        createdAt.hashCode ^
        noOfImages.hashCode ^
        folderName.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory FolderCreate.fromJson(String source) =>
      FolderCreate.fromMap(json.decode(source) as Map<String, dynamic>);
}
