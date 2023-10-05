import 'dart:io';

import 'package:drive_app/Features/HomeScreen/Controllers/note_controller.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Note_screen/add_note_screen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Note_screen/view_note_screen.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:printing/printing.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class NoteAppScreen extends ConsumerStatefulWidget {
  const NoteAppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteAppScreenState();
}

class _NoteAppScreenState extends ConsumerState<NoteAppScreen> {
  get name => null;

  void deletenote(BuildContext context, String noteID) {
    ref
        .read(noteControllerProvider.notifier)
        .deleteNote(noteID: noteID, context: context);
    if (kDebugMode) {
      print("Deleted");
    }
  }

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.purpleColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (contxet) => const AddNoteScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Pallete.whiteColor,
        ),
      ),
      body: Column(children: [
        ref.watch(getAllNotesProvider).when(
            data: (data) {
              if (data.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * .6,
                  child: const Center(
                      child: Text(
                    "Create Note Now ; Because its Free \n 😜📄",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  )),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final note = data[index];
                    final DateTime dateTime =
                        DateTime.fromMillisecondsSinceEpoch(
                            note.uploadTime.millisecondsSinceEpoch);

                    final String formattedDate =
                        DateFormat('dd-MM-yyyy').format(dateTime);
                    if (kDebugMode) {
                      print(formattedDate);
                    }

                    //
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(20),
                          flex: 2,
                          backgroundColor: Pallete.redColor,
                          icon: Icons.delete,
                          onPressed: (BuildContext context) {
                            deletenote(context, note.noteId);
                          },
                        )
                      ]),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewNoteScreen(
                                  textName: note.textName,
                                  descText: note.descText,
                                  createTime: note.uploadTime,
                                  isEdit: true,
                                  noteID: note.noteId,
                                ),
                              ));
                        },
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            height: 150,
                            width: MediaQuery.of(context).size.width * .8,
                            // width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.deepOrangeAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        note.textName,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          color: Pallete.whiteColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print("pressed");
                                          }

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewNoteScreen(
                                                  textName: note.textName,
                                                  descText: note.descText,
                                                  createTime: note.uploadTime,
                                                  isEdit: false,
                                                  noteID: note.noteId,
                                                ),
                                              ));
                                        },
                                        color: Pallete.whiteColor,
                                        icon: const Icon(
                                          Icons.edit_document,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    note.descText,
                                    maxLines: 2,
                                    overflow: TextOverflow.clip,
                                    style: const TextStyle(
                                      color: Pallete.whiteColor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        color: Pallete.whiteColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(errorMsg: error.toString()),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ))
      ]),
    );
  }
}
