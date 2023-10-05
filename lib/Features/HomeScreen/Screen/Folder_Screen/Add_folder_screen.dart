import 'package:drive_app/Features/HomeScreen/Controllers/imagepost_controller.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFolderScreen extends ConsumerStatefulWidget {
  const AddFolderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFolderScreenState();
}

class _AddFolderScreenState extends ConsumerState<AddFolderScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void createFolder() {
    ref.read(imageRepoConProvider.notifier).addNewFolder(
          context: context,
          folderName: _textEditingController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Pallete.whiteColor,
        ),
        backgroundColor: Pallete.purpleColor,
        automaticallyImplyLeading: true,
        title: const Text(
          "Folders",
          style: TextStyle(
            color: Pallete.whiteColor,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: _focusNode,
              onTapOutside: (e) {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              controller: _textEditingController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    onPressed: () {
                      if (_textEditingController.text.isNotEmpty) {
                        createFolder();
                        _focusNode.unfocus();
                        _textEditingController.clear();
                      } else {
                        showsnackBars(
                            context, "Enter the folder name", Pallete.redColor);
                        _focusNode.unfocus();
                      }
                    },
                    icon: const Icon(
                      Icons.send_outlined,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Pallete.purpleColor,
                    )),
                labelText: "Folder Name",
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Your Folders",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Column(
              children: [
                ref.watch(getFoldersProvider).when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Expanded(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * .6,
                            child: const Center(
                                child: Text(
                              "Create and Store in StoreFree \n 😜📂👌",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            )),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            final folder = data[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    Text(
                                      folder.folderName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        folder.noOfImages.toString(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          },
                        ),
                      );
                    },
                    error: (errorText, stackTrace) => ErrorText(
                          errorMsg: errorText.toString(),
                        ),
                    loading: () => const Center(
                          child: CircularProgressIndicator(),
                        )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
