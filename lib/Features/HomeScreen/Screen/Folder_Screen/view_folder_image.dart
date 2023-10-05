// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:drive_app/Features/HomeScreen/Controllers/imagepost_controller.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Folder_Screen/add_folder_image.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Image_Screen/nextScreen.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ViewFolderImage extends ConsumerStatefulWidget {
  final String folderName;
  final String folderId;
  final int number;
  const ViewFolderImage({
    super.key,
    required this.folderName,
    required this.folderId,
    required this.number,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ViewFolderImageState();
}

class _ViewFolderImageState extends ConsumerState<ViewFolderImage> {
  bool isSingleSelectedMenu = false;
  bool isCheckedDelete = false;
  @override
  void initState() {
    isCheckedDelete = false;
    super.initState();
  }

  void deleteFolder(String folderID) {
    ref
        .read(imageRepoConProvider.notifier)
        .deleteFolder(folderID: folderID, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(selectedImagesProvider.notifier).state;
    final particularFolder =
        ref.watch(getParticularFolderDeatilsProvider(widget.folderId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isSingleSelectedMenu ? Pallete.redColor : Pallete.purpleColor,
        iconTheme: const IconThemeData(color: Pallete.whiteColor),
        automaticallyImplyLeading: true,
        title: Text(
          widget.folderName,
          style: const TextStyle(
            color: Pallete.whiteColor,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String choice) {
              if (choice == 'Select') {
                if (particularFolder.value!.noOfImages > 0) {
                  setState(() {
                    isSingleSelectedMenu = !isSingleSelectedMenu;
                    selectedImages.clear();
                    if (kDebugMode) {
                      print(isSingleSelectedMenu);
                      print(selectedImages);
                    }
                  });
                } else {
                  showsnackBars(context, "Folder is Empty", Pallete.blackColor);
                }
              } else if (choice == 'Delete') {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(builder: (context, setState) {
                        return AlertDialog(
                          title: const Center(
                            child:
                                Text("Are you sure you want to delete it 🙄"),
                          ),
                          actions: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: isCheckedDelete,
                                        onChanged: (v) {
                                          setState(() {
                                            isCheckedDelete = v!;
                                          });
                                        }),
                                    const Text(
                                        "Once Deleted cannot be Retrived!🙄"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: TextButton(
                                        onPressed: () {
                                          if (isCheckedDelete) {
                                            deleteFolder(widget.folderId);

                                            Navigator.pop(context);
                                            showsnackBars(
                                                context,
                                                "Folder Deleted Successfully",
                                                Pallete.greenColor);
                                          } else {
                                            // setState(() {
                                            //   isCheckedDelete =
                                            //       !isCheckedDelete;
                                            // });
                                            Navigator.pop(context);
                                            showsnackBars(
                                                context,
                                                "Check the box",
                                                Pallete.redColor);
                                          }
                                        },
                                        child: const Text(
                                          "Delete ✔️",
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
                                          "Cancel ❎",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Pallete.greenColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        );
                      });
                    });
              } else {}
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Select",
                  child: isSingleSelectedMenu
                      ? const Text('Deselect')
                      : const Text('Select'),
                ),
                const PopupMenuItem<String>(
                  value: "Delete",
                  child: Text('Delete Folder'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            selectedImages.isNotEmpty ? Pallete.redColor : Pallete.purpleColor,
        onPressed: () {
          if (isSingleSelectedMenu) {
            ref
                .read(imageRepoConProvider.notifier)
                .deleteSelectedImages(context, widget.folderId);
            setState(() {
              isSingleSelectedMenu = !isSingleSelectedMenu;
              selectedImages.clear();
            });
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddImageFolder(
                  folderId: widget.folderId,
                ),
              ),
            );
          }
        },
        child: Icon(
          selectedImages.isNotEmpty ? Icons.delete : Icons.add,
          color: Pallete.whiteColor,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ref.watch(getFolderImagesProvider(widget.folderId)).when(
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
                    )),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 5,
                      crossAxisCount: 2,
                    ),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final image = data[index];

                      bool isSelected = selectedImages.contains(image.id);
                      if (kDebugMode) {
                        print(image.name);
                      }
                      return Container(
                          // height: 600,
                          // width: 200,
                          decoration: const BoxDecoration(
                            color: Pallete.otherImageBgColor,
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onLongPress: () {
                                          if (kDebugMode) {
                                            print("Delete");
                                          }
                                        },
                                        onTap: () {
                                          if (kDebugMode) {
                                            print("Pressed");
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NextScreen(
                                                image: image.url,
                                                ispdf:
                                                    image.name.contains(".pdf"),
                                                ismp4:
                                                    image.name.contains(".mp4"),
                                                isImage: image.name
                                                        .contains(".jpg") ||
                                                    image.name.contains(".png"),
                                              ),
                                            ),
                                          );
                                        },
                                        child: image.name.contains(".pdf")
                                            ? Image.asset(
                                                "assets/pdf2.png",
                                                fit: BoxFit.fill,
                                              )
                                            : image.name.contains(".mp4")
                                                ? Image.asset(
                                                    "assets/video4.png",
                                                    fit: BoxFit.fill,
                                                  )
                                                : image.name.contains(".jpg") ||
                                                        image.name
                                                            .contains(".png")
                                                    ? Image.network(
                                                        image.url,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        "assets/image2.png",
                                                        fit: BoxFit.fill,
                                                      ),
                                      ),
                                    ),

                                    // text
                                    const SizedBox(height: 10),
                                    // image.name.contains(".pdf") ||
                                    //         image.name.contains(".mp4")
                                    Text(
                                      image.name,
                                      style: const TextStyle(
                                          color: Pallete.blackColor,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              isSingleSelectedMenu
                                  ? Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Transform.scale(
                                        scale: 1.3,
                                        child: Checkbox(
                                            splashRadius: 5,
                                            checkColor: Pallete.whiteColor,
                                            activeColor: Pallete.redColor,
                                            side: const BorderSide(
                                              color: Pallete.purpleColor,
                                              width: 2,
                                            ),
                                            value: isSelected,
                                            onChanged: (v) {
                                              setState(() {
                                                if (isSelected) {
                                                  ref
                                                      .watch(
                                                          selectedImagesProvider
                                                              .notifier)
                                                      .state
                                                      .remove(image.id);
                                                } else {
                                                  ref
                                                      .watch(
                                                          selectedImagesProvider
                                                              .notifier)
                                                      .state
                                                      .add(image.id);
                                                }
                                              });

                                              if (kDebugMode) {
                                                print("v part $v");
                                                print(
                                                    "inside Checkbox $selectedImages");
                                              }
                                            }),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ));
                    },
                  ),
                );
              },
              error: (error, stackTrace) =>
                  ErrorText(errorMsg: error.toString()),
              loading: () => const Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
