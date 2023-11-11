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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewFolderImage extends ConsumerStatefulWidget {
  final String folderId;
  String folderName;
  final int number;
  ViewFolderImage(
    this.folderName, {
    super.key,
    // required
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
  TextEditingController _folderNameEdit = TextEditingController();
  @override
  void initState() {
    isCheckedDelete = false;
    _folderNameEdit.text = widget.folderName;
    super.initState();
  }

  void deleteFolder(String folderID) {
    ref
        .read(imageRepoConProvider.notifier)
        .deleteFolder(folderID: folderID, context: context);
  }

  void updateFolderName(
    String folderId,
    String updatedFName,
  ) {
    ref.read(imageRepoConProvider.notifier).editFolderName(
          folderId: folderId,
          updatedFName: updatedFName,
          context: context,
        );
    setState(() {});
    // widget.folderName = _folderNameEdit.text;

    // Update widget.folderName directly within the callback
    // setState(() {
    //   widget.folderName = _folderNameEdit.text;
    // });
  }

  @override
  Widget build(BuildContext context) {
    final selectedImages = ref.watch(selectedImagesProvider.notifier).state;
    final particularFolder =
        ref.watch(getParticularFolderDeatilsProvider(widget.folderId));
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isSingleSelectedMenu ? Pallete.redColor : Pallete.yellowColor,
        iconTheme: const IconThemeData(color: Pallete.blackColor),
        automaticallyImplyLeading: true,
        title: TextField(
          controller: _folderNameEdit,
          onTapOutside: (e) {
            setState(() {
              _folderNameEdit.text = widget.folderName;
            });
            FocusManager.instance.primaryFocus?.unfocus();
          },
          expands: false,
          readOnly: true,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            disabledBorder: InputBorder.none,
            // enabled: false,
            border: InputBorder.none,
          ),
        ),
        //  particularFolder.value!.folderName.
        // ?
        //  Text(
        //     particularFolder.value!.folderName,
        //     // widget.folderName,
        //     style: const TextStyle(
        //       color: Pallete.blackColor,
        //     ),
        //   )
        // :

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
              } else if (choice == 'Edit_Name') {
                showDialog(
                    useSafeArea: true,
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        backgroundColor: Pallete.yellowColor,
                        children: [
                          SizedBox(height: 12),
                          Center(
                            child: Text(
                              "Folder Name Edit",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Pallete.blackColor),
                            ),
                          ),
                          SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              // enabled: false,
                              controller: _folderNameEdit,
                              maxLines: null,
                              onTapOutside: (e) {
                                setState(() {});
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                  focusColor: Pallete.blackColor,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Pallete.blackColor)),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Pallete.blackColor),
                                  ),
                                  hintText: "Folder Name",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  // label: Text("Description"),

                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          ),
                          SizedBox(height: 12),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(120, 30),
                                backgroundColor: Pallete.blackColor,
                              ),
                              onPressed: () {
                                print("Pressed Updated button");
                                updateFolderName(
                                    widget.folderId, _folderNameEdit.text);
                                // Navigator.pop(context);

                                // setState(() {
                                //   // widget.folderName = _folderNameEdit.text;
                                //   // print("inside setstae");
                                //   // print(
                                //   //     "folder name scree     ${_folderNameEdit.text}");
                                //   // print(
                                //   //     "folder name scree     ${widget.folderName}");
                                // });
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(
                                  color: Pallete.whiteColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                        ],
                      );
                    });
              } else if (choice == 'Lock_Folder') {
                Fluttertoast.showToast(
                    fontSize: 20,
                    msg: "Will bring this feature very soon 😎",
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: Pallete.deepOrangeColor,
                    textColor: Pallete.whiteColor,
                    gravity: ToastGravity.CENTER);
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
                PopupMenuItem<String>(
                  enabled: isSingleSelectedMenu ? false : true,
                  value: "Delete",
                  child: Text('Delete Folder'),
                ),
                PopupMenuItem<String>(
                  enabled: isSingleSelectedMenu ? false : true,
                  value: "Edit_Name",
                  child: Text('Edit Name'),
                ),
                PopupMenuItem<String>(
                  enabled: isSingleSelectedMenu ? false : true,
                  value: "Lock_Folder",
                  child: Text('Lock Folder'),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            selectedImages.isNotEmpty ? Pallete.redColor : Pallete.yellowColor,
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
          color: Pallete.blackColor,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          ref.watch(getFolderImagesProvider(widget.folderId)).when(
              data: (data) {
                if (data.isEmpty) {
                  return Expanded(
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
                        // print(image.name);
                        // print(image.url);
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
                                          print("Pressed ${image.url}");
                                        },
                                        onTap: () {
                                          if (kDebugMode) {
                                            print("Pressed ${image.url}");
                                            print("Pressed ${widget.folderId}");
                                          }

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NextScreen(
                                                name: image.name,
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
                                                    ? CachedNetworkImage(
                                                        imageUrl: image.url,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CircularProgressIndicator()),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error))
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
