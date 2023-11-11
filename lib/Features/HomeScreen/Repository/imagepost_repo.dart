import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_app/Model/folder_creation.dart';
import 'package:drive_app/Model/image_model.dart';
import 'package:drive_app/Providers/firebase_providers.dart';
import 'package:drive_app/constants/failure.dart';
import 'package:drive_app/constants/firebase_constants.dart';
import 'package:drive_app/constants/typedef.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final imagePostProvider = Provider((ref) {
  final fire = ref.watch(firestoreProvider);
  final store = ref.watch(storageProvider);
  return ImagePostRepo(firebaseFirestore: fire, storage: store);
});

class ImagePostRepo {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseStorage _storage;

  ImagePostRepo({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseStorage storage,
  })  : _firebaseFirestore = firebaseFirestore,
        _storage = storage;

  //
  CollectionReference get _images =>
      _firebaseFirestore.collection(FirebaseConstants.imageCollection);

  CollectionReference get _folderName =>
      _firebaseFirestore.collection(FirebaseConstants.folderName);
  CollectionReference get _users =>
      _firebaseFirestore.collection(FirebaseConstants.userCollection);

//if u want the image to be in outside the  folder
  FutureVoid addImage(ImagePost post) async {
    try {
      return right(
        _images.doc(post.id).set(
              post.toMap(),
            ),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  ////if u want the image to be in outside the  folder

  Stream<List<ImagePost>> getImages() {
    return _images.snapshots().map(
          (event) => event.docs
              .map((e) => ImagePost.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }

  // folder part inside

  FutureVoid addNewFolder(FolderCreate folder, String uID) async {
    try {
      // var foldersNameExist = await _folderName.doc(folder.folderName).get();
      // var foldersNameExist = await _folderName
      //     .where('folderName', isEqualTo: folder.folderName)
      //     .get();

      var foldersNameExist = await _users
          .doc(uID)
          .collection("folder")
          .where('folderName', isEqualTo: folder.folderName)
          .get();

      if (foldersNameExist.docs.isNotEmpty) {
        // print("Folder name exists");

        throw "Folder Name Already Exists 🙄";
      } else {
        return right(
          _users
              .doc(uID)
              .collection("folder")
              .doc(folder.folderId)
              .set(folder.toMap()),
        );
        // return right(
        //   _folderName.doc(folder.folderId).set(
        //         folder.toMap(),
        //       ),
        // );
      }
    } catch (e) {
      return left(
        Failure(e.toString()),
      );
    }
  }

  // delete the folder

  FutureVoid deleteFolder(String folderID, String uID) async {
    try {
      print("${folderID} is deleted");
      return right(
        _users.doc(uID).collection("folder").doc(folderID).delete(),
      );
      // return right(
      //   _folderName.doc(folderID).delete().then((value) {
      //     // deleteSelectedImages(

      //     // ),
      //   }),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // Stream<FolderCreate> getParticularFolderDeatils(String folderID, String uID) {
  //   // return right(_users
  //   //     .doc(uID)
  //   //     .collection("folder")
  //   //     .doc(folderID)
  //   //     .snapshots()
  //   //     .map((event) =>
  //   //         FolderCreate.fromMap(event.data() as Map<String, dynamic>)));

  //   return _folderName.doc(folderID).snapshots().map(
  //       (event) => FolderCreate.fromMap(event.data() as Map<String, dynamic>));
  // }
  Stream<FolderCreate> getParticularFolderDeatils(String folderID, String uID) {
    return _users.doc(uID).collection("folder").doc(folderID).snapshots().map(
        (event) => FolderCreate.fromMap(event.data() as Map<String, dynamic>));

    // think about implementing right(use try catch once) ......!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  }

  Stream<List<FolderCreate>> getFolders(String uID) {
    return _users.doc(uID).collection("folder").snapshots().map((event) => event
        .docs
        .map((e) => FolderCreate.fromMap(e.data() as Map<String, dynamic>))
        .toList());

    // return _folderName.snapshots().map((event) => event.docs
    //     .map((e) => FolderCreate.fromMap(e.data() as Map<String, dynamic>))
    //     .toList());
  }

  // add image to paricular folder
  // ignore: void_checks
  // if u want random id then go with add or u want a specific id as same as imgId then go with Set
  // _folderName
  //     .doc(folderId)
  //     .collection("images")
  //     .add(
  //       post.toMap(),
  //     )
  //     .then((value) {
  //   _folderName.doc(folderId).update({
  //     "noOfImages": FieldValue.increment(1),
  //   });
  // }),

  //
  FutureVoid addImageToFolder(
      ImagePost post, String folderId, String uID) async {
    try {
      return right(_users
          .doc(uID)
          .collection("folder")
          .doc(folderId)
          .collection("images")
          .doc(post.id)
          .set(post.toMap())
          .then((value) {
        _users
            .doc(uID)
            .collection("folder")
            .doc(folderId)
            .update({"noOfImages": FieldValue.increment(1)});
      }));

      // chnage it to folder collection above
      // return right(
      //   _folderName
      //       .doc(folderId)
      //       .collection("images")
      //       .doc(post.id)
      //       .set(post.toMap())
      //       .then((value) {
      //     _folderName.doc(folderId).update({
      //       "noOfImages": FieldValue.increment(1),
      //     });
      //   }),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //
  Stream<List<ImagePost>> getFolderImages(String folderId, String uID) {
    return _users
        .doc(uID)
        .collection("folder")
        .doc(folderId)
        .collection("images")
        .orderBy("uploadTime", descending: true)
        .snapshots()
        .map((event) => event.docs
            .map((e) => ImagePost.fromMap(e.data() as Map<String, dynamic>))
            .toList());

    // return _folderName
    //     .doc(folderId)
    //     .collection("images")
    //     .orderBy("uploadTime", descending: true)
    //     .snapshots()
    //     .map((event) => event.docs
    //         .map((e) => ImagePost.fromMap(e.data() as Map<String, dynamic>))
    //         .toList());
  }

  FutureVoid deleteSelectedImages(
      String folderId, String imgID, String uID) async {
    try {
      return right(_users
          .doc(uID)
          .collection("folder")
          .doc(folderId)
          .collection("images")
          .doc(imgID)
          .delete()
          .then((value) {
        _users
            .doc(uID)
            .collection("folder")
            .doc(folderId)
            .update({"noOfImages": FieldValue.increment(-1)}).then((value) {
          _storage.ref().child("postedImage").child(imgID).delete();
        });
      }));

      // return right(
      //   _folderName
      //       .doc(folderId)
      //       .collection("images")
      //       .doc(imgID)
      //       .delete()
      //       .then((value) {
      //     _folderName.doc(folderId).update({
      //       "noOfImages": FieldValue.increment(-1),
      //     });
      //   }).then((value) {
      //     _storage.ref().child("postedImage").child(imgID).delete();
      //   }),
      // );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid editFolderName(
      String folderId, String uID, String updatedFName) async {
    try {
      return right(
        _users.doc(uID).collection("folder").doc(folderId).update({
          "folderName": updatedFName,
        }),
      );
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
