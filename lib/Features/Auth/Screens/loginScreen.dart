import 'package:drive_app/Features/Auth/Screens/Controller/authController.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../constants/constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isLogin = true;

  void signup(
      {required String email,
      required String password,
      required BuildContext context}) {
    ref.read(authCpntrollerProvider.notifier).signInEmailAndPassword(
        email: email, password: password, context: context);
  }

  void login(
      {required String email,
      required String password,
      required BuildContext context}) {
    ref.read(authCpntrollerProvider.notifier).logInEmailAndPassword(
        email: email, password: password, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authCpntrollerProvider);
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Image.asset(
      //     Constants.logoPath,
      //     height: 40,
      //   ),
      //   actions: [],
      // ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    // const SizedBox(height: 30),
                    const Text(
                      "Store Anything",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: .5,
                      ),
                    ),
                    // const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.asset(
                        Constants.logoPath,
                        height: MediaQuery.of(context).size.height * .45,
                      ),
                    ),
                    // const SizedBox(height: 20),
                    Text(
                      isLogin
                          ? "Welcome back🥳"
                          : "Feel free to create Account here!😁",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        onTapOutside: (e) {
                          // _emailController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: _emailController,
                        maxLines: 1,
                        decoration: InputDecoration(
                            hintText: "Email",
                            labelText: "Email",
                            hintStyle: TextStyle(
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        onTapOutside: (e) {
                          // _emailController.clear();
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        controller: _passController,
                        maxLines: 1,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            labelText: "Password",
                            hintStyle: TextStyle(
                              fontSize: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallete.purpleColor,
                        ),
                        onPressed: () {
                          if (isLogin) {
                            if ((_emailController.text
                                    .toString()
                                    .contains("@")) &&
                                _passController.text.length < 4) {
                              Fluttertoast.showToast(
                                backgroundColor: Pallete.redColor,
                                msg: "Email or password doesnot match",
                              );
                            } else {
                              login(
                                email: _emailController.text,
                                password: _passController.text,
                                context: context,
                              );
                            }
                          } else {
                            if (!(_emailController.text
                                    .toString()
                                    .contains("@")) &&
                                _passController.text.length < 4) {
                              Fluttertoast.showToast(
                                backgroundColor: Pallete.redColor,
                                msg:
                                    "Email and password are not in correct format",
                              );
                            } else {
                              signup(
                                  email: _emailController.text,
                                  password: _passController.text,
                                  context: context);
                            }
                          }

                          _emailController.clear();
                          _passController.clear();
                        },
                        child: Text(
                          isLogin ? "Login" : "Sign in",
                          style: TextStyle(
                              color: Pallete.whiteColor, fontSize: 17),
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                            print(isLogin);
                          });
                        },
                        child: Text(
                          isLogin
                              ? "New user ? Create a Account here!\t😎"
                              : "Already have an Account!, Login\t 😎",
                          style: TextStyle(fontSize: 17),
                        ))

                    // use this button for google login
                    // const SignInButton(),
                  ],
                ),
              ),
            ),
    );
  }
}
