// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NoteModel {
  final String noteId;
  final String textName;
  final String descText;
  final DateTime uploadTime;
  final String? passWord;
  final bool isLocked;

  NoteModel({
    required this.noteId,
    required this.textName,
    required this.descText,
    required this.uploadTime,
    this.passWord,
    required this.isLocked,
  });

  NoteModel copyWith({
    String? noteId,
    String? textName,
    String? descText,
    DateTime? uploadTime,
    String? passWord,
    bool? isLocked,
  }) {
    return NoteModel(
      noteId: noteId ?? this.noteId,
      textName: textName ?? this.textName,
      descText: descText ?? this.descText,
      uploadTime: uploadTime ?? this.uploadTime,
      passWord: passWord ?? this.passWord,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'noteId': noteId,
      'textName': textName,
      'descText': descText,
      'uploadTime': uploadTime.millisecondsSinceEpoch,
      'passWord': passWord,
      'isLocked': isLocked,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      noteId: map['noteId'] as String,
      textName: map['textName'] as String,
      descText: map['descText'] as String,
      uploadTime: DateTime.fromMillisecondsSinceEpoch(map['uploadTime'] as int),
      passWord: map['passWord'] != null ? map['passWord'] as String : null,
      isLocked: map['isLocked'] as bool,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory NoteModel.fromJson(String source) => NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NoteModel(noteId: $noteId, textName: $textName, descText: $descText, uploadTime: $uploadTime, passWord: $passWord, isLocked: $isLocked)';
  }

  @override
  bool operator ==(covariant NoteModel other) {
    if (identical(this, other)) return true;

    return other.noteId == noteId &&
        other.textName == textName &&
        other.descText == descText &&
        other.uploadTime == uploadTime &&
        other.passWord == passWord &&
        other.isLocked == isLocked;
  }

  @override
  int get hashCode {
    return noteId.hashCode ^
        textName.hashCode ^
        descText.hashCode ^
        uploadTime.hashCode ^
        passWord.hashCode ^
        isLocked.hashCode;
  }

  String toJson() => json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
      NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
