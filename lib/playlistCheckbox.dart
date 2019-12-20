import 'package:aura_app/MusicLibraryManager.dart';
import 'package:aura_app/playlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  bool togglePlaylistCheckedItem() => checkboxItemTicked
      ? checkboxItemTicked = false
      : checkboxItemTicked = true;

  FlatButton playListTileState(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return FlatButton(
      color: Colors.blueAccent,
      child: ListTile(
          title: Text(record.title),
          trailing: Text(record.genre),
          onTap: () => pressedURL = getURL(record.title + '.mp3')),
      onPressed: () {
        PlayMusic.playingSongName = record.title;
        PlayMusic.playStream(pressedURL);
        PlayMusic.getSongName();
      },
    );
  }

  getURL(String songName) async {
    String folderDir = 'Demo/' + songName;
    StorageReference songRef = FirebaseStorage.instance.ref().child(folderDir);
    try {
      String url = (await songRef.getDownloadURL()).toString();
      print('Song URL is $url');
    } catch (e) {
      print("song url wasn't captured");
    }
  }
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
      color: Colors.red,
      child: CheckboxListTile(
          checkColor: Colors.orange,
          title: Text(songTitle),
          subtitle: Text(
            record.mood,
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

class CheckedItemsCounter extends ChangeNotifier {
  List<String> checkedItem = List<String>();
  bool isCheckboxFloat = false;

  void addCheckedItemToList(String checkedSong) {
    checkedItem.add(checkedSong);
    print(checkedItem.first + ' has been added');
    for (var s in checkedItem) {
      print('All songs in playlist are ' + s);
    }

    print(checkedItem.length);
    if (checkedItem.length > 2) {
      isCheckboxFloat = true;
    }
    notifyListeners();
  }

  void removeCheckedItemFromList(String checkedSong) {
    print(checkedItem.removeLast() + ' has been reoved');
    checkedItem.remove(checkedSong);
    print(checkedItem.length);
    if (checkedItem.length < 3) {
      isCheckboxFloat = false;
    }
    notifyListeners();
  }

  void flushPlaylist() => checkedItem.clear();

  Visibility checkboxFloatingAction(BuildContext context) {
    List<String> storedList = checkedItem;
    if (isCheckboxFloat)
      return Visibility(
        visible: true,
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
          visible: false, child: FloatingActionButton(onPressed: () {}));
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
          onTap: () => pressedURL = getURL(record.title + '.mp3').toString()),
      onPressed: () {
        PlayMusic.playingSongName = record.title;
        PlayMusic.playStream(pressedURL);
        PlayMusic.getSongName();
      },
    );
  }
}
