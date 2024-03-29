import 'package:flutter/material.dart';

import 'models/note_address.dart';

List<failedNote> notesFailed = [];
bool hideNoteNames = true;

double volume = 0.5;

bool settingsChanged = false;

bool advancedSettings = false;
final List<bool> selectedClef = <bool>[
  true,//treble
  true];//bass
List<bool> selectedScale = <bool>[
  true, //cMajor,
  true, //gMajor,
  true, //dMajor,
  true, //aMajor,
  true, //eMajor,
  true, //bMajor,
  true, //fSMajor,
  true, //cSMajor,
  true, //fMajor,
  true, //bbMajor,
  true, //ebMajor,
  true, //abMajor,
  true, //dbMajor,
  true, //gbMajor,
  true, //cbMajor,
];

String language = 'en';
String currentTheme = 'light';

double sheetMusicSize = 100;

int numberOfNotes = 3;

int randomSheetWeight = 51;

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
    'revision' : Colors.amberAccent,
    'inactive slider' : Colors.deepPurple[50],
    'toggle border' : Colors.purple[700],
    'natural key' : Colors.white,
    'accidental key' : Colors.black,
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
    'revision' : Colors.amberAccent,
    'inactive slider' : Colors.grey[900],
    'toggle border' : Colors.grey[850],
    'natural key' : Colors.grey[400],
    'accidental key' : Colors.black,
  },
};

Color? color(String context){
  return theme[currentTheme]![context];
}

int clefHeight = 600;
int clefWidth = 231;
int scaleHeight = 600;
int scaleWidth = 597;
int noteHeight = 600;
int noteWidth = 344;

