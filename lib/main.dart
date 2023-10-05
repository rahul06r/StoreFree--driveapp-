import 'package:drive_app/Features/HomeScreen/Screen/Home_page.dart';
import 'package:drive_app/Themes/pallete.dart';
import 'package:drive_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      home: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        if (orientation == Orientation.landscape) {
          return const Scaffold(
            backgroundColor: Pallete.whiteColor,
            body: Center(
              child: Text(
                "Change to Potrait",
                style: TextStyle(
                    color: Pallete.redColor,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          return const HomePage();
        }
      }),
    );
  }
}
