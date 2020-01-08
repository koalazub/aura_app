import 'package:aura_app/playlistCheckbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'MusicLibraryManager.dart';
import 'animatHudIcon.dart';

class MusicPlayerHUD extends StatefulWidget {
  final BuildContext context;

  MusicPlayerHUD(this.context);

  @override
  State<StatefulWidget> createState() => _MusicPlayerHUD(this.context);
}

class _MusicPlayerHUD extends State<MusicPlayerHUD>
    with SingleTickerProviderStateMixin {
  Color defaultIconColor = Colors.white;

  IconData playArrow = Icons.play_arrow;

  _MusicPlayerHUD(BuildContext context);

  Color get nowPlayingColor => null;

  bool isPlay = false;

  Color backgroundColor = Colors.black;

  static double iconDefaultSize = 54;

  double playIconSize = 54.0;
  AnimationController playAnimationController;

  @override
  void initState() {
    super.initState();
    playAnimationController = new AnimationController(
        duration: new Duration(milliseconds: 300), vsync: this);

    playAnimationController.addListener(() {
      this.setState(() {});
    });
  }

  void dispose() {
    super.dispose();
    playAnimationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final checkedItemsCounter = Provider.of<CheckedItemsCounter>(context);
    return musicHUD(context, checkedItemsCounter);
  }

  AnimatedIconData animatedIconData = AnimatedIcons.add_event;

  AnimatedHudIcon animatedHudIcon =
  AnimatedHudIcon(AnimatedIcons.add_event, iconDefaultSize);
  bool isAnimated = false;

  Container musicHUD(
      BuildContext context, CheckedItemsCounter checkedItemsCounter) {
    Duration beginning = new Duration(milliseconds: 0);
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FlatButton.icon(
              onPressed: () {
                PlayMusic.audioPlayer.stop();
              },
              label: songLabel(PlayMusic.getSongName()),
              color: updatePlayColor(isPlay, nowPlayingColor),
              icon: Icon(Icons.stop, color: Colors.white, size: 54.0),
            ),
            Row(
              //TODO strip functionality
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                defaultPlaybackIcon(Icons.skip_previous, defaultIconColor,
                    iconDefaultSize, PlayMusic.audioPlayer.seek(beginning)),
                playIcon(playArrow),
                defaultPlaybackIcon(Icons.skip_next, defaultIconColor,
                    iconDefaultSize, PlayMusic.audioPlayer.play(null))
//                defaultPlaybackIcon(Icons.fast_forward, defaultIconColour,
//                    iconDefaultSize, null),
              ],
            ),
//              SliderClass(2, 3.0, 3.0)
          ],
        ),
      ),
    );
  }

  Expanded playIcon(IconData defaultPlayIcon) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(100.0)),
        child: FlatButton(
          onPressed: () {
            setState(() {
              toggleIsAnimated();
              toggleIsPlaying();
              flipAnimation();
            });
          },
          child: AnimatedIcon(
            icon: AnimatedIcons.pause_play,
            progress: playAnimationController,
            size: playIconSize,
            color: defaultIconColor,
          ),
        ),
      ),
    );
  }

  void flipAnimation() => isAnimated
      ? playAnimationController.forward()
      : playAnimationController.reverse();

  void toggleIsAnimated() => isAnimated = !isAnimated;

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

  void toggleIsPlaying() => isPlay ? isPlay = false : isPlay = true;

  ///Update song label for now playing HUD
  Text songLabel(String songTitle) {
    try {
      return Text(
        songTitle,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: defaultIconColor),
      );
    } catch (e) {
      print('Exception caught, issue with song read. ');
      return Text('Song', overflow: TextOverflow.fade);
    }
  }

  ///Use for quick button setup with abstract function input
  Expanded defaultPlaybackIcon(
          IconData icon, Color defaultIconColor, double iconSize, function) =>
      Expanded(
        child: Column(
          children: <Widget>[
            Container(
              child: FlatButton(
                child: Icon(
                  icon,
                  color: defaultIconColor,
                  size: iconSize,
                ),
                onPressed: () {
                  function();
                },
              ),
            ),
          ],
        ),
      );

  ///Used to notify user of function invocation
  Color updatePlayColor(bool isPlay, Color someColor) {
    isPlay ? someColor = Colors.blueAccent : someColor = Colors.orangeAccent;
    return someColor;
  }
}
