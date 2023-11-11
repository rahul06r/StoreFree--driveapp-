import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;

import 'package:drive_app/Features/HomeScreen/Controllers/imagepost_controller.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';

class AddImageFolder extends ConsumerStatefulWidget {
  final String folderId;
  const AddImageFolder({super.key, required this.folderId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddImageFolderState();
}

class _AddImageFolderState extends ConsumerState<AddImageFolder> {
  late List<File?> image = [];
  List<String> fileName = [];
  Future<void> selectedBannerFile() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          // image=res.files
          // image = res.files.first.bytes as File?;
          image = res.paths.map((path) => File(path!)).toList();
        });
      }
      setState(() {
        image = res.paths.map((path) => File(path!)).toList();

        // print(image.);
        // image = File(res.files.first.path!);
      });
      for (var img in image) {
        String fileNames = path.basename(img!.path);

        fileName.add(fileNames);
      }
    }
  }

  void shareImage() {
    for (var img in image) {
      // final filename=img.path.
      String fileName = path.basename(img!.path);
      ref.read(imageRepoConProvider.notifier).shareImageToFolder(
            context: context,
            file: img,
            folderId: widget.folderId,
            fileName: fileName,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(imageRepoConProvider);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Pallete.blackColor,
        ),
        backgroundColor: Pallete.yellowColor,
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Now",
          style: TextStyle(
            color: Pallete.blackColor,
          ),
        ),
      ),
      body: Column(
        children: [
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * .02,
                    horizontal: size.width * .05,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      selectedBannerFile();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 7],
                        strokeCap: StrokeCap.round,
                        color: Pallete.blackColor,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: image.isNotEmpty
                ? ListView.builder(
                    itemCount: image.length,
                    itemBuilder: (BuildContext context, int index) {
                      final img = image[index];
                      final imgesName = fileName[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            vertical: size.height * .02,
                            horizontal: size.width * .05),
                        child: GestureDetector(
                          onTap: () {
                            selectedBannerFile();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 7],
                              strokeCap: StrokeCap.round,
                              color: Pallete.blackColor,
                              child: Container(
                                width: double.infinity,
                                height: 250,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: img!.path.contains(".pdf")
                                    ? Column(
                                        children: [
                                          Image.asset("assets/pdf2.png"),
                                          Text(imgesName)
                                        ],
                                      )
                                    : img.path.contains(".mp4")
                                        ? Column(
                                            children: [
                                              Image.asset("assets/video4.png"),
                                              Text(imgesName)
                                            ],
                                          )
                                        : img.path.contains(".zip")
                                            ? Column(
                                                children: [
                                                  Image.asset("assets/zip.png"),
                                                  Text(imgesName)
                                                ],
                                              )
                                            : Image.file(
                                                img,
                                                fit: BoxFit.fill,
                                              ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (image.isNotEmpty) {
            shareImage();
          } else {
            Fluttertoast.showToast(
                msg: "Add a PDF / Image / Video 🧐 🧐",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Pallete.redColor,
                textColor: Pallete.whiteColor,
                gravity: ToastGravity.CENTER,
                fontSize: 18);
            // Navigator.pop(context);
          }
        },
        backgroundColor: Pallete.yellowColor,
        heroTag: const Text("Add"),
        child: const Icon(
          Icons.check,
          color: Pallete.blackColor,
          size: 30,
        ),
      ),
    );
  }
}
