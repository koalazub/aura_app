import 'package:aura_app/playlistCheckbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MusicLibraryManager.dart';

class MusicPlayer extends StatefulWidget {
  MusicPlayer();

  MusicPlayer._internal();

  @override
  State<StatefulWidget> createState() => _MusicPlayer();
}

class _MusicPlayer extends State<MusicPlayer> {
  void initState() => super.initState();

  @protected
  @mustCallSuper
  double iconDefaultSize = 50.0;
  double sliderValue = 0.0;
  double playIconSize = 64.0;

  Color defaultIconColour = Colors.white;
  Color backgroundColor = Colors.lightBlue;
  Color nowPlayingColor = Colors.orangeAccent;

  static IconData playArrow = Icons.play_arrow;

  static bool isPlay = false;
  static bool isPlaylist = false;
  Duration beginning = Duration.zero;
  bool playlistSelected = false;

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<PlaylistCheckbox>(context);
    final checkedCounter = Provider.of<CheckedItemsCounter>(context);

    MusicLibraryManager();
    return Material(
      color: Colors.red,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: IconButton(
            enableFeedback: true,
            icon: Icon(Icons.sort),
            onPressed: () => null,
          ),
          title: Text("Music Library"),
          backgroundColor: Colors.orange,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
                enableFeedback: true,
                icon: Icon(
                  Icons.playlist_add,
                  color: defaultIconColour,
                ),
                onPressed: () {
                  setState(() {
                    list.togglePlaylistMenu();
                    checkedCounter.flushPlaylist();
                    checkedCounter.inPlaylistMode
                        ? checkedCounter.inPlaylistMode = false
                        : checkedCounter.inPlaylistMode = true;
                    print(checkedCounter.inPlaylistMode);
                  });
                })
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () {
                  PlayMusic.audioPlayer.stop();
                },
                icon: Icon(
                  Icons.stop,
                  size: 40,
                  color: defaultIconColour,
                ),
                label: songLabel(PlayMusic.getSongName()),
                color: updatePlayColor(isPlay, nowPlayingColor),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  defaultPlaybackIcon(Icons.fast_rewind, defaultIconColour,
                      iconDefaultSize, PlayMusic.audioPlayer.seek(beginning)),
                  playIcon(playArrow),
                  defaultPlaybackIcon(Icons.fast_forward, defaultIconColour,
                      iconDefaultSize, null),
                ],
              ),
//              SliderClass(2, 3.0, 3.0),
              Expanded(child: PopulateSongLibrary(playlistSelected)),
              checkedCounter.checkboxFloatingAction(context)
            ],
          ),
        ),
      ),
    );
  }

  Text songLabel(String songTitle) {
    try {
      return Text(
        songTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: defaultIconColour),
      );
    } catch (e) {
      print('Exception caught, issue with song read. ');
      return Text('Song', overflow: TextOverflow.fade);
    }
  }

  Expanded playIcon(IconData defaultPlayIcon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(100.0)),
        child: FlatButton(
          onPressed: () {
            setState(() {
              //TODO get song name
              //TODO toggle when songTile is pressed and song is playing
              toggleIsPlaying();
            });
          },
          child: Icon(
            defaultPlayIcon = updatePlayIcon(isPlay, defaultPlayIcon),
            size: playIconSize,
            color: defaultIconColour,
          ),
        ),
      ),
    );
  }

  static void toggleIsPlaying() => isPlay ? isPlay = false : isPlay = true;

  IconData updatePlayIcon(bool isPlaying, IconData defaultIcon) {
    if (isPlaying) {
      defaultIcon = Icons.pause;
      PlayMusic.audioPlayer.resume();
    } else {
      defaultIcon = Icons.play_arrow;
      PlayMusic.audioPlayer.pause();
    }
    return defaultIcon;
  }

  Color updatePlayColor(bool isPlay, Color someColor) {
    isPlay ? someColor = Colors.blueAccent : someColor = Colors.orangeAccent;
    return someColor;
  }

  Expanded defaultPlaybackIcon(
          IconData icon, Color defaultIconColor, double iconSize, function) =>
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: FlatButton(
            child: Icon(
              icon,
              color: defaultIconColor,
              size: iconSize,
            ),
            onPressed: () {},
          ),
        ),
      );
}
