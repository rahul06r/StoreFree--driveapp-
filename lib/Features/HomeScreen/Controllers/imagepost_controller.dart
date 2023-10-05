import 'dart:io';
import 'package:drive_app/Features/HomeScreen/Repository/imagepost_repo.dart';
import 'package:drive_app/Model/folder_creation.dart';
import 'package:drive_app/Model/image_model.dart';
import 'package:drive_app/Providers/storage_provider.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/constants/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final imageRepoConProvider = StateNotifierProvider<ImagePostCon, bool>((ref) {
  final imagerepo = ref.watch(imagePostProvider);
  final storagerepo = ref.watch(firebaseStroageProvider);
  return ImagePostCon(
    imagePostRepo: imagerepo,
    ref: ref,
    storageRepository: storagerepo,
  );
});

final getUserImagesProvider = StreamProvider((ref) {
  return ref.read(imageRepoConProvider.notifier).getImages();
});

final getFoldersProvider = StreamProvider((ref) {
  return ref.read(imageRepoConProvider.notifier).getFolders();
});

final getFolderImagesProvider = StreamProvider.family((ref, String id) {
  return ref.read(imageRepoConProvider.notifier).getFolderImages(id);
});

final getParticularFolderDeatilsProvider =
    StreamProvider.family((ref, String folderID) {
  return ref
      .read(imageRepoConProvider.notifier)
      .getParticularFolderDeatils(folderID: folderID);
});

final selectedImagesProvider = StateProvider<List<dynamic>>((ref) => []);
//
//
//
// final selectedImagesProvider = StateProvider((ref) {
//   return [];
// });

class ImagePostCon extends StateNotifier<bool> {
  final ImagePostRepo _imagePostRepo;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ImagePostCon(
      {required ImagePostRepo imagePostRepo,
      required Ref ref,
      required StorageRepository storageRepository})
      : _imagePostRepo = imagePostRepo,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);

  //

  void shareImage({
    required BuildContext context,
    required File? file,
    required String fileName,
  }) async {
    state = true;
    String id = const Uuid().v1();

    final imageRes = await _storageRepository.storeFile(
      path: "postedImage",
      id: id,
      file: file,
    );

    imageRes.fold((l) {
      if (kDebugMode) {
        print("failed");
      }
      if (kDebugMode) {
        print(l);
      }
    }, (r) async {
      final ImagePost imagePost = ImagePost(id: id, url: r, name: fileName);

      final res = await _imagePostRepo.addImage(imagePost);
      state = false;
      if (kDebugMode) {
        print("PATH is $r");
      }

      res.fold((l) {
        if (kDebugMode) {
          print("Denied");
        }
      }, (r) {
        if (kDebugMode) {
          print("ss");
        }
        Navigator.pop(context);
      });
    });
  }

  //

  Stream<List<ImagePost>> getImages() {
    return _imagePostRepo.getImages();
  }

  Stream<List<ImagePost>> getFolderImages(String folderId) {
    return _imagePostRepo.getFolderImages(folderId);
  }

  //Folder work here
  void addNewFolder({
    required BuildContext context,
    required String folderName,
  }) async {
    state = true;

    String folderId = const Uuid().v4();

    // create

    final FolderCreate folderCreate = FolderCreate(
      folderId: folderId,
      createdAt: DateTime.now(),
      noOfImages: 0,
      folderName: folderName,
    );

    final res = await _imagePostRepo.addNewFolder(folderCreate);
    state = false;

    res.fold((l) {
      showsnackBars(context, l.message, Pallete.redColor);
      if (kDebugMode) {
        print("Denied");
      }
    }, (r) {
      if (kDebugMode) {
        print("ss");
      }
      showsnackBars(context, "Successfully Created 🤟", Pallete.greenColor);
      // Navigator.pop(context);
    });
  }
  //
  // delete folder

  void deleteFolder(
      {required String folderID, required BuildContext context}) async {
    final res = await _imagePostRepo.deleteFolder(folderID);
    res.fold((l) {
      showsnackBars(context, l.message, Pallete.redColor);
      if (kDebugMode) {
        print("Cannot be Deleted ");
      }
    }, (r) async {
      deleteSelectedImages(context, folderID);

      if (kDebugMode) {
        print("Deleted Succesfully");
      }

      // delete the storage images

      Navigator.pop(context);
      showsnackBars(context, "Successfully Deleted  🤟", Pallete.greenColor);
    });
  }

  //

  //

  Stream<FolderCreate> getParticularFolderDeatils({required String folderID}) {
    return _imagePostRepo.getParticularFolderDeatils(folderID);
  }

  Stream<List<FolderCreate>> getFolders() {
    return _imagePostRepo.getFolders();
  }

  // add image to particular folder

  //
  void shareImageToFolder({
    required BuildContext context,
    required File? file,
    required String folderId,
    required String fileName,
  }) async {
    state = true;
    String id = const Uuid().v1();

    final imageRes = await _storageRepository.storeFile(
      path: "postedImage",
      id: id,
      file: file,
    );

    imageRes.fold((l) {
      if (kDebugMode) {
        print("failed");
      }
      if (kDebugMode) {
        print(l);
      }
    }, (r) async {
      final ImagePost imagePost = ImagePost(id: id, url: r, name: fileName);

      final res = await _imagePostRepo.addImageToFolder(imagePost, folderId);
      state = false;
      if (kDebugMode) {
        print("PATH is $r");
      }

      res.fold((l) {
        showsnackBars(context, l.message, Pallete.redColor);
        if (kDebugMode) {
          print("Denied");
        }
      }, (r) {
        if (kDebugMode) {
          print("ss");
        }
        Navigator.pop(context);
        showsnackBars(context, "Successfully Created 🤟", Pallete.greenColor);
      });
    });
  }

  void deleteSelectedImages(BuildContext context, String folderId) async {
    final selectedImages =
        List<String>.from(_ref.read(selectedImagesProvider.notifier).state);

    for (var img in selectedImages) {
      if (kDebugMode) {
        print("This is in controller part id $img");
      }
      final res = await _imagePostRepo.deleteSelectedImages(folderId, img);

      res.fold((l) {
        showsnackBars(context, l.message, Pallete.redColor);
        if (kDebugMode) {
          print("Not Deleted Images");
        }
      }, (r) {
        if (kDebugMode) {
          print("Deleted $img");
        }
        // Remove the item from the copied list
        _ref.read(selectedImagesProvider.notifier).state.remove(img);
        showsnackBars(
            context, "Deleted Successfully Images 🤟", Pallete.greenColor);
      });
    }
    // Clear the original list
    _ref.read(selectedImagesProvider.notifier).state.clear();
  }
}
