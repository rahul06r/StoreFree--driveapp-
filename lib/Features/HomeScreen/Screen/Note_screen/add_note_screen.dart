import 'package:drive_app/Features/HomeScreen/Controllers/note_controller.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final TextEditingController _nametextEditingController =
      TextEditingController();
  final TextEditingController _desctextEditingController =
      TextEditingController();

  void addNote() {
    ref.read(noteControllerProvider.notifier).addNote(
        context: context,
        textName: _nametextEditingController.text,
        descText: _desctextEditingController.text);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nametextEditingController.dispose();
    _desctextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pallete.whiteColor),
        automaticallyImplyLeading: true,
        backgroundColor: Pallete.purpleColor,
        title: const Text(
          "Add Note",
          style:
              TextStyle(color: Pallete.whiteColor, fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text(
          "Save",
          style:
              TextStyle(color: Pallete.whiteColor, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(
          Icons.save,
          color: Pallete.whiteColor,
        ),
        onPressed: () {
          if (_nametextEditingController.text.isNotEmpty &&
              _desctextEditingController.text.isNotEmpty) {
            addNote();
            setState(() {
              _nametextEditingController.clear();
              _desctextEditingController.clear();
            });
            if (kDebugMode) {
              print("Got it");
            }
          } else {
            showsnackBars(context, "Fill All the fields", Pallete.blackColor);
          }
        },
        backgroundColor: Pallete.purpleColor,
      ),
      body: SingleChildScrollView(
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
                maxLength: 150,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
