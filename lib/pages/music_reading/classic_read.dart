import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:learn_to_read_notes/models/scale.dart';
import 'package:learn_to_read_notes/pages/setting.dart';
import 'package:learn_to_read_notes/util/notes.dart';
import 'package:learn_to_read_notes/util/pitch_asset.dart';
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
int checkChangeNumber = -1;
String alert = '';
Color alertColor = globals.color('card') as Color;


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


void revisionTemplate(List<failedNote> notesFailed){
  int totalWeight = 0;
  notesFailed.forEach((note) {
    totalWeight += note.weight;
  });
  if(totalWeight == 0 ) {
    print("The weight is 0 for some reason");
    return randomSheet();
  }
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

void revisionSheet(){
  bool haveClef = revisionHaveClef();

  if(globals.selectedClef[0]&&globals.selectedClef[1]){
    List<failedNote> notesFailedWithClef = [];
    for (int i = 0; i < globals.notesFailed.length; i++){
      if(scaleCheck(globals.notesFailed[i].note.scale)){
        notesFailedWithClef.add(globals.notesFailed[i]);
      }
    }
    revisionTemplate(notesFailedWithClef);
  }
  else if(haveClef&&globals.notesFailed.isNotEmpty) {
    List<failedNote> notesFailedWithClef = [];
    bool clef = globals.selectedClef[0];
    for (int i = 0; i < globals.notesFailed.length; i++){
      if(globals.notesFailed[i].note.trebleClef==clef&&scaleCheck(globals.notesFailed[i].note.scale)){
        notesFailedWithClef.add(globals.notesFailed[i]);
      }
    }
    if(notesFailedWithClef.isNotEmpty) {
      revisionTemplate(notesFailedWithClef);
    }
      else {
      randomSheet();
    }
  } else {
    randomSheet();
  }
}


void checkFailed(noteAddress noteFailed){
  bool contain = false;

  for (var i = 0; i < globals.notesFailed.length; i++) {
    var e = globals.notesFailed[i];
    if (e.note.equals(noteFailed)) {
      e.weight++;
      contain = true;
      break;
    }
  }

  if(!contain)  globals.notesFailed.add(failedNote(noteFailed, 1));
}

void checkPassed(noteAddress notePassed){
  for (var i = 0; i < globals.notesFailed.length; i++) {
    var e = globals.notesFailed[i];
    if (e.note.equals(notePassed)) {
      if(e.weight>1){
        e.weight--;
      } else {
        globals.notesFailed.removeAt(i);
      }
    }
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
              Navigator.of(context).pushReplacementNamed('/music_reading');
            }
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(context: context, builder: (BuildContext context){return Setting();}).then((value) => setState(() {
                if (checkChangeNumber!=globals.numberOfNotes) {
                  checkChangeNumber=globals.numberOfNotes;
                  randomOrRevision();
                  notePosition = 0;
                  noteColor = generateNoteColor();
                }
                if(notePosition==0){
                  alertColor = globals.color('card') as Color;
                }
              }));
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
              naturalColor: Colors.white,
              accidentalColor: Colors.black,
              keyWidth: MediaQuery.of(context).size.width / 7,
              noteRange: NoteRange(NotePosition(note: Note.C, octave: 3), NotePosition(note: Note.B, octave: 3)),
              onNotePositionTapped: (position) {
                String noteName = position.note.name.toString() + position.accidental.symbol.toString();
                // Use an audio library like flutter_midi to play the sound




                if(notePosition<globals.numberOfNotes){
                  //print(noteName);
                  //print(getNoteName(scale, notes[notePosition]));

                  //print(compareNotes(noteName, getNoteName(scale, notes[notePosition])));

                  if(compareNotes(noteName, getNoteName(scale, notes[notePosition]))){
                    //Correct:
                    checkPassed(noteAddress(trebleClef, scale, notes[notePosition]));
                    noteColor[notePosition]=1;
                    alert = getNoteName(scale, notes[notePosition]);
                    alertColor = globals.color('correct') as Color;
                    //print(globals.notesFailed);
                  } else {
                    //Incorrect
                    checkFailed(noteAddress(trebleClef, scale, notes[notePosition]));
                    noteColor[notePosition]=2;
                    alert = messages['alert']!+getNoteName(scale, notes[notePosition]);
                    alertColor = globals.color('incorrect') as Color;
                    //print(globals.notesFailed);
                    //revisionSheet();
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
