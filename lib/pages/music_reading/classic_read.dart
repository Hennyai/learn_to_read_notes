import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:learn_to_read_notes/models/scale.dart';
import 'package:learn_to_read_notes/pages/setting.dart';
import 'package:learn_to_read_notes/util/notes.dart';
import 'package:learn_to_read_notes/util/pitch_asset.dart';
import 'package:piano/piano.dart';
import 'dart:math';

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
String scale = scaleByNumber(random.nextInt(14));
int checkChangeNumber = -1;
String alert = '';
Color alertColor = globals.color('card') as Color;

void newSheet(){
  trebleClef = randomClef();
  notes = randomNotes(trebleClef);
  scale = scaleByNumber(random.nextInt(14));
  alert = '';
  alertColor = globals.color('card') as Color;
}





class ClassicRead extends StatefulWidget {
  const ClassicRead({Key? key}) : super(key: key);

  @override
  State<ClassicRead> createState() => _ClassicReadState();
}



class _ClassicReadState extends State<ClassicRead> {



  @override
  Widget build(BuildContext context) {

    if(notePosition > globals.numberOfNotes) {
      newSheet();
      notePosition = 0;
      noteColor = generateNoteColor();
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
                  newSheet();
                  notePosition = 0;
                  noteColor = generateNoteColor();
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
            child: SheetMusic(trebleClef, scale, notes, noteColor),
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
                        fontSize: 30,
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
              hideNoteNames: true,
              hideScrollbar: true,
              naturalColor: Colors.white,
              accidentalColor: Colors.black,
              keyWidth: MediaQuery.of(context).size.width / 7,
              noteRange: NoteRange(NotePosition(note: Note.C, octave: 3), NotePosition(note: Note.B, octave: 3)),
              onNotePositionTapped: (position) {
                String noteName = position.note.name.toString() + position.accidental.symbol.toString();
                // Use an audio library like flutter_midi to play the sound




                if(notePosition<globals.numberOfNotes){
                  print(noteName);
                  print(getNoteName(scale, notes[notePosition]));

                  print(compareNotes(noteName, getNoteName(scale, notes[notePosition])));

                  if(compareNotes(noteName, getNoteName(scale, notes[notePosition]))){
                    noteColor[notePosition]++;
                    alert = getNoteName(scale, notes[notePosition]);
                    alertColor = globals.color('correct') as Color;
                  } else {
                    noteColor[notePosition]+=2;
                    alert = messages['alert']!+getNoteName(scale, notes[notePosition]);
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
