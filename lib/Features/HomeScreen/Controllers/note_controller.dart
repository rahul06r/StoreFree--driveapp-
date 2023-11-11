import 'package:drive_app/Features/Auth/Screens/Repositry/authRepo.dart';
import 'package:drive_app/Features/HomeScreen/Repository/note_repository.dart';
import 'package:drive_app/Model/note_creation.dart';
import 'package:drive_app/Model/userModel.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

final noteControllerProvider = StateNotifierProvider<NoteCon, bool>((ref) {
  return NoteCon(noteRepository: ref.watch(noteRepoProvider), ref: ref);
});

final getAllNotesProvider = StreamProvider((ref) {
  return ref.read(noteControllerProvider.notifier).getAllNotes();
});
final getParticularNoteProvider = StreamProvider.family((ref, String noteID) {
  return ref
      .read(noteControllerProvider.notifier)
      .getParticularNote(noteId: noteID);
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
    UserModel userModel = _ref.read(userProvider)!;
    String id = const Uuid().v1();

    final NoteModel noteModel = NoteModel(
      noteId: id,
      textName: textName,
      descText: descText,
      uploadTime: DateTime.now(),
      isLocked: false,
      passWord: "",
    );
    final res = await _noteRepository.addNote(noteModel, userModel.uid);

    res.fold((l) {
      if (kDebugMode) {
        print(l.message);
      }

      showsnackBars(context, "Cannot be  Added  😢😓", Pallete.redColor);
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
    required String passWord,
    required bool isLocked,
  }) async {
    state = true;
    UserModel userModel = _ref.read(userProvider)!;
    final NoteModel noteModel = NoteModel(
      noteId: noteId,
      textName: textName,
      descText: descText,
      uploadTime: DateTime.now(),
      isLocked: isLocked,
      passWord: passWord,
    );

    final res = await _noteRepository.updateNote(noteModel, userModel.uid);

    res.fold((l) {
      if (kDebugMode) {
        print("${l.message} controller error");
      }

      // showsnackBars(context, "Cannot be Updated  😢😓", Pallete.redColor);
      Fluttertoast.showToast(
        msg: "Cannot be Updated  😢😓",
        backgroundColor: Pallete.redColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        fontSize: 20,
      );
    }, (r) {
      // showsnackBars(context, "Successfully Updated 🤟 ✔️", Pallete.greenColor);
      Fluttertoast.showToast(
        msg: "Successfully Updated 🤟 ✔️",
        backgroundColor: Pallete.greenColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        fontSize: 20,
      );
      if (kDebugMode) {
        print("Name $textName");
      }
    });
  }

  // void updatePassword({
  //   required String passWord,
  //   required String noteID,
  //   required BuildContext context,
  //   required bool isLocked,
  // }) async {
  //   state = true;
  //   // hshsh
  //   UserModel userModel = _ref.read(userProvider)!;

  //   final res = await _noteRepository.updatePassword(
  //       noteID, passWord, isLocked, userModel.uid);
  //   res.fold((l) {
  //     // Navigator.pop(context);
  //     showsnackBars(context, "$l 😢😓", Pallete.redColor);
  //   }, (r) {
  //     print(passWord);
  //     // showsnackBars(context, "Password Updated ✔️", Pallete.greenColor);
  //   });

  //   state = false;
  // }
  void updatePassword({
    required String noteID,
    required String passWord,
    required bool isLocked,
    required BuildContext context,
  }) async {
    state = true;

    UserModel userModel = _ref.read(userProvider)!;

    final res = await _noteRepository.updatePassword(
      noteID,
      passWord,
      isLocked,
      userModel.uid,
    );

    res.fold(
      (l) {
        // Log the error
        print("Error updating password: $l");
        showsnackBars(context, "$l 😢😓", Pallete.redColor);
      },
      (r) {
        // Log the success
        print("Password Updated: $passWord");
        showsnackBars(context, "Password Updated ✔️", Pallete.greenColor);
      },
    );

    state = false;
  }

  Stream<List<NoteModel>> getAllNotes() {
    UserModel userModel = _ref.read(userProvider)!;

    return _noteRepository.getAllNotes(userModel.uid);
  }

  Stream<NoteModel> getParticularNote({required String noteId}) {
    UserModel userModel = _ref.read(userProvider)!;
    return _noteRepository.getParticularNote(noteId, userModel.uid);
  }

  void deleteNote({
    required String noteID,
    required BuildContext context,
  }) async {
    state = true;
    UserModel userModel = _ref.read(userProvider)!;
    final res = await _noteRepository.deleteNote(noteID, userModel.uid);
    state = false;

    res.fold((l) {
      showsnackBars(context, "Cannot be  Deleted 😢😓", Pallete.redColor);
    }, (r) {
      showsnackBars(context, "Successfully Deleted 🤟 ✔️", Pallete.greenColor);
      // Navigator.pop(context);
    });
  }
}
