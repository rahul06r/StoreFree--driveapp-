import 'package:drive_app/Themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/constants.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        // onPressed: () => signInWithGoogle(ref, context),
        onPressed: () {},
        icon: Image.asset(
          Constants.googlePath,
          width: 45,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 20,
            color: Pallete.whiteColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color.fromARGB(255, 110, 173, 224),
          minimumSize: const Size(double.infinity, 60),
        ),
      ),
    );
  }
}
