import 'package:aura_app/MusicLibraryManager.dart';
import 'package:aura_app/playlist.dart';
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
  bool isCheckboxFloat = false;

  void addCheckedItemToList(String checkedSong) {
    checkedItem.add(checkedSong);

    print(checkedItem.length);
    if (checkedItem.length > 0) {
      isCheckboxFloat = true;
    }
    notifyListeners();
  }

  void removeCheckedItemFromList(String checkedSong) {
    checkedItem.remove(checkedSong);
    print(checkedItem.length);
    if (checkedItem.length < 3) {
      isCheckboxFloat = false;
    }
    notifyListeners();
  }

  void flushPlaylist() => checkedItem.clear();
  bool inPlaylistMode = false;
  Visibility checkboxFloatingAction(BuildContext context) {
    final activePlayButton = Provider.of<CheckedItemsCounter>(context);
    List<String> storedList = checkedItem;
    if (isCheckboxFloat)
      return Visibility(
        visible: activePlayButton.inPlaylistMode,
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Playlist(playlist: storedList)));
          },
        ),
      );
    else {
      return Visibility(
          visible: activePlayButton.inPlaylistMode,
          child: FloatingActionButton(
            child: Text("Play"),
            onPressed: () {
              return playFromURL(checkedItem[1]);
            },
          ));
    }
  }
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
