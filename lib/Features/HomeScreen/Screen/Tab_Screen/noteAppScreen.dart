import 'package:drive_app/Features/HomeScreen/Controllers/note_controller.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Note_screen/add_note_screen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Note_screen/view_note_screen.dart';
import 'package:drive_app/Model/note_creation.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class NoteAppScreen extends ConsumerStatefulWidget {
  const NoteAppScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NoteAppScreenState();
}

class _NoteAppScreenState extends ConsumerState<NoteAppScreen> {
  final TextEditingController _passWordtextEditingController =
      TextEditingController();
  final TextEditingController _searchtextEditingController =
      TextEditingController();
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = ref.watch(noteControllerProvider);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.yellowColor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (contxet) => const AddNoteScreen()));
        },
        child: const Icon(
          Icons.add,
          color: Pallete.blackColor,
        ),
      ),
      body:
          // isLoading
          //     ? const Center(
          //         child: CircularProgressIndicator(),
          //       )
          //     :
          Column(children: [
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
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final note = data[index];
                    final DateTime dateTime =
                        DateTime.fromMillisecondsSinceEpoch(
                            note.uploadTime.millisecondsSinceEpoch);

                    final String formattedDate =
                        DateFormat('dd-MM-yyyy').format(dateTime);
                    if (kDebugMode) {
                      print("${formattedDate} ${note.textName}");
                    }

                    //
                    return Slidable(
                      endActionPane: note.isLocked
                          ? null
                          : ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  borderRadius: BorderRadius.circular(20),
                                  flex: 2,
                                  backgroundColor: Pallete.redColor,
                                  icon: Icons.delete,
                                  onPressed: (BuildContext context) {
                                    deletenote(context, note.noteId);
                                  },
                                )
                              ],
                            ),
                      child: GestureDetector(
                        onTap: () {
                          if (note.isLocked) {
                            // showsnackBars(context, "Locked", Pallete.redColor);
                            _passWordtextEditingController.clear();

                            Fluttertoast.showToast(
                              msg: "Locked Note",
                              gravity: ToastGravity.TOP,
                              backgroundColor: Pallete.redColor,
                            );

                            lockOpenDialog(context, note);
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewNoteScreen(
                                    isEdit: true,
                                    noteID: note.noteId,
                                    textName: note.textName,
                                    descText: note.descText,
                                  ),
                                ));
                          }
                        },
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            height: 150,
                            // height: !note.isLocked ? 150 : 120,
                            width: MediaQuery.of(context).size.width * .8,
                            // width: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: note.isLocked
                                  ? Pallete.redColor
                                  : Pallete.greenColor,
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
                                      Expanded(
                                        child: Text(
                                          note.textName,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            color: Pallete.whiteColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // !note.isLocked
                                      //     ? IconButton(
                                      //         onPressed: () {
                                      //           if (kDebugMode) {
                                      //             print(
                                      //                 "pressed ${note.noteId} ");
                                      //           }

                                      //           Navigator.push(
                                      //               context,
                                      //               MaterialPageRoute(
                                      //                 builder: (context) =>
                                      //                     ViewNoteScreen(
                                      //                   textName: note.textName,
                                      //                   descText: note.descText,
                                      //                   createTime:
                                      //                       note.uploadTime,
                                      //                   isEdit: false,
                                      //                   noteID: note.noteId,
                                      //                 ),
                                      //               ));
                                      //         },
                                      //         color: Pallete.whiteColor,
                                      //         icon: const Icon(
                                      //           Icons.edit_document,
                                      //           size: 18,
                                      //         ),
                                      //       )
                                      //     : Container(),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  !note.isLocked
                                      ? Text(
                                          note.descText,
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                          style: const TextStyle(
                                            color: Pallete.whiteColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      : const Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Icon(
                                              Icons.lock_person,
                                              color: Pallete.whiteColor,
                                            ),
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

  Future<dynamic> lockOpenDialog(BuildContext context, NoteModel note) {
    return showDialog(
        useSafeArea: true,
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              const SizedBox(height: 15),
              const Center(
                  child: Text(
                "Enter The Secret Key🧐",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              )),
              const SizedBox(height: 15),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextField(
                  obscureText: true,
                  onTapOutside: (e) {
                    _passWordtextEditingController.clear();
                    FocusManager.instance.primaryFocus?.unfocus();
                  },

                  onSubmitted: (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                    _passWordtextEditingController.clear();
                    if (e.isNotEmpty && e.length > 2) {
                      if (e == note.passWord) {
                        Navigator.pop(context);

                        showsnackBars(
                            context, "PassWord Correct😜", Pallete.greenColor);

                        // Fluttertoast.showToast(
                        //   msg: "PassWord Correct😜",
                        //   toastLength: Toast.LENGTH_LONG,
                        //   gravity: ToastGravity.CENTER,
                        //   backgroundColor: Pallete.greenColor,
                        // ).then((value) {
                        //   Future.delayed(const Duration(seconds: 2), () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ViewNoteScreen(
                        //             textName: note.textName,
                        //             descText: note.descText,
                        //             createTime: note.uploadTime,
                        //             isEdit: true,
                        //             noteID: note.noteId,
                        //           ),
                        //         ));
                        //   });
                        // });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewNoteScreen(
                                isEdit: true,
                                noteID: note.noteId,
                                textName: note.textName,
                                descText: note.descText,
                              ),
                            ));

                        //
                      } else {
                        _passWordtextEditingController.clear();
                        Navigator.pop(context);
                        showsnackBars(
                            context, "Wrong PassWord", Pallete.redColor);
                      }
                    } else {
                      Navigator.pop(context);
                      showsnackBars(
                          context,
                          "Password should be greater than 5",
                          Pallete.redColor);
                    }
                  },

                  controller: _passWordtextEditingController,
                  // maxLines: 2,
                  minLines: 1,
                  maxLength: 20,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 15),
            ],
          );
        });
  }
}
