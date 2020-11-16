import 'package:aura_app/lighttheme.dart';
import 'package:aura_app/playlistCheckbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'SplashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FirebaseFirestore.instance;
  initialiseFirebase();
  runApp(AuraMainAPP());
}

Future<void> initialiseFirebase() async {
  await Firebase.initializeApp();
  String host = 'localhost:5002';
  FirebaseFirestore.instance.settings = Settings(host: host, sslEnabled: false);

  if (FirebaseFirestore.instance.settings.host == 'localhost') {
    print('Obtained host: $host');
  }
}

class AuraMainAPP extends StatelessWidget {
  final String shortDescript =
      'Dungeon Maestro is an audio-atmospheric companion app to the tabletop and RPG games such as D&D';

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PlaylistCheckbox()),
        ChangeNotifierProvider(
          create: (_) => CheckedItemsCounter(),
        ),
      ],
      child: MaterialApp(
        //koala - Implement conditional that checks whether light or dark mode is invoked based on system setting
        theme: ThemeData(
            primarySwatch: Colors.purple,
            brightness: Brightness.dark,
            accentColor: Colors.white,
            appBarTheme:
                //koala - implement new LightAppTheme over here
                AppBarTheme(
              textTheme: TextTheme(headline5: AppBarText),
            )),
        home: SplashScreen(),
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
      ),
    );
  }
}
