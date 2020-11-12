import 'dart:async';

import 'package:aura_app/musicLibrary.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MusicLibrary()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'android/assets/PlaceHolderTutorial.png',
              ),
              fit: BoxFit.cover)),
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.orangeAccent,
        ),
      ),
    );
  }
}
