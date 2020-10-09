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

  static void skipBackMusic() =>
      audioPlayer
          .seek(
          new Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));

  static void resumeMusic() => audioPlayer.resume();

  static void skipMusic(String song) =>
      audioPlayer.setUrl(song, respectSilence: true);
  static storeDuration() async => await audioPlayer.getCurrentPosition();
}

class PopulateSongLibrary extends StatefulWidget {
  final bool _isChecked;

  PopulateSongLibrary(this._isChecked);

  @override
  State<StatefulWidget> createState() => _PopulateSongLibrary(this._isChecked);
}

class _PopulateSongLibrary extends State<PopulateSongLibrary> {
  bool isChecked;
  Key globalKey;

  _PopulateSongLibrary(isBoxed) {
    isChecked = isBoxed;
  }

  @override
  Widget build(BuildContext context) => _buildBody(context);

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        key: globalKey,
        stream:
            FirebaseFirestore.instance.collection('Soundscapes').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: CircularProgressIndicator(
                  backgroundColor: Colors.blueAccent,
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

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    final list = Provider.of<PlaylistCheckbox>(context);
    return Padding(
        key: ValueKey(record.title),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('Soundscapes').snapshots(),
              builder: (context, snapshot) {
                return list.togglePlaylistState(data, context);
              }),
        ));
  }
}

String concatenateFileExtension(String song, String extension) =>
    song + extension;

playFromURL(String songName) async {
  List<String> fileExt = ['.wav'];
  String folderDir = 'Demo/' + concatenateFileExtension(songName, fileExt[0]);
  print(folderDir);
  StorageReference songRef = FirebaseStorage.instance.ref().child(folderDir);
  try {
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
