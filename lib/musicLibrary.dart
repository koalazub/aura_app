import 'package:aura_app/playlist.dart';
import 'package:aura_app/playlistCheckbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MusicLibraryManager.dart';

class MusicLibrary extends StatefulWidget {
  MusicLibrary();

  @override
  State<StatefulWidget> createState() => _MusicLibrary();
}

class _MusicLibrary extends State<MusicLibrary>
    with SingleTickerProviderStateMixin {
  void initState() {
    super.initState();
    animation = new AnimationController(duration: duration, vsync: this);
    animation.addListener(() => this.setState(() {}));
  }

  @protected
  @mustCallSuper
  double iconDefaultSize = 50.0;
  double sliderValue = 0.0;
  double playIconSize = 64.0;

  Color defaultIconColour = Colors.white;
  Color backgroundColor = Colors.lightBlue;
  Color nowPlayingColor = Colors.orangeAccent;

  Duration beginning = Duration.zero;
  bool playlistSelected = false;

  //Animation region
  AnimatedIconData playlistAnimatedIcon = AnimatedIcons.menu_close;
  AnimationController animation;
  Duration duration = Duration(milliseconds: 250);
  bool flipAnimation = false;

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
            autofocus: true,
            icon: AnimatedIcon(
              progress: animation,
              icon: playlistAnimatedIcon,
              size: 20,
            ),
            onPressed: () {
              setState(() {
                list.togglePlaylistMenu();
                checkedCounter.flushPlaylist();
                checkedCounter.inPlaylistMode
                    ? checkedCounter.inPlaylistMode = false
                    : checkedCounter.inPlaylistMode = true;
                print(checkedCounter.inPlaylistMode);
                flipAnimation ? animation.reverse() : animation.forward();
                flipAnimation = !flipAnimation;
              });
            },
          ),
          backgroundColor: Colors.orange,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              enableFeedback: true,
              icon: Icon(
                Icons.playlist_add,
                color: defaultIconColour,
              ),
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Playlist(
                            playlist: checkedCounter.checkedItem,
                          ))),
            )
          ],
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            Expanded(child: PopulateSongLibrary(playlistSelected)),
          ],
        )),
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

  Color updatePlayColor(bool isPlay, Color someColor) {
    isPlay ? someColor = Colors.blueAccent : someColor = Colors.orangeAccent;
    return someColor;
  }
}
