import 'package:drive_app/Features/HomeScreen/Repository/note_repository.dart';
import 'package:drive_app/Model/note_creation.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final noteControllerProvider = StateNotifierProvider<NoteCon, bool>((ref) {
  return NoteCon(noteRepository: ref.watch(noteRepoProvider), ref: ref);
});

final getAllNotesProvider = StreamProvider((ref) {
  return ref.read(noteControllerProvider.notifier).getAllNotes();
});

class NoteCon extends StateNotifier<bool> {
  final NoteRepository _noteRepository;
  final Ref _ref;

  NoteCon({required NoteRepository noteRepository, required Ref ref})
      : _noteRepository = noteRepository,
        _ref = ref,
        super(false);

  //
  void addNote({
    required BuildContext context,
    required String textName,
    required String descText,
  }) async {
    state = true;
    String id = const Uuid().v1();

    final NoteModel noteModel = NoteModel(
        noteId: id,
        textName: textName,
        descText: descText,
        uploadTime: DateTime.now());
    final res = await _noteRepository.addNote(noteModel);

    res.fold((l) {
      if (kDebugMode) {
        print(l.message);
      }

      showsnackBars(context, "Cannot be  Deleted  😢😓", Pallete.redColor);
    }, (r) {
      Navigator.pop(context);
      showsnackBars(context, "Successfully Created 🤟 ✔️", Pallete.greenColor);
      if (kDebugMode) {
        print("Name $textName");
      }
    });
  }

  void updateNote({
    required BuildContext context,
    required String textName,
    required String descText,
    required String noteId,
  }) async {
    state = true;
    final NoteModel noteModel = NoteModel(
        noteId: noteId,
        textName: textName,
        descText: descText,
        uploadTime: DateTime.now());

    final res = await _noteRepository.updateNote(noteModel);

    res.fold((l) {
      if (kDebugMode) {
        print(l.message);
      }

      showsnackBars(context, "Cannot be  Updated  😢😓", Pallete.redColor);
    }, (r) {
      showsnackBars(context, "Successfully Updated 🤟 ✔️", Pallete.greenColor);
      if (kDebugMode) {
        print("Name $textName");
      }
    });
  }

  Stream<List<NoteModel>> getAllNotes() {
    return _noteRepository.getAllNotes();
  }

  void deleteNote({
    required String noteID,
    required BuildContext context,
  }) async {
    final res = await _noteRepository.deleteNote(noteID);

    res.fold((l) {
      showsnackBars(context, "Cannot be  Deleted 😢😓", Pallete.redColor);
    }, (r) {
      showsnackBars(context, "Successfully Deleted 🤟 ✔️", Pallete.greenColor);
    });
  }
}
