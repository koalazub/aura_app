import 'dart:ui';

import 'package:flutter/material.dart';

const double largeText = 36.0;
const double mediumText = 24.0;
const double smallText = 12.0;

const String fontNameDefault = "JetBrainsMono";
const FontWeight defaultWeight = FontWeight.w300;
const AppBarText = TextStyle(
    fontFamily: fontNameDefault,
    fontWeight: defaultWeight,
    fontSize: mediumText);

const titleText = TextStyle(
    fontFamily: fontNameDefault,
    fontWeight: defaultWeight,
    fontSize: largeText);

const LightAppBar = AppBarTheme(
    color: Color(0xff2f9c95),
    textTheme: TextTheme(headline5: AppBarText, headline6: titleText));

const PlaylistAppBar = AppBarTheme(color: Color(0xff664147));
