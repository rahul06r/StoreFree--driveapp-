import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String errorMsg;
  const ErrorText({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(errorMsg),
    );
  }
}
