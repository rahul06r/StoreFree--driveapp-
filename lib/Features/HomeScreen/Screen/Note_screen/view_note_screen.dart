import 'package:drive_app/Features/HomeScreen/Controllers/note_controller.dart';
import 'package:drive_app/common/generate_pdf.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:drive_app/Themes/pallete.dart';

class ViewNoteScreen extends ConsumerStatefulWidget {
  final String textName;
  final String descText;
  final DateTime createTime;
  final bool isEdit;
  final String noteID;
  const ViewNoteScreen({
    super.key,
    required this.textName,
    required this.descText,
    required this.createTime,
    required this.isEdit,
    required this.noteID,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends ConsumerState<ViewNoteScreen> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _desctextEditingController =
      TextEditingController();

  bool isEdit = false;
  bool isGeneratingPdf = false;

  @override
  void initState() {
    _nametextEditingController.text = widget.textName;
    _desctextEditingController.text = widget.descText;
    isEdit = widget.isEdit;

    if (kDebugMode) {
      print(widget.isEdit);
    }

    super.initState();
  }

  void updateNote(
    String textName,
    String descText,
  ) {
    ref.read(noteControllerProvider.notifier).updateNote(
        context: context,
        textName: textName,
        descText: descText,
        noteId: widget.noteID);

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
    return Scaffold(
      // add feature of bg color
      // backgroundColor: Pallete.greenColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text("📝"),
        backgroundColor: Pallete.purpleColor,
        iconTheme: const IconThemeData(color: Pallete.whiteColor),
        actions: [
          PopupMenuButton<String>(onSelected: (String choice) {
            if (choice == "Edit") {
              setState(() {
                isEdit = !isEdit;
              });
            } else if (choice == "Delete") {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Delete Folder? 🧐",
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
            } else {}
          }, itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem(
                value: "Edit",
                child: isEdit ? const Text("Edit") : const Text("Close"),
              ),
              const PopupMenuItem(
                value: "Delete",
                child: Text("Delete"),
              ),
              const PopupMenuItem(
                value: "PDF",
                child: Text("Genearte PDF"),
              ),
            ];
          }),
        ],
      ),
      floatingActionButton: !isEdit
          ? FloatingActionButton.extended(
              backgroundColor: Pallete.purpleColor,
              onPressed: () {
                if (kDebugMode) {
                  print("Updated");
                }
                updateNote(_nametextEditingController.text,
                    _desctextEditingController.text);
              },
              label: const Text(
                "Update",
                style: TextStyle(color: Pallete.whiteColor),
              ),
              icon: const Icon(
                Icons.update,
                color: Pallete.whiteColor,
              ),
            )
          : null,
      body: isGeneratingPdf
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onTapOutside: (e) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      controller: _nametextEditingController,
                      maxLines: 1,
                      readOnly: isEdit,
                      maxLength: 150,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      // enabled: false,
                      readOnly: isEdit,
                      controller: _desctextEditingController,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
