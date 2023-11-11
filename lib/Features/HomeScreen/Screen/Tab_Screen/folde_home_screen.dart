import 'package:drive_app/Features/HomeScreen/Controllers/imagepost_controller.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Folder_Screen/Add_folder_screen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Folder_Screen/view_folder_image.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/constants/constants.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FolderHomeScreen extends ConsumerStatefulWidget {
  const FolderHomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FolderHomeScreenState();
}

class _FolderHomeScreenState extends ConsumerState<FolderHomeScreen> {
  void deleteFolder(String folderID, String folderName) {
    return ref
        .read(imageRepoConProvider.notifier)
        .deleteFolder(folderID: folderID, context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFolderScreen(),
              ),
            );
            // showDialog(
            //     context: context,
            //     builder: (BuildContext context) {
            //       return AlertDialog(
            //         actions: [
            //           Center(
            //             child: TextButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => const AddFolderScreen(),
            //                   ),
            //                 );
            //               },
            //               child: const Text(
            //                 "Create Folder",
            //                 style: TextStyle(
            //                     fontSize: 22,
            //                     color: Pallete.purpleColor,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           ),
            //           Center(
            //             child: TextButton(
            //               onPressed: () {
            //                 Navigator.pop(context);
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => const AddPage(),
            //                   ),
            //                 );
            //               },
            //               child: const Text(
            //                 "Add Image",
            //                 style: TextStyle(
            //                     fontSize: 22,
            //                     color: Pallete.purpleColor,
            //                     fontWeight: FontWeight.bold),
            //               ),
            //             ),
            //           )
            //         ],
            //       );
            //     });
          },
          backgroundColor: Pallete.yellowColor,
          heroTag: const Text("Add"),
          child: const Icon(
            Icons.add,
            color: Pallete.blackColor,
            size: 30,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 5),
            ref.watch(getFoldersProvider).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * .6,
                        child: const Center(
                          child: Text(
                            "Store Now ; Because its Free \n 😜❤️‍🔥",
                            style: TextStyle(
                              fontSize: 30,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 7,
                          crossAxisCount: 2,
                        ),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          final folder = data[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Pallete.folderBG,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    if (kDebugMode) {
                                      print("Delete");
                                      print(folder.folderId);
                                    }
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Center(
                                                    child: TextButton(
                                                      onPressed: () {
                                                        if (folder.noOfImages >
                                                            0) {
                                                          Navigator.pop(
                                                              context);
                                                          showsnackBars(
                                                              context,
                                                              "Folder Contains Images Cannot be Deleted",
                                                              Pallete.redColor);
                                                        } else {
                                                          deleteFolder(
                                                              folder.folderId,
                                                              folder
                                                                  .folderName);
                                                        }
                                                      },
                                                      child: const Text(
                                                        "Delete \t✔️",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Pallete
                                                                .redColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
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
                                                            color: Pallete
                                                                .greenColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        });
                                  },
                                  onTap: () {
                                    if (kDebugMode) {
                                      print("Pressed");
                                      print(folder.folderName);
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ViewFolderImage(
                                          folder.folderName,
                                          number: folder.noOfImages,
                                          folderId: folder.folderId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Image.asset(
                                    Constants.folder1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    folder.folderName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Pallete.whiteColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(errorMsg: error.toString()),
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
          ],
        ));
  }
}
