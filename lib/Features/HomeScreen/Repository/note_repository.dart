import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_app/Features/Auth/Screens/Repositry/authRepo.dart';
import 'package:drive_app/Model/note_creation.dart';
import 'package:drive_app/Model/userModel.dart';
import 'package:drive_app/Providers/firebase_providers.dart';
import 'package:drive_app/constants/failure.dart';
import 'package:drive_app/constants/firebase_constants.dart';
import 'package:drive_app/constants/typedef.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final noteRepoProvider = Provider((ref) {
  return NoteRepository(
      firebaseFirestore: ref.watch(firestoreProvider), ref: ref);
});

class NoteRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  NoteRepository({
    required FirebaseFirestore firebaseFirestore,
    required Ref ref,
  })  : _ref = ref,
        _firebaseFirestore = firebaseFirestore;

  CollectionReference get _notes =>
      _firebaseFirestore.collection(FirebaseConstants.noteCollection);
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

  FutureVoid addNote(NoteModel note, String uID) async {
    try {
      return right(_users
          .doc(uID)
          .collection("notes")
          .doc(note.noteId)
          .set(note.toMap()));
      // return right(
      //   _notes.doc(note.noteId).set(note.toMap()),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update note

  FutureVoid updateNote(NoteModel note, String uID) async {
    try {
      return right(_users
          .doc(uID)
          .collection("notes")
          .doc(note.noteId)
          .update(note.toMap()));
      // return right(
      //   _notes.doc(note.noteId).update(note.toMap()),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updatePassword(
      String noteID, String passWord, bool isLocked, String uID) async {
    try {
      return right(
        _users.doc(uID).collection("notes").doc(noteID).update({
          "passWord": passWord,
          "isLocked": isLocked,
        }),
      );
      // return right(
      //   _notes.doc(noteID).update({
      //     "passWord": passWord,
      //     "isLocked": isLocked,
      //   }),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  Stream<List<NoteModel>> getAllNotes(String uID) {
    return _users
        .doc(uID)
        .collection("notes")
        .orderBy("uploadTime", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => NoteModel.fromMap(e.data() as Map<String, dynamic>))
            .toList());

    // return _notes.orderBy("uploadTime", descending: true).snapshots().map(
    //       (event) => event.docs
    //           .map((e) => NoteModel.fromMap(e.data() as Map<String, dynamic>))
    //           .toList(),
    //     );
  }

  Stream<NoteModel> getParticularNote(String noteId, String uID) {
    return _users.doc(uID).collection("notes").doc(noteId).snapshots().map(
        (event) => NoteModel.fromMap(event.data() as Map<String, dynamic>));
    // return _notes.doc(noteId).snapshots().map(
    //     (event) => NoteModel.fromMap(event.data() as Map<String, dynamic>));
  }

  FutureVoid deleteNote(String noteID, String uID) async {
    try {
      return right(
        _users.doc(uID).collection("notes").doc(noteID).delete(),
      );
      // return right(
      //   _notes.doc(noteID).delete(),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
