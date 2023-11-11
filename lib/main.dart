import 'package:drive_app/Features/Auth/Screens/Controller/authController.dart';
import 'package:drive_app/Features/Auth/Screens/Repositry/authRepo.dart';
import 'package:drive_app/Features/Auth/Screens/loginScreen.dart';
import 'package:drive_app/Features/HomeScreen/Screen/Home_page.dart';
import 'package:drive_app/Model/userModel.dart';
import 'package:drive_app/common/ErrorText.dart';
import 'package:drive_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void didChangedAppLifeCycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ref.read(authCpntrollerProvider.notifier).logOut();
      print("Removed");
    }
  }

  UserModel? userModel;

  void getuserData(User data, WidgetRef ref) async {
    userModel = await ref
        .watch(authCpntrollerProvider.notifier)
        .getUserdata(data.uid)
        .first;
    if (userModel != null) {
      ref.read(userProvider.notifier).update((state) => userModel);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChnagedProvider).when(
      data: (data) {
        return MaterialApp(
          title: 'STORE FREE(Drive APP)',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ),
            useMaterial3: true,
          ),
          supportedLocales: const <Locale>[Locale('en', 'US')],
          home: Builder(builder: (context) {
            if (data != null) {
              getuserData(data, ref);
              if (userModel != null) {
                return HomePage();
              }
            }
            return LoginScreen();
          }),

          // home: HomePage(),
        );
      },
      error: (error, stackTrace) {
        return ErrorText(errorMsg: error.toString());
      },
      loading: () {
        return const CircularProgressIndicator();
      },
    );
  }
}
