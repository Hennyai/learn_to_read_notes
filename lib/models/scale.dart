import 'dart:math';

import 'package:tonic/tonic.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;

List<String> scaleList = [
  "C Major",
  "C# Major",
  "D Major",
  "D# Major",
  "E Major",
  "F Major",
  "F# Major",
  "G Major",
  "G# Major",
  "A Major",
  "A# Major",
  "B Major",
];

enum PossibleScales {
  cMajor,
  gMajor,
  dMajor,
  aMajor,
  eMajor,
  bMajor,
  fSMajor,
  cSMajor,
  fMajor,
  bbMajor,
  ebMajor,
  abMajor,
  dbMajor,
  gbMajor,
  cbMajor,
}

class ScaleInfo {
  final PossibleScales scale;
  final String name, pattern, note;

  ScaleInfo(this.scale, this.name, this.pattern, this.note);

  ScaleInfo.parse(String name)
      : scale = _getScale(name),
        pattern = _getPattern(name),
        note = _getNote(name),
        name = name.toString();

  static String _getNote(String name) {
    if (name.isEmpty) return "";
    String _note = name;
    _note = _note.replaceAll(" ", "");
    _note = _note.toLowerCase().replaceAll("major", "");
    _note = _note.toLowerCase().replaceAll("minor", "");
    _note = _note.toUpperCase();
    return _note.trim() + "4";
  }

  static String _getPattern(String name) {
    if (name.toLowerCase().contains('major')) return 'Diatonic Major';
    if (name.toLowerCase().contains('minor')) return 'Harmonic Minor';
    return 'Diatonic Major';
  }

  static PossibleScales _getScale(String name) {
    switch (name) {
      case "C Major":
      case "A Minor":
        return PossibleScales.cMajor;
      case "C# Major":
      case "C♯ Major":
      case "A# Minor":
      case "A♯ Minor":
        return PossibleScales.cSMajor;
      case "D Major":
      case "B Minor":
        return PossibleScales.dMajor;
      case "D# Major":
      case "D♯ Major":
      case "Eb Major":
      case "E♭ Major":
      case "C Minor":
        return PossibleScales.ebMajor;
      case "E Major":
      case "C# Minor":
      case "C♯ Minor":
        return PossibleScales.eMajor;
      case "F Major":
      case "D Minor":
        return PossibleScales.fMajor;
      case "F# Major":
      case "F♯ Major":
      case "D# Minor":
      case "D♯ Minor":
        return PossibleScales.fSMajor;
      case "G Major":
      case "E Minor":
        return PossibleScales.gMajor;
      case "G# Major":
      case "G♯ Major":
      case "Ab Major":
      case "A♭ Major":
      case "F Minor":
        return PossibleScales.abMajor;
      case "A Major":
      case "F# Minor":
      case "F♯ Minor":
        return PossibleScales.aMajor;
      case "A# Major":
      case "A♯ Major":
      case "Bb Major":
      case "B♭ Major":
      case "G Minor":
        return PossibleScales.bbMajor;
      case "B Major":
      case "G# Minor":
      case "G♯ Minor":
        return PossibleScales.bMajor;
      case "Db Major":
      case "D♭ Major":
      case "B♭ Minor":
      case "Bb Minor":
        return PossibleScales.dbMajor;
      case "Gb Major":
      case "G♭ Major":
      case "E♭ Minor":
      case "Eb Minor":
        return PossibleScales.gbMajor;
      case "Cb Major":
      case "C♭ Major":
      case "A♭ Minor":
      case "Ab Minor":
        return PossibleScales.cbMajor;
    }
    return PossibleScales.cMajor;
  }
}

Pitch? getScaleRoot(String scaleName) {
  final Pitch _root = Chord.parse(scaleName).root;
  final String _newRoot =
      _root.toString().replaceAllMapped(new RegExp(r'[0-9]'), (Match match) {
    return '4'; // Default Octave
  }).trim();
  final String scaleRoot = _newRoot.toString();
  try {
    return Pitch.parse(scaleRoot);
  } catch (e) {
    print("$scaleRoot => $e");
    return null;
  }
}

String scaleByNumber(int code){
  return scaleList[code];
}

int scaleNameToNumber(String name){
  return scaleList.indexOf(name);
}

bool scaleCheck(String name){
  return globals.selectedScale[scaleNameToNumber(name)];
}

String randomScale(){
  if(!globals.selectedScale.contains(true)) return scaleByNumber(0);
  final random = Random();
  int chosenNumber = random.nextInt(12);
  while(!globals.selectedScale[chosenNumber]){
    chosenNumber = random.nextInt(12);
  }
  return scaleByNumber(chosenNumber);
}