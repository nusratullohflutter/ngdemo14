import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ngdemo14/pages/home_page.dart';
import 'package:ngdemo14/pages/signin_page.dart';
import 'package:ngdemo14/pages/signup_page.dart';
import 'package:ngdemo14/pages/splash_page.dart';
import 'package:ngdemo14/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDdVSVn-qywgqDNIRBfPnU77PREUSBqzvo',
      appId: '1:764678253519:android:47f987e56d53d2ebc000ba',
      messagingSenderId: '764678253519',
      projectId: 'ngdemo14-efa3c',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(),
      routes: {
        SplashPage.id: (context) => const SplashPage(),
        HomePage.id: (context) => const HomePage(),
        SignInPage.id: (context) => const SignInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
      },
    );
  }
}