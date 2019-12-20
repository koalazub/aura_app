import 'package:flutter/material.dart';

class SliderClass extends StatefulWidget {
  final int sliderDivisions;
  final double maxSlideValue;
  final double slideValue;

  SliderClass(
    this.sliderDivisions,
    this.maxSlideValue,
    this.slideValue,
  );

  @override
  State<StatefulWidget> createState() =>
      _SliderClass(
        sliderDivisions,
        maxSlideValue,
        slideValue,
      );
}

class _SliderClass extends State<SliderClass> {
  int numDivisions;
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

  _SliderClass(int numDivs, double maxSlideValue, double slideValue) {
    numDivisions = numDivs;
    maxSliderValue = maxSlideValue;
    sliderValue = slideValue;
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
//            callSongBasedOnValue(playOnSlideChangeEnd(3));
            playOnSlideChangeEnd(maxSliderValue);
            //TODO add play function after finger lift
          });
        },
        onChangeEnd: (double changedValue) {
          return changedValue;
        },
        onChangeStart: (double changedValue) {
          //TODO insert function to play from soundscape based on where the slider ends
          return changedValue;
        },
      );

  void callSongBasedOnValue(double val) {
    double sliderValue = val;
    if (sliderValue < 1) {
      print('call play function for Resolve!');
    } else if (sliderValue > 6) {
      print('call play function for Resolve!');
    } else if (sliderValue == 5) {
      print('call play function for Resolve!');
    }
  }

  //Return event to trigger function call based on value
  double playOnSlideChangeEnd(double divisionAction) {
    double sliderVal;
    if (divisionAction != null) if (sliderValue == divisionAction / 2) {
      sliderActions(casualColor, casualColor, 'normal');
      sliderVal = sliderValue;
    } else if (sliderValue > divisionAction / 2) {
      sliderActions(tenseColor, tenseColor, 'Tension!');
      sliderVal = sliderValue;
    } else if (sliderValue < divisionAction / 2) {
      sliderVal = sliderValue;
      sliderActions(resolveColor, resolveColor, 'Resolve!');
    } else {
      print("somehow you've gone beyond the realm of what's possible");
      return 0;
    }
    return sliderVal;
  }

  void sliderActions(
      Color inActiveColor, Color activeColor, String sliderBalloon) {
    inactiveSliderColor = inActiveColor;
    activeSliderColor = activeColor;
    labelBalloon = sliderBalloon;
  }
}
