import 'dart:math';

import 'package:note_anki/globals.dart' as globals;

const List<String> pitchesTreble = <String>[
  "G3",
  "A3",
  "B3",
  "C4",
  "D4",
  "E4",
  "F4",
  "G4",
  "A4",
  "B4",
  "C5",
  "D5",
  "E5",
  "F5",
  "G5",
  "A5",
  "B5",
  "C6",
  "D6"
];

const List<String> pitchesBass = <String>[
  "B1",
  "C2",
  "D2",
  "E2",
  "F2",
  "G2",
  "A2",
  "B2",
  "C3",
  "D3",
  "E3",
  "F3",
  "G3",
  "A3",
  "B3",
  "C4",
  "D4",
  "E4",
  "F4"
];

//Giá trị từ 0-18
String noteByNumber(int code, bool trebleClef){
  if(trebleClef) return pitchesTreble[code];
    return pitchesBass[code];
}

int noteNameToNumber(String name, bool trebleClef){
  if(trebleClef) return pitchesTreble.indexOf(name);
  return pitchesBass.indexOf(name);
}

String sharpToSharp(String noteName){
  return noteName.replaceAll('♯', 'sharp');
}


List<String> randomNotes(bool trebleClef){
  final random = Random();
  List<String> notes = [];
  for(int i = 0; i<globals.numberOfNotes; i++){
    notes.add(noteByNumber(random.nextInt(19), trebleClef));
  }
  return notes;
}

List<int> generateNoteColor(){
  List<int> noteColor = [];
  for(int i = 0; i<globals.numberOfNotes; i++){
    noteColor.add(0);
  };
  return noteColor;
}

bool compareNotes(String note1, String note2){
  if(note1==note2) return true;
  switch(note1+note2){
    case "C♯D♭": return true;
    case "D♭C♯": return true;
    case "D♯E♭": return true;
    case "E♭D♯": return true;
    case "F♯G♭": return true;
    case "G♭F♯": return true;
    case "G♯A♭": return true;
    case "A♭G♯": return true;
    case "A♯B♭": return true;
    case "B♭A♯": return true;
    case "B♯C": return true;
    case "CB♯": return true;
    case "E♯F": return true;
    case "FE♯": return true;
  }
  return false;
}
