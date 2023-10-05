import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:drive_app/Features/HomeScreen/Controllers/imagepost_controller.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

class AddPage extends ConsumerStatefulWidget {
  const AddPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddPageState();
}

class _AddPageState extends ConsumerState<AddPage> {
  File? image;
  Future<void> selectedBannerFile() async {
    final res = await pickImage();
    if (res != null) {
      if (kIsWeb) {
        setState(() {
          image = res.files.first.bytes as File?;
        });
      }
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  void shareImage() {
    String fileName = path.basename(image!.path);
    ref
        .read(imageRepoConProvider.notifier)
        .shareImage(context: context, file: image, fileName: fileName);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(imageRepoConProvider);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Pallete.whiteColor,
        ),
        backgroundColor: Pallete.purpleColor,
        automaticallyImplyLeading: true,
        title: const Text(
          "Add Now",
          style: TextStyle(
            color: Pallete.whiteColor,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: EdgeInsets.symmetric(
                  vertical: size.height * .02, horizontal: size.width * .05),
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
                      child: image != null
                          ? Image.file(
                              image!,
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt_outlined, size: 40),
                            ),
                    ),
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (image != null) {
            shareImage();
          } else {
            Navigator.pop(context);
          }
        },
        backgroundColor: Pallete.purpleColor,
        heroTag: const Text("Add"),
        child: const Icon(
          Icons.check,
          color: Pallete.whiteColor,
          size: 30,
        ),
      ),
    );
  }
}
