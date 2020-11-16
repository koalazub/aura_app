import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//TODO Abstract into generics and identify edge cases where constraints might be needed
//in case you decide to fuck it up somehow
class AnimatedHudIcon extends StatefulWidget {
  final AnimatedIconData animatedIconData;
  final double iconSize;

  AnimatedHudIcon(this.animatedIconData, this.iconSize);

  @override
  State<StatefulWidget> createState() =>
      _AnimatedHudIcon(this.animatedIconData, this.iconSize);
}

class _AnimatedHudIcon extends State<AnimatedHudIcon>
    with SingleTickerProviderStateMixin {
  AnimationController animation;
  Duration duration = Duration(milliseconds: 400);
  var iconSize;

  _AnimatedHudIcon(AnimatedIconData animatedIconData, this.iconSize);

  bool flipAnim = false;

  @override
  @override
  void initState() {
    super.initState();
    animation = new AnimationController(duration: duration, vsync: this);
    animation.addListener(() => this.setState(() {}));
  }

  void dispose() {
    super.dispose();
    animation?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      enableFeedback: true,
      excludeFromSemantics: true,
      onTap: () {
        flipAnim ? animation.forward() : animation.reverse();

        flipAnim = !flipAnim;
      },
      child: AnimatedIcon(
        icon: super.widget.animatedIconData,
        progress: animation,
        size: iconSize,
      ),
    );
  }
}
