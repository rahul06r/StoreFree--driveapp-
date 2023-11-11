import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_app/Model/userModel.dart';
import 'package:drive_app/Providers/firebase_providers.dart';
import 'package:drive_app/constants/failure.dart';
import 'package:drive_app/constants/typedef.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final authRepositiryProvider = Provider((ref) {
  return AuthRepository(
      firebaseFirestore: ref.read(firestoreProvider),
      firebaseAuth: ref.read(authProvider));
});

class AuthRepository {
  final FirebaseFirestore _firebaseFirestore;
  final FirebaseAuth _auth;
  // final
  AuthRepository({
    required FirebaseFirestore firebaseFirestore,
    required FirebaseAuth firebaseAuth,
  })  : _auth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore;

  // signin

  CollectionReference get _users => _firebaseFirestore.collection("users");
  Stream<User?> get authState => _auth.authStateChanges();

  FutureEither<UserModel> signInEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            email: email, password: password, uid: userCredential.user!.uid);
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserdata(userCredential.user!.uid).first;
      }

      return right(userModel);

      //
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
      // print(e);
    }
  }

  // signup
  FutureEither<UserModel> logInEmailandPassword(
      String email, String password) async {
    try {
      //  Uuid uid=Uuid.v4();
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // UserModel user = UserModel(
      //     email: email, password: password, uid: userCredential.user!.uid);
      UserModel userModel = await getUserdata(userCredential.user!.uid).first;
      print(userModel.email);
      print(userModel.uid);
      // await _users.doc(userCredential.user!.uid).set(user.toMap());

      //

      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.toString()));
    } catch (e) {
      print("repo signin");
      return left(Failure(e.toString()));
    }
  }

  void logout() {
    _auth.signOut();
    print("logout");
  }

  Stream<UserModel> getUserdata(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
