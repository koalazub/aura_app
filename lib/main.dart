import 'dart:io' show Platform;

import 'package:aura_app/MusicLibraryManager.dart';
import 'package:aura_app/playlistCheckbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  // String host = Platform.isAndroid ? '10.0.2.2:8080' : 'localhost:8080';
  String host2 = '172.20.10.6:9080';

  FirebaseFirestore.instance.settings =
      Settings(host: host2, persistenceEnabled: false, sslEnabled: false);
}

class MyApp extends StatelessWidget {
  final String shortDescript =
      'Dungeon Maestro is an audio-atmospheric companion app to the tabletop and RPG games such as D&D';

  @override
  Widget build(BuildContext context) {
    MusicLibraryManager();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlaylistCheckbox()),
        ChangeNotifierProvider(
          create: (_) => CheckedItemsCounter(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          brightness: Brightness.dark,
          accentColor: Colors.blueAccent,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
