import 'dart:core';

import 'package:audioplayers/audio_cache.dart' show AudioCache;
import 'package:audioplayers/audioplayers.dart' show AudioPlayer;
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

  @override
  //called on init
  void initState() => super.initState();

  //use for debugging
  @override
  Widget build(BuildContext context) => Column();
}

class PlayMusic extends State<MusicLibraryManager> {
  static bool printDuration = true;

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

  static void pauseMusic() => audioPlayer.pause();

  static void skipBackMusic() => audioPlayer
      .seek(new Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));

  static void resumeMusic() => audioPlayer.resume();

  static void skipMusic(String song) =>
      audioPlayer.setUrl(song, respectSilence: true);

  static storeDuration() async => await audioPlayer.getCurrentPosition();
}

class PopulateSongLibrary extends StatefulWidget {
  final bool isChecked;
  final String collectionSchema;

  PopulateSongLibrary(this.collectionSchema, {this.isChecked = false});

  @override
  State<StatefulWidget> createState() =>
      _PopulateSongLibrary(this.isChecked, this.collectionSchema);
}

///Contains data points to alter things like gapping between buttons
///Where the Stream is built and with what collection
class _PopulateSongLibrary extends State<PopulateSongLibrary> {
  bool isChecked;
  bool isOdd = false;
  Key globalKey;
  String schemaCollection;

  _PopulateSongLibrary(isBoxed, collection) {
    isChecked = isBoxed;
    schemaCollection = collection;
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    var soundscapes =
        FirebaseFirestore.instance.collection(schemaCollection).snapshots();
    return StreamBuilder<QuerySnapshot>(
        key: globalKey,
        stream: soundscapes,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
          // isOdd = !isOdd;
          return _buildList(context, snapshot.data.docs, isOdd);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot,
      bool isOdd) {
    return ListView(
        key: globalKey,
        children: snapshot
            .map((data) => _buildListItem(context, data, isOdd))
            .toList());
  }

  int counter = 0;

  Widget _buildListItem(BuildContext context, DocumentSnapshot data,
      bool isOdd) {
    final list = Provider.of<PlaylistCheckbox>(context);
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      color: Colors.white70,
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(schemaCollection)
              .snapshots(),
          builder: (context, snapshot) => list.listFromSnapshot(data, context)),
    );
  }
}

String concatenateFileExtension(String song, String extension) =>
    song + extension;

playUrlFromStorage(String songName) async {
  //fixme this has various issues related to looping
  List<String> fileExt = ['.wav'];
  String folderDir = 'Demo/' + concatenateFileExtension(songName, fileExt[0]);
  print(folderDir);
  Reference songRef = FirebaseStorage.instance.ref().child(folderDir);
  try {
    //fixme url currently not fetching due to database not being present. We
    // should attach local directory files from assets first to see that it's functional before proceeding
    String url = (await songRef.getDownloadURL()).toString();
    PlayMusic.playStream(url);
    PlayMusic.playingSongName = songName;
  } catch (e) {
    return print('failed to get url');
  }
}

class Record {
  final String title;
  final String genre;
  final String mood;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['genre'] != null),
        assert(map['mood'] != null),
        assert(map['title'] != null),
        genre = map['genre'],
        mood = map['mood'],
        title = map['title'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$genre>";
}
