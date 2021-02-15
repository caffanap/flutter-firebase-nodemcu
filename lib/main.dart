import 'package:flutter/material.dart';

// Import the firebase_core plugin
import 'package:firebase_core/firebase_core.dart';
import 'package:nodefire/screens/home_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // digunakan untuk dapat memanggil fungsi sebelum android hidup
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(); // inisialisasi firebase

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error.toString());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ); 
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: CircularProgressIndicator(),
          ); 
      },
    );
  }
}