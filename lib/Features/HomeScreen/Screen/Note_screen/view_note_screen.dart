import 'package:drive_app/Features/HomeScreen/Controllers/note_controller.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/common/generate_pdf.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drive_app/Themes/pallete.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ViewNoteScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final String noteID;
  final String textName;
  final String descText;
  const ViewNoteScreen({
    super.key,
    required this.isEdit,
    required this.noteID,
    required this.textName,
    required this.descText,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends ConsumerState<ViewNoteScreen> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _desctextEditingController =
      TextEditingController();
  final TextEditingController _passWordtextEditingController =
      TextEditingController();

  bool isEdit = false;
  bool isGeneratingPdf = false;

  void updatePassword({
    required String noteID,
    required String passWord,
    required bool isLocked,
  }) {
    ref.read(noteControllerProvider.notifier).updatePassword(
          passWord: passWord,
          noteID: noteID,
          context: context,
          isLocked: isLocked,
        );
  }

  @override
  void initState() {
    _nametextEditingController.text = widget.textName;
    _desctextEditingController.text = widget.descText;
    isEdit = widget.isEdit;

    if (kDebugMode) {
      // print(_passWordtextEditingController.text);
      // print("${widget.createTime} Created time");
      // print(widget.)
    }

    super.initState();
  }

  void updateNote(
      String textName, String descText, bool isLocked, String passWord) {
    ref.read(noteControllerProvider.notifier).updateNote(
        context: context,
        textName: textName,
        descText: descText,
        noteId: widget.noteID,
        isLocked: isLocked,
        passWord: passWord);
    // setState(() {
    //   _nametextEditingController.text = textName;
    //   _desctextEditingController.text = descText;
    // });

    setState(() {
      isEdit = !isEdit;
    });
  }

  void deletenote(BuildContext context, String noteID) {
    ref
        .read(noteControllerProvider.notifier)
        .deleteNote(noteID: noteID, context: context);
    Navigator.pop(context);
    if (kDebugMode) {
      print("Deleted");
    }
  }

  Future<void> generatePDf(
      String textName, String descName, BuildContext context) async {
    setState(() {
      isGeneratingPdf = true;
    });

    await GenearteApp.generatePdfAndSave(textName, descName, context);

    setState(() {
      isGeneratingPdf = false;
    });
  }

  //

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(getParticularNoteProvider(widget.noteID));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("📝"),
        backgroundColor: Pallete.yellowColor,
        iconTheme: const IconThemeData(color: Pallete.blackColor),
        actions: [
          PopupMenuButton<String>(onSelected: (String choice) {
            if (choice == "Edit") {
              setState(() {
                isEdit = !isEdit;
                // _nametextEditingController.text = widget.textName;
                // _desctextEditingController.text = widget.descText;
              });
            } else if (choice == "Delete") {
              deleteDialog(context);

              //

              if (kDebugMode) {
                print("Deleted Sucessfully");
              }
            } else if (choice == "PDF") {
              if (kDebugMode) {
                print("PDF Sucessfully");
              }
              if (isEdit) {
                generatePDf(
                  _nametextEditingController.text,
                  _desctextEditingController.text,
                  context,
                );
              } else {
                showsnackBars(
                    context,
                    "Please Complete the Edit & save!!!😰\nThen generate PDF",
                    Pallete.redColor);
              }
            }
            if (choice == "Lock") {
              //
              //
              notes.value!.isLocked
                  ? showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: [
                            const SizedBox(height: 15),
                            const Center(
                                child: Text(
                              "Enter The Secret Key🧐",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 17),
                            )),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
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
                                    if (e == notes.value!.passWord) {
                                      // Fluttertoast.showToast(msg: "Correct");

                                      updatePassword(
                                          noteID: widget.noteID,
                                          passWord: "",
                                          isLocked: false);
                                      Navigator.pop(context);

                                      showsnackBars(
                                          context,
                                          "PassWord Unlocked 😜",
                                          Pallete.greenColor);

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
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //       builder: (context) => ViewNoteScreen(
                                      //         textName: note.textName,
                                      //         descText: note.descText,
                                      //         createTime: note.uploadTime,
                                      //         isEdit: true,
                                      //         noteID: note.noteId,
                                      //       ),
                                      //     ));

                                      //
                                    } else {
                                      _passWordtextEditingController.clear();
                                      Navigator.pop(context);
                                      showsnackBars(context, "Wrong PassWord",
                                          Pallete.redColor);
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
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            const SizedBox(height: 15),
                          ],
                        );
                      })
                  : showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          backgroundColor: Pallete.yellowColor,
                          children: [
                            const Center(
                                child: Text("Enter The Secret Key to Lock🧐",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17))),
                            const SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: TextField(
                                onTapOutside: (e) {
                                  _passWordtextEditingController.clear();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },

                                onSubmitted: (e) {
                                  if (e.isNotEmpty && e.length >= 2) {
                                    _passWordtextEditingController.clear();
                                    if (kDebugMode) {
                                      print("updated ${e}");
                                    }
                                    showsnackBars(
                                        context,
                                        "PassWord Updated 😜",
                                        Pallete.greenColor);

                                    updatePassword(
                                      noteID: widget.noteID,
                                      passWord: e,
                                      isLocked: true,
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Password should be greater than 6",
                                      gravity: ToastGravity.CENTER,
                                      toastLength: Toast.LENGTH_LONG,
                                    );
                                    Navigator.pop(context);
                                    // Navigator.pop(context);
                                  }
                                },

                                controller: _passWordtextEditingController,
                                // maxLines: 2,
                                minLines: 1,
                                maxLength: 20,
                                decoration: InputDecoration(
                                    focusColor: Pallete.blackColor,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Pallete.blackColor)),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Pallete.blackColor),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            // Center(
                            //   child: ElevatedButton(
                            //     style: ElevatedButton.styleFrom(
                            //       fixedSize: Size(120, 30),
                            //       backgroundColor: Pallete.blackColor,
                            //     ),
                            //     onPressed: () {
                            //       if (_passWordtextEditingController
                            //               .text.isNotEmpty &&
                            //           _passWordtextEditingController
                            //                   .text.length >=
                            //               2) {
                            //         _passWordtextEditingController.clear();
                            //         if (kDebugMode) {
                            //           print(
                            //               "updated ${_passWordtextEditingController.text}");
                            //         }
                            //         showsnackBars(
                            //             context,
                            //             "PassWord Updated 😜",
                            //             Pallete.greenColor);

                            //         updatePassword(
                            //           noteID: widget.noteID,
                            //           passWord:
                            //               _passWordtextEditingController.text,
                            //           isLocked: true,
                            //         );
                            //       } else {
                            //         Fluttertoast.showToast(
                            //           msg: "Password should be greater than 6",
                            //           gravity: ToastGravity.CENTER,
                            //           toastLength: Toast.LENGTH_LONG,
                            //         );
                            //         Navigator.pop(context);
                            //         // Navigator.pop(context);
                            //       }
                            //       print("Pressed Updated button");

                            //       setState(() {
                            //         print("inside setstae");
                            //         print(_passWordtextEditingController.text);
                            //       });
                            //     },
                            //     child: Text(
                            //       "Update",
                            //       style: TextStyle(
                            //         color: Pallete.whiteColor,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            const SizedBox(height: 15),
                          ],
                        );
                      });
            } else {}
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "Edit",
                child: isEdit ? const Text("Edit") : const Text("Close"),
              ),
              PopupMenuItem(
                value: "Delete",
                child: Text("Delete"),
                enabled: isEdit ? true : false,
              ),
              PopupMenuItem(
                value: "PDF",
                child: Text("Genearte PDF"),
                enabled: isEdit ? true : false,
              ),
              PopupMenuItem(
                value: "Lock",
                child: notes.value!.isLocked
                    ? const Text("Unlock Note")
                    : const Text("Lock Note"),
                enabled: isEdit ? true : false,
              ),
            ];
          }),
        ],
      ),
      floatingActionButton: !isEdit
          ? FloatingActionButton.extended(
              backgroundColor: Pallete.yellowColor,
              onPressed: () {
                if (kDebugMode) {
                  print("Updated");
                  print("Lock status: ${notes.value!.isLocked}");
                  print("Lock status: ${notes.value!.textName}");
                  print("Lock status: ${notes.value!.descText}");
                }

                updateNote(
                  _nametextEditingController.text,
                  _desctextEditingController.text,
                  notes.value!.isLocked,
                  notes.value!.passWord!,
                );
                setState(() {});
              },
              label: const Text(
                "Update",
                style: TextStyle(color: Pallete.blackColor),
              ),
              icon: const Icon(
                Icons.update,
                color: Pallete.blackColor,
              ),
            )
          : null,
      body: isGeneratingPdf
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: ref.watch(getParticularNoteProvider(widget.noteID)).when(
                  data: (data) {
                    final DateTime dateTime =
                        DateTime.fromMillisecondsSinceEpoch(
                            data.uploadTime.millisecondsSinceEpoch);

                    final String formattedDate =
                        DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);

                    // check for the update state here of the contorller
                    // _nametextEditingController.text = data.textName;
                    // _desctextEditingController.text = data.descText;

                    // setState(() {
                    //   _nametextEditingController.text = data.textName;
                    //   _desctextEditingController.text = data.descText;
                    // });
                    return Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Last Updated on ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${formattedDate}")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onTapOutside: (e) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: _nametextEditingController,
                            // maxLines: data.textName.length > 50 ? 2 : 1,
                            maxLines: 2,
                            readOnly: isEdit,
                            maxLength: 150,
                            decoration: InputDecoration(
                                label: Text("Title"),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.purpleColor,
                                  fontSize: 20,
                                ),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderSide: BorderSide(
                                      color: Pallete.blackColor, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            onTapOutside: (e) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            controller: _desctextEditingController,
                            maxLines: null,
                            readOnly: isEdit,
                            // maxLength: 150,
                            decoration: InputDecoration(
                                label: Text("Description"),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Pallete.purpleColor,
                                  fontSize: 20,
                                ),
                                border: OutlineInputBorder(
                                  gapPadding: 10,
                                  borderSide: BorderSide(
                                      color: Pallete.blackColor, width: 3),
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                        ),
                      ],
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(errorMsg: error.toString()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator())),
            ),
    );
  }

  Future<dynamic> deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Delete Note? 🧐",
                  style: TextStyle(
                    color: Pallete.purpleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Center(
                    child: TextButton(
                      onPressed: () {
                        deletenote(context, widget.noteID);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Delete \t✔️",
                        style: TextStyle(
                            fontSize: 16,
                            color: Pallete.redColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Cancel \t ❌",
                        style: TextStyle(
                            fontSize: 16,
                            color: Pallete.greenColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
