import 'dart:core';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:aura_app/playlistCheckbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicLibraryManager extends StatefulWidget {
  static final MusicLibraryManager _musicLibraryManagerInstance =
  MusicLibraryManager._internal();

  factory MusicLibraryManager() => _musicLibraryManagerInstance;

  @override
  State<StatefulWidget> createState() => _MusicLibraryManager();

  MusicLibraryManager._internal();
}

class _MusicLibraryManager extends State<MusicLibraryManager> {
  bool isPlaying = false;
  static List<String> playlistSongs = List<String>();
  @override
  //called on init
  void initState() => super.initState();

  //use for debugging
  @override
  Widget build(BuildContext context) => Column();
}

class PlayMusic extends State<MusicLibraryManager> {
  factory PlayMusic() => _playMusicInstance;

  static final AudioCache audioCache = AudioCache();
  static final AudioPlayer audioPlayer = AudioPlayer();
  static final PlayMusic _playMusicInstance = PlayMusic();

  static String playingSongName;
  static bool isPlaying;

  @override
  Widget build(BuildContext context) => null;

  static bool playStream(String url) {
    if (url != null)
      try {
        audioPlayer.play(url);
        isPlaying = true;
        print('now playing $url');
      } catch (e) {
        isPlaying = false;
        print('Play not functioning');
      } finally {}
    return isPlaying;
  }

  static bool playSongLocally(String localDir, bool isAudioPlaying) {
    if (!isAudioPlaying) {
      audioCache.clear(localDir);
      audioCache.play(localDir);
      isAudioPlaying = false;
      print('playing');
    } else {
      audioCache.clear(localDir);
      audioCache.clearCache();
      isAudioPlaying = true;
      print('stopped');
    }

    return isAudioPlaying;
  }

  static String getSongName() => playingSongName;
}

class PopulateSongLibrary extends StatefulWidget {
  final bool _isChecked;

  PopulateSongLibrary(this._isChecked);

  @override
  State<StatefulWidget> createState() => _PopulateSongLibrary(this._isChecked);
}

class _PopulateSongLibrary extends State<PopulateSongLibrary> {
  Color genreColor = Colors.lightBlueAccent;
  bool isChecked;

  _PopulateSongLibrary(isBoxed) {
    isChecked = isBoxed;
  }

  Key globalKey;

  bool hasPressed;

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        key: globalKey,
        stream: Firestore.instance.collection('Soundscapes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orangeAccent,
                ),
              ),
            );
          }
          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
        key: globalKey,
        padding: const EdgeInsets.only(top: 20.0),
        children:
        snapshot.map((data) => _buildListItem(context, data)).toList());
  }

  var pressedURL;

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    final list = Provider.of<PlaylistCheckbox>(context);
    return Padding(
      key: ValueKey(record.title),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Column(
        children: <Widget>[
          ListView.builder(
            itemBuilder: (context, index) {
              return Center(
                //Heading
                child: Text(
                  'I is le Genre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                ),
              );
            },
            itemCount: 1,
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Soundscapes').snapshots(),
              builder: (context, snapshot) {
                return list.togglePlaylistState(data, context);
              }),
        ],
      ),
    );
  }

  //if playlist button is tapped = change state
  ListTile playListTileState(DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    return ListTile(
        title: Text(record.title),
        trailing: Text(record.genre),
        onTap: () => pressedURL = getURL(record.title + '.mp3'));
  }
}

//TODO button needs to take in string song name from database, search through Storage and return URL based on string argument
getURL(String songName) async {
  String fileExt = '.mp3';
  String folderDir = 'Demo/' + songName + fileExt;
  StorageReference songRef = FirebaseStorage.instance.ref().child(folderDir);
  try {
    String url = (await songRef.getDownloadURL()).toString();
    print('getting file ' +  folderDir);
    print('Song URL is $url');
    PlayMusic.playStream(url);
    PlayMusic.playingSongName = songName;
  } catch (e) {
    print("song url wasn't captured");
    return print('failed to get url');
  }
}

class Record {
  final String title;
  final String genre;
  final String mood;
  final DocumentReference reference;
  final String warning = 'Error with matching db field';

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['genre'] != null),
        assert(map['mood'] != null),
        assert(map['title'] != null),
        genre = map['genre'],
        mood = map['mood'],
        title = map['title'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$genre>";
}
