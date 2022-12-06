import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sketch/presintation/UIScreens/AuthScreen/loginScreen.dart';
import 'package:sketch/presintation/UIScreens/webview/webviewScreen.dart';
import 'package:sketch/presintation/UIScreens/webview/webviwe.dart';

import 'function/sharedprefrenc.dart';
bool ?islogin;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await Firebase.initializeApp();
  await Permission.camera.request();
  await Permission.microphone.request();
  runApp(const MyApp());

  islogin = CacheHelper.getData(key: 'islogin');

  if (islogin == null||islogin==false) {
    islogin = false;
  } else {
    islogin = true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sketch Engineering Consulting Office',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: islogin!?WebViewCreen(): LoginScreen()
    );
  }
}
