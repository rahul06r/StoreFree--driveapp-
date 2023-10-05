import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_app/Model/note_creation.dart';
import 'package:drive_app/Providers/firebase_providers.dart';
import 'package:drive_app/constants/failure.dart';
import 'package:drive_app/constants/firebase_constants.dart';
import 'package:drive_app/constants/typedef.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final noteRepoProvider = Provider((ref) {
  return NoteRepository(firebaseFirestore: ref.watch(firestoreProvider));
});

class NoteRepository {
  final FirebaseFirestore _firebaseFirestore;

  NoteRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _notes =>
      _firebaseFirestore.collection(FirebaseConstants.noteCollection);

  FutureVoid addNote(NoteModel note) async {
    try {
      return right(
        _notes.doc(note.noteId).set(note.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Update note

  FutureVoid updateNote(NoteModel note) async {
    try {
      return right(
        _notes.doc(note.noteId).update(note.toMap()),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  Stream<List<NoteModel>> getAllNotes() {
    return _notes.snapshots().map((event) => event.docs
        .map((e) => NoteModel.fromMap(e.data() as Map<String, dynamic>))
        .toList());
  }

  FutureVoid deleteNote(String noteID) async {
    try {
      return right(
        _notes.doc(noteID).delete(),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
