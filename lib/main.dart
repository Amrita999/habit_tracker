import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app_new/firebase_options.dart';
import 'package:my_app_new/register.dart';
import 'addhabit.dart';
import 'homeScreen.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'login',
    routes: {
      'login': (context) => MyLogin(),
      'register': (context) => MyRegister(),
      'homeScreen': (context) => MyHomeScreen(),
      'addhabit': (context) => AddHabit(),
    },
  ));
}
