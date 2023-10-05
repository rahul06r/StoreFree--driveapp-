import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/signin_button.dart';
import '../../../constants/constants.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Image.asset(
      //     Constants.logoPath,
      //     height: 40,
      //   ),
      //   actions: [],
      // ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "Store Anything",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Constants.logoPath,
              height: 400,
            ),
          ),
          const SizedBox(height: 20),
          const SignInButton(),
        ],
      ),
    );
  }
}
