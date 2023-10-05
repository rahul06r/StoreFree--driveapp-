// ignore: file_names
import 'package:drive_app/Features/HomeScreen/Screen/Tab_Screen/folde_home_screen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Tab_Screen/noteAppScreen.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentSelection = 0;
  final Map<int, Widget> _children = {
    0: const Text('Folder'),
    1: const Text('NotePad'),
  };
  final List<Widget> segmentsContent = [
    const FolderHomeScreen(),
    const NoteAppScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.purpleColor,
          toolbarHeight: 70,
          title: const Padding(
            padding: EdgeInsets.only(left: 5),
            child: Text(
              "Store Free",
              style: TextStyle(
                  color: Pallete.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return const AboutDialog(
                          applicationName: "Store Free",
                          applicationVersion: "1.0",
                          children: [
                            Center(
                              child: Text(
                                "Features to use",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("1) Create Folder."),
                                Text("2) Add Images , Video & PDF."),
                                Text("3) Add & Edit Notes."),
                                Text("4) Create PDF from Notes and Download"),
                              ],
                            )
                          ],
                        );
                      });
                },
                icon: const Icon(
                  Icons.question_mark,
                  color: Pallete.whiteColor,
                ))
          ],
        ),
        body: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: MaterialSegmentedControl(
                selectionIndex: _currentSelection,
                borderColor: Pallete.purpleColor,
                selectedColor: Pallete.otherpurpleColor,
                unselectedColor: Pallete.whiteColor,
                selectedTextStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800),
                unselectedTextStyle: const TextStyle(color: Pallete.blackColor),
                borderWidth: .2,
                borderRadius: 32,
                horizontalPadding: const EdgeInsets.only(top: 0),

                // disabledChildren: _disabledIndices,
                verticalOffset: 15,
                onSegmentTapped: (index) {
                  setState(() {
                    _currentSelection = index;
                  });
                },
                children: _children,
              ),
            ),
            Expanded(
              child: segmentsContent[_currentSelection],
            ),
          ],
        ),
      ),
    );
  }
}
