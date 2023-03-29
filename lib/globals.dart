import 'package:flutter/material.dart';

String language = 'en';
String currentTheme = 'light';

double sheetMusicSize = 100;

int numberOfNotes = 3;

Map<String, Map<String, Color?>> theme = {
  'light' : {
    'appbar' : Colors.white,
    'background' : Colors.grey[200],
    'text' : Colors.grey[800],
    'light text' : Colors.grey[600],
    'card' : Colors.white,
    'card hover' : Colors.deepPurple[50],
    'shadow': Colors.grey.withOpacity(0.5),
    'icon 1' : Colors.purple[400],
    'background pattern' : Colors.deepPurple[400],
    'sheet card' : Colors.white,
    'note' : Colors.grey[900],
    'button' : Colors.purple[400],
    'button text' : Colors.white,
    'correct' : Colors.greenAccent[400],
    'incorrect' : Colors.redAccent,
  },
  'dark' : {
    'appbar' : Colors.grey[900],
    'background' : Colors.grey[850],
    'text' : Colors.grey[50],
    'light text' : Colors.grey[400],
    'card' : Colors.grey[850],
    'card hover' : Colors.grey[800],
    'shadow': Colors.black.withOpacity(0.5),
    'icon 1' : Colors.white,
    'background pattern' : Colors.grey[900],
    'sheet card' : Colors.grey[800],
    'note' : Colors.grey[400],
    'button' : Colors.grey[400],
    'button text' : Colors.grey[900],
    'correct' : Colors.greenAccent[400],
    'incorrect' : Colors.redAccent,
  },
};

Color? color(String context){
  return theme[currentTheme]![context];
}

