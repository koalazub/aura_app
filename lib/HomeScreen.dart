import 'package:aura_app/MusicPlayer.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Choose Soundscape'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: <Widget>[
          soundScapeTile(
              'soundScapeTitle', 'soundScapeSubtitle', context, MusicPlayer())
        ],
      ),
    );
  }

  Container soundScapeTile(String soundScapeTitle, String soundScapeSubtitle,
          BuildContext context, Widget stateWidget) =>
      Container(
        height: 150,
        decoration: ShapeDecoration(shape: Border.all(width: 8.0)),
        child: FlatButton(
          color: Colors.orangeAccent,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => stateWidget));
          },
          child: ListTile(
            title: Text(
              soundScapeTitle,
              style: TextStyle(color: Colors.black),
            ),
            subtitle:
                Text(soundScapeSubtitle, style: TextStyle(color: Colors.black)),
          ),
        ),
      );
}
