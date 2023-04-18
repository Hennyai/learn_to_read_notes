import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:note_anki/globals.dart' as globals;
import 'package:note_anki/models/scale.dart';
import 'package:note_anki/pages/setting.dart';
import 'package:note_anki/util/notes.dart';
import 'package:note_anki/util/pitch_asset.dart';
import 'package:piano/piano.dart';
import 'dart:math';

import '../../models/note_address.dart';
import '../../models/sheet_music.dart';
import '../../util/clef_asset.dart';

//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title' : 'Read the notes!',
    'alert' : "Actually, it's: "
  },
  'vi': {
    'title' : 'Đọc nốt nhạc!',
    'alert' : 'Đáp án đúng là: '
  },
};



final random = Random();
int notePosition = 0;
bool trebleClef = randomClef();
List<String> notes = randomNotes(trebleClef);
List<int> noteColor = generateNoteColor();
String scale = randomScale();

String alert = '';
Color alertColor = globals.color('card') as Color;

bool checkChangeSetting(){
  if (globals.settingsChanged) {
    globals.settingsChanged=false;
    return true;
  }
  return false;
}

void randomOrRevision(){
  int totalWeight = globals.randomSheetWeight;
  globals.notesFailed.forEach((note) {
    totalWeight+=note.weight;
  });
  int randomNumber = random.nextInt(totalWeight) + 1;

  randomNumber-=globals.randomSheetWeight;
  if(randomNumber<=0){
    return randomSheet();
  } else {
    return revisionSheet();
  }
}

void randomSheet(){
  trebleClef = randomClef();
  notes = randomNotes(trebleClef);
  scale = randomScale();
  alert = '';
  alertColor = globals.color('card') as Color;
  noteColor = generateNoteColor();
}

void revisionSheet(){
  if(globals.selectedClef[0]&&globals.selectedClef[1]){
    revisionTemplate(globals.notesFailed.where((element) => (scaleCheck(element.note.scale))).toList());
  }
  else {
    revisionTemplate(globals.notesFailed.where((element) => (element.note.trebleClef==globals.selectedClef[0]&&scaleCheck(element.note.scale))).toList());
  }
}

void revisionTemplate(List<failedNote> notesFailed){
  if(notesFailed.isEmpty) return randomSheet();

  int totalWeight = 0;
  notesFailed.forEach((note) {
    totalWeight += note.weight;
  });
  int randomNumber = random.nextInt(totalWeight) + 1;

  noteAddress? selectedNote;
  for (int i = 0; i < notesFailed.length; i++) {
    randomNumber -= notesFailed[i].weight;

    if (randomNumber <= 0) {
      selectedNote = notesFailed[i].note;
      break;
    }
  }

  if (selectedNote != null) {
    trebleClef = selectedNote.trebleClef;
    scale = selectedNote.scale;
    notes = randomNotes(trebleClef);
    notes[0] = selectedNote.noteName;
    alert = '';
    alertColor = globals.color('card') as Color;
    noteColor = generateNoteColor();
    noteColor[0] = 3;
  } else {
    randomSheet();
  }
}


void checkFailed(noteAddress noteFailed){
  int indexOfNote = globals.notesFailed.indexWhere((element) => element.note.equals(noteFailed));
  if(indexOfNote>=0)  globals.notesFailed[indexOfNote].weight++;
    else globals.notesFailed.add(failedNote(noteFailed, 1));
}

void checkPassed(noteAddress notePassed){
  int indexOfNote = globals.notesFailed.indexWhere((element) => element.note.equals(notePassed));
  if(indexOfNote>=0){
    if(globals.notesFailed[indexOfNote].weight>1) globals.notesFailed[indexOfNote].weight--;
      else globals.notesFailed.removeAt(indexOfNote);
  }
}






class ClassicRead extends StatefulWidget {
  const ClassicRead({Key? key}) : super(key: key);

  @override
  State<ClassicRead> createState() => _ClassicReadState();
}



class _ClassicReadState extends State<ClassicRead> {
  @override
  Widget build(BuildContext context) {
    double fontSize = min(20, MediaQuery.of(context).size.height/20);

    if(notePosition > globals.numberOfNotes) {
      randomOrRevision();
      notePosition = 0;
    };


    Map<String, String>? messages = docMessages[globals.language];

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: globals.color('text'),
        ),
        backgroundColor: globals.color('appbar'),
        title: Text(messages!['title'] as String, style: TextStyle(color: globals.color('text'), fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
            }
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context){return const Setting();}).then((value) {
                messages = docMessages[globals.language];
                if(alert.length>5){
                  alert = messages!['alert']!+getNoteName(scale, notes[notePosition]);
                }
                setState(() {
                  if (checkChangeSetting()) {
                    randomOrRevision();
                    notePosition = 0;
                    noteColor = generateNoteColor();
                  }
                  if(notePosition==0){
                    alertColor = globals.color('card') as Color;
                  }
                });
              });
            },
            color: globals.color('icon 1'),
          ),
        ],
      ),
      backgroundColor: globals.color('background'),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SheetMusic(trebleClef, scale, notes, noteColor, notePosition),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: 300,
              child: Card(
                color: alertColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      alert,
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.grey[100]
                      ),
                    ),
                  ],
                ),
              ),
            )
          ),
          Expanded(
            flex: 4,
            child: InteractivePiano(
              hideNoteNames: globals.hideNoteNames,
              hideScrollbar: true,
              naturalColor: globals.color('natural key') as Color,
              accidentalColor: globals.color('accidental key') as Color,
              keyWidth: MediaQuery.of(context).size.width / 7,
              noteRange: NoteRange(NotePosition(note: Note.C, octave: 3), NotePosition(note: Note.B, octave: 3)),
              onNotePositionTapped: (position) {
                String noteName = position.note.name.toString() + position.accidental.symbol.toString();
                // Use an audio library like flutter_midi to play the sound




                if(notePosition<globals.numberOfNotes){
                  if(compareNotes(noteName, getNoteName(scale, notes[notePosition]))){
                    //Correct:
                    final audioPlayer = AudioPlayer();
                    audioPlayer.setVolume(globals.volume);
                    audioPlayer.play(AssetSource('audio/'+sharpToSharp(noteName)+'.wav'));

                    checkPassed(noteAddress(trebleClef, scale, notes[notePosition]));
                    noteColor[notePosition]=1;
                    alert = getNoteName(scale, notes[notePosition]);
                    alertColor = globals.color('correct') as Color;
                  } else {
                    //Incorrect:
                    final audioPlayer = AudioPlayer();
                    audioPlayer.setVolume(globals.volume);
                    audioPlayer.play(AssetSource('audio/Wrong_answer.mp3'));

                    checkFailed(noteAddress(trebleClef, scale, notes[notePosition]));
                    noteColor[notePosition]=2;
                    alert = messages!['alert']!+getNoteName(scale, notes[notePosition]);
                    alertColor = globals.color('incorrect') as Color;
                  }
                }

                notePosition++;
                setState(() {});
              },
            )
          )
        ],
      ),
    );
  }
}
