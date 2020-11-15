import 'package:aura_app/lighttheme.dart';
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
  Color backgroundColor = Color(0xff193b59);
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
      child: Scaffold(
        backgroundColor: backgroundColor,
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
              //koala - convert state change into provider
              setState(() {
                list.togglePlaylistMenu();
                checkedCounter.flushPlaylist();
                checkedCounter.inPlaylistMode = !checkedCounter.inPlaylistMode;
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
            padding: EdgeInsets.only(top: 20),
            child: Column(
              children: <Widget>[
                createCollectionTile(
                    title: 'Soundscapes',
                    imageAsset: 'assets/PlaceHolderTutorial.png'),
                Expanded(child: PopulateSongLibrary("Soundscapes")),
                createCollectionTile(
                    title: 'Tavern',
                    imageAsset: 'assets/PlaceHolderTutorial.png'),
                Expanded(child: PopulateSongLibrary("Tavern")),
                createCollectionTile(
                    title: 'Combat',
                    imageAsset: 'assets/PlaceHolderTutorial.png'),
                Expanded(child: PopulateSongLibrary("combat"))
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
      print(e);
      return Text('Song', overflow: TextOverflow.fade);
    }
  }

  //koala - if this fucks up just revert it
  Future<Color> updatePlayColor(Future<bool> isPlay, Color someColor) async =>
      await isPlay ? someColor = Colors.white : someColor = Colors.purple;
}

Widget createCollectionTile(
    {@required String imageAsset, @required String title}) {
  return ListTile(
    title: Text(
      title,
      style: titleText,
      textAlign: TextAlign.center,
    ),
    trailing: Image.asset(
      imageAsset,
      height: 50,
      width: 50,
    ),
  );
}
