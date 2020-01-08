import 'package:aura_app/MusicLibraryManager.dart';
import 'package:flutter/material.dart';

class SliderClass extends StatefulWidget {
  final int sliderDivisions;
  final double maxSlideValue;
  final double slideValue;
  final List<String> playlist;

  SliderClass(this.sliderDivisions,
      this.maxSlideValue,
      this.slideValue,
      this.playlist,);

  @override
  State<StatefulWidget> createState() =>
      _SliderClass(
        sliderDivisions,
        maxSlideValue,
        slideValue,
        playlist,
      );
}

class _SliderClass extends State<SliderClass> {
  int numDivisions;
  List<String> songPlaylist;
  double sliderValue = 10.0;
  double maxSliderValue = 10.0;
  Color activeSliderColor = Colors.deepOrangeAccent;
  Color inactiveSliderColor = Colors.deepOrangeAccent;
  String labelBalloon = ' ';
  bool balloonOn;

  static Color casualColor = Colors.deepPurple;
  static Color resolveColor = Colors.lightBlueAccent;
  static Color tenseColor = Colors.deepOrangeAccent;
  List<Color> moods = [casualColor, resolveColor, tenseColor];

  _SliderClass(int numDivs, double maxSlideValue, double slideValue,
      List<String> playlist) {
    numDivisions = numDivs;
    maxSliderValue = maxSlideValue;
    sliderValue = slideValue;
    songPlaylist = playlist;
  }

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) =>
      Slider(
        min: 0,
        max: maxSliderValue,
        label: labelBalloon,
        activeColor: activeSliderColor,
        inactiveColor: inactiveSliderColor,
        divisions: numDivisions,
        value: sliderValue,
        onChanged: (newValue) {
          setState(() {
            sliderValue = newValue;
            labelBalloon = labelBalloon + 'something ';
            playOnSlideChangeEnd(maxSliderValue);
            //TODO add play function after finger lift
          });
        },
        onChangeEnd: (double changedValue) {
          callSongBasedOnValue(changedValue);
          try {
            Future<int> duration = PlayMusic.storeDuration();
            print('$duration');
          } catch (e) {
            print('faied to obtain duration');
          }
          return changedValue;
        },
        onChangeStart: (double changedValue) {
          //TODO insert function to play from soundscape based on where the slider ends
          //TODO store value of playing song
          return changedValue;
        },
      );

  List<Future> storedSongAtPause = new List<Future>();

  void callSongBasedOnValue(double val) {
    double sliderValue = val;
    PlayMusic.audioPlayer.pause();

    if (sliderValue < 1) {
      playFromURL(songPlaylist[0] + ' [A]');
      //TODO check if audioplayer is playing, then store duration
      print('call play function for A!');
    } else if (sliderValue > 6) {
      playFromURL(songPlaylist[0] + ' [O]');
      print('call play function for O!');
    } else if (sliderValue == 5) {
      playFromURL(songPlaylist[0] + ' [B]');
      print('call play function for B!');
    }
  }

  returnSongPosition(Future<int> songPosition) async {
    int songDurationAtTime = await songPosition;
    return songDurationAtTime;
  }

  //fixme not storing boolean
  bool isSongPlaying() => PlayMusic.isPlaying;

  //Return event to trigger function call based on value
  double playOnSlideChangeEnd(double divisionQuantity) {
    //Pause music
    double sliderVal;
    if (divisionQuantity != null) if (sliderValue == divisionQuantity / 2) {
      sliderActions(casualColor, casualColor, 'normal');
      sliderVal = sliderValue;
    } else if (sliderValue > divisionQuantity / 2) {
      sliderActions(tenseColor, tenseColor, 'Tension!');
      sliderVal = sliderValue;
    } else if (sliderValue < divisionQuantity / 2) {
      sliderVal = sliderValue;
      sliderActions(resolveColor, resolveColor, 'Resolve!');
    } else {
      print("somehow you've gone beyond the realm of what's possible");
      return 0;
    }
    return sliderVal;
  }


  void sliderActions(Color inActiveColor, Color activeColor, String sliderBalloon) {
    inactiveSliderColor = inActiveColor;
    activeSliderColor = activeColor;
    labelBalloon = sliderBalloon;
  }
}
