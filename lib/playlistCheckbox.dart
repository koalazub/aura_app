import 'package:aura_app/MusicLibraryManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistCheckbox with ChangeNotifier {
  bool playlistActive = false;
  bool checkboxItemTicked = true;
  String pressedURL;

  listFromSnapshot(DocumentSnapshot data, BuildContext context) =>
      playlistActive
          ? Checkbox(data)
          : SongsCollection(
              data,
              textColor: Colors.black,
              buttonColor: Colors.black,
            );

  void togglePlaylistMenu() =>
      playlistActive ? playlistActive = false : playlistActive = true;
}

class Checkbox extends StatefulWidget {
  final DocumentSnapshot data;
  Checkbox(this.data);

  State<StatefulWidget> createState() => _Checkbox(this.data);
}

class _Checkbox extends State<Checkbox> {
  DocumentSnapshot data;
  bool hasTicked = false;
  String songTitle;

  _Checkbox(this.data);

  @override
  Widget build(BuildContext context) {
    final record = Record.fromSnapshot(data);
    final songTitle = record.title;
    final checkedCounter = Provider.of<CheckedItemsCounter>(context);

    return Container(
      color: Colors.deepOrange,
      child: CheckboxListTile(
          checkColor: Colors.white,
          title: Text(songTitle),
          subtitle: Text(
            record.genre,
            style: TextStyle(fontSize: 18),
            textScaleFactor: 0.75,
          ),
          value: hasTicked,
          onChanged: (bool value) {
            value
                ? checkedCounter.addCheckedItemToList(songTitle)
                : checkedCounter.removeCheckedItemFromList(songTitle);
            setState(() {
              hasTicked = value;
            });
          }),
    );
  }
}

class CheckedItemsCounter with ChangeNotifier {
  List<String> checkedItem = List<String>();
  bool isCheckboxVisible = true;
  bool inPlaylistMode = false;

  void addCheckedItemToList(String checkedSong) {
    checkedItem.add(checkedSong);
    print(checkedItem.length);
    notifyListeners();
  }

  void removeCheckedItemFromList(String checkedSong) {
    checkedItem.remove(checkedSong);
    notifyListeners();
  }

  void flushPlaylist() => checkedItem.clear();
}

//TODO need to separate this into another class
class SongsCollection extends StatefulWidget {
  final DocumentSnapshot data;
  final Color textColor;
  final Color buttonColor;

  SongsCollection(this.data,
      {this.textColor = Colors.white, this.buttonColor = Colors.white});

  @override
  State<StatefulWidget> createState() =>
      _SongsCollection(this.data, this.textColor, this.buttonColor);
}

class _SongsCollection extends State<SongsCollection> {
  DocumentSnapshot data;
  String pressedURL;
  Color textColor;
  Color buttonColor;

  _SongsCollection(this.data, this.textColor, this.buttonColor);

  @override
  Widget build(BuildContext context) {
    final record = Record.fromSnapshot(data);
    return FlatButton(
      onPressed: () {},
      child: ListTile(
          title: Text(
            record.title,
            style: TextStyle(color: textColor),
          ),
          trailing: Text(
            record.genre,
            style: TextStyle(color: textColor),
          ),
          onTap: () =>
              pressedURL = playUrlFromStorage(record.title).toString()),
    );
  }
}
