import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:recent_it/screen/main_tab_page.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '요즘 IT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainTabPage(),
    );
  }
}
