import 'package:drive_app/Features/Auth/Screens/Repositry/authRepo.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Home_page.dart';
import 'package:drive_app/Model/userModel.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final authCpntrollerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authRepository: ref.watch(authRepositiryProvider),
    ref: ref,
  );
});

final authStateChnagedProvider = StreamProvider((ref) {
  final authController = ref.watch(authCpntrollerProvider.notifier);

  return authController.authStateChnaged;
});

final Provider = StreamProvider.family((ref, String uid) {
  return ref.watch(authCpntrollerProvider.notifier).getUserdata(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChnaged => _authRepository.authState;
  void signInEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final user = await _authRepository.signInEmailandPassword(email, password);
    state = false;
    user.fold(
        (l) => {
              Fluttertoast.showToast(
                  gravity: ToastGravity.CENTER,
                  msg: "Error in creation of account 😓",
                  fontSize: 20,
                  backgroundColor: Pallete.redColor),
            },
        (r) => {
              _ref.read(userProvider.notifier).update((state) => r),
              Fluttertoast.showToast(
                msg: "Siggned In in suceesfully",
                backgroundColor: Pallete.greenColor,
                toastLength: Toast.LENGTH_LONG,
              ).then((value) => {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (route) => false,
                    ),
                  })
            });
  }

  void logInEmailAndPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final user = await _authRepository.logInEmailandPassword(email, password);
    state = false;
    user.fold(
      (l) => {
        Fluttertoast.showToast(
            gravity: ToastGravity.CENTER,
            fontSize: 20,
            msg: "Error in  logging in😰🥶",
            backgroundColor: Pallete.redColor),
      },
      (r) => {
        Fluttertoast.showToast(
          msg: "Logged In in suceesfully",
          backgroundColor: Pallete.greenColor,
          toastLength: Toast.LENGTH_LONG,
        ).then((value) async {
          UserModel userModel = await _authRepository.getUserdata(r.uid).first;
          // print(userModel.first)
          if (userModel != null) {
            _ref.read(userProvider.notifier).update((state) => userModel);
          }
        }).then((value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
            (route) => false,
          );
        })
      },
    );
  }

  Stream<UserModel> getUserdata(String uid) {
    return _authRepository.getUserdata(uid);
  }

  void logOut() {
    _ref.watch(userProvider.notifier).update((state) => null);
    _authRepository.logout();
  }
}
