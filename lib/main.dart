import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/screens/home.dart';
import 'package:provider/screens/register.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyD_Um9H71SBFC8JIbZyYg6lyojkpa1FlZM",
    authDomain: 'appdemo-5ff31.firebaseapp.com',
    projectId: "appdemo-5ff31",
    storageBucket: "appdemo-5ff31.appspot.com",
    messagingSenderId: '1021046837476',
    appId: "1:1021046837476:android:62dcbade170450e5f69cf1",
   //measurementId: '8041727286',
  );

  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Register(),debugShowCheckedModeBanner: false,);
  }
}