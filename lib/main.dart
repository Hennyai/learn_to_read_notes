import 'package:flutter/material.dart';
import 'package:note_anki/pages/home.dart';
import 'package:note_anki/pages/music_reading/classic_read.dart';
import 'package:note_anki/pages/music_reading/music_reading.dart';
import 'package:note_anki/pages/scale_finder.dart';




void main() {

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => Home(),
      '/music_reading': (context) => MusicReading(),
      '/music_reading/classic' : (context) => ClassicRead(),
      '/scale_finder' : (context) => ScaleFinder(),
    },
  ));
}