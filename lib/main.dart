import 'package:aura_app/MusicLibraryManager.dart';
import 'package:aura_app/playlistCheckbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SplashScreen.dart';

void main() => runApp(MyApp());

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
