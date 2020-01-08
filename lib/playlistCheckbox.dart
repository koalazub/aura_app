import 'package:aura_app/MusicLibraryManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistCheckbox with ChangeNotifier {
  bool playlistActive = false;
  bool checkboxItemTicked = true;
  String pressedURL;

  togglePlaylistState(DocumentSnapshot data, BuildContext context) {
    if (playlistActive) {
      if (data != null) return Checkbox(data);
    } else {
      return PlayableList(data);
    }
  }

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

  _Checkbox(this.data);

  bool hasTicked = false;
  String songTitle;

  @override
  Widget build(BuildContext context) {
    final record = Record.fromSnapshot(data);
    final songTitle = record.title;
    final checkedCounter = Provider.of<CheckedItemsCounter>(context);
    return Container(
      color: Colors.deepOrange,
      child: CheckboxListTile(
          checkColor: Colors.blueAccent,
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

  void addCheckedItemToList(String checkedSong) {
    checkedItem.add(checkedSong);
    print(checkedItem.length);
    notifyListeners();
  }

  void removeCheckedItemFromList(String checkedSong) {
    checkedItem.remove(checkedSong);
    print(checkedItem.length);
    notifyListeners();
  }

  //TODO function deprecated - untangle and remo ve
  void flushPlaylist() => checkedItem.clear();
  bool inPlaylistMode = false;
}

class PlayableList extends StatefulWidget {
  final DocumentSnapshot data;

  PlayableList(this.data);

  @override
  State<StatefulWidget> createState() => _PlayableList(this.data);
}

class _PlayableList extends State<PlayableList> {
  DocumentSnapshot data;
  String pressedURL;

  _PlayableList(this.data);

  @override
  Widget build(BuildContext context) {
    final record = Record.fromSnapshot(data);
    return FlatButton(
      color: Colors.blueAccent,
      child: ListTile(
          title: Text(record.title),
          trailing: Text(record.genre),
          onTap: () => pressedURL = playFromURL(record.title).toString()),
      onPressed: () {
        setState(() {
          PlayMusic.playingSongName = record.title;
        });
      },
    );
  }
}
