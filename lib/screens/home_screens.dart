import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final dbReference = FirebaseDatabase.instance.reference(); // inisialisasi realtime database firebase

  bool switchbutton = false; // inisialisasi switch LED

  int slider = 0; // inisialisasi slider Servo

  void initFire() {
    // Ambil Value LED
    dbReference.child('/LED').once().then((value) {
      if (value.value == "ON") {
        setState(() {
          switchbutton = true;
        });
      } else {
        setState(() {
          switchbutton = false;
        });
      }
    });

    // Ambil Value Servo
    dbReference.child('/SERVO').once().then((value) {
      setState(() {
        slider = value.value;
      });
    });
  }

  @override
  void initState() {
    initFire();
    super.initState();
  }

  void toggleSwitch<bool>(val) {
    if (val) {
      dbReference.child('/LED').set("ON").then((_) {
        setState(() {
          switchbutton = true;
        });
      });
    } else {
      dbReference.child('/LED').set("OFF").then((_) {
        setState(() {
          switchbutton = false;
        });
      });
    }
  }

  void sliderServo<double>(val) {
    setState(() {
      slider = val.toInt();
      dbReference.child("/SERVO").set(val.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Node Fire"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "LED BUILT IN",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                    Switch(
                        value: switchbutton,
                        onChanged: (bool val) => toggleSwitch(val))
                  ],
                )),
            Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "SERVO CONTROLLER",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500),
                    ),
                    Slider(
                        value: slider.toDouble(),
                        min: 0,
                        max: 100,
                        divisions: 100,
                        onChanged: (val) => sliderServo(val)),
                    Text(slider.toString())
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
