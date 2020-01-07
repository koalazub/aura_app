import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedHudIcon extends StatefulWidget {
  final AnimatedIconData animatedIconData;

  AnimatedHudIcon(this.animatedIconData);

  @override
  State<StatefulWidget> createState() =>
      _AnimatedHudIcon(this.animatedIconData);
}

class _AnimatedHudIcon extends State<AnimatedHudIcon>
    with SingleTickerProviderStateMixin {
  AnimationController animation;
  Duration duration = Duration(milliseconds: 500);

  _AnimatedHudIcon(AnimatedIconData animatedIconData);

  bool flipAnim = false;

  @override
  // TODO: implement widget
  @override
  void initState() {
    super.initState();
    animation = new AnimationController(vsync: this, duration: duration);
    animation.addListener(() => this.setState(() {}));
  }

  void dispose() {
    super.dispose();
    animation?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        flipAnim ? animation.forward() : animation.reverse();

        flipAnim = !flipAnim;
      },
      child: AnimatedIcon(
        icon: super.widget.animatedIconData,
        progress: animation,
        size: 54,
      ),
    );
  }
}
