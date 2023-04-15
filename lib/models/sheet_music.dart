import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:learn_to_read_notes/pages/music_reading/classic_read.dart';
import 'package:learn_to_read_notes/util/clef_asset.dart';
import 'package:learn_to_read_notes/util/pitch_asset.dart';

import '../util/scale_asset.dart';

double padding = 10;

double getNoteWidth(){
  return globals.sheetMusicSize/globals.noteHeight*globals.noteWidth;
}
double getScaleWidth(){
  return globals.sheetMusicSize/globals.scaleHeight*globals.scaleWidth;
}
double getClefWidth(){
  return globals.sheetMusicSize/globals.clefHeight*globals.clefWidth;
}
Color numberToColor(int i){
  switch(i){
    case 1: return globals.color('correct') as Color;
    case 2: return globals.color('incorrect') as Color;
    case 3: return globals.color('revision') as Color;
  };
  return globals.color('note') as Color;
}


class SheetMusic extends StatefulWidget {
  //const SheetMusic({Key? key}) : super(key: key);
  bool trebleClef;
  String scale;
  List<String> notes;
  List<int> noteColor;
  double totalWidth=0;
  int notePosition = 0;


  SheetMusic(this.trebleClef, this.scale, this.notes, this.noteColor, this.notePosition){
    totalWidth = getClefWidth()+getScaleWidth()+getNoteWidth()*notes.length;
  }





  @override
  State<SheetMusic> createState() => _SheetMusicState();
}

class _SheetMusicState extends State<SheetMusic> {



  @override
  Widget build(BuildContext context) {
    bool trebleClef = widget.trebleClef;
    String scale = widget.scale;
    List<String> notes = widget.notes;
    List<int> noteColor = widget.noteColor;
    int colorIndex = 0;
    notePosition=widget.notePosition;


    double screenWidth = MediaQuery.of(context).size.width - padding * 2 - 15;
    double screenHeight = MediaQuery.of(context).size.height*3/8 - padding * 2 - 29;
    double imageHeight = min(globals.sheetMusicSize, screenHeight);

    double totalWidth = widget.totalWidth*imageHeight/globals.sheetMusicSize;

    bool overflow = totalWidth > screenWidth;



    if(!overflow) {
      return Card(
          color: globals.color('sheet card'),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: oneLineSheet(trebleClef, scale, notes, noteColor, colorIndex, imageHeight),
          )
      );
    } else {
      int overflowNumber = ((totalWidth-screenWidth)/(getNoteWidth()*imageHeight/globals.sheetMusicSize)).ceil();
      int numberOfNotes = notes.length-overflowNumber;
      int currentLine = notePosition == 0 ? 1 : (notePosition/numberOfNotes).ceil();
      int totalLine = (notes.length/numberOfNotes).ceil();

      List<String> notesLine1;
      List<int> colorLine1;
      List<String> notesLine2;
      List<int> colorLine2;


      if(currentLine!=totalLine) {
        notesLine1 = notes.sublist(
            (currentLine - 1) * numberOfNotes,
            (currentLine - 1) * numberOfNotes + numberOfNotes);
        colorLine1 = noteColor.sublist(
            (currentLine - 1) * numberOfNotes,
            (currentLine - 1) * numberOfNotes + numberOfNotes);
        notesLine2 = notes.sublist(currentLine * numberOfNotes,
            min(currentLine * numberOfNotes + numberOfNotes, notes.length));
        colorLine2 = noteColor.sublist(currentLine * numberOfNotes,
            min(currentLine * numberOfNotes + numberOfNotes, notes.length));
      } else {
        notesLine1 = notes.sublist(
            (currentLine - 2) * numberOfNotes,
            (currentLine - 2) * numberOfNotes + numberOfNotes);
        colorLine1 = noteColor.sublist(
            (currentLine - 2) * numberOfNotes,
            (currentLine - 2) * numberOfNotes + numberOfNotes);
        notesLine2 = notes.sublist((currentLine-1) * numberOfNotes,
            min((currentLine-1) * numberOfNotes + numberOfNotes, notes.length));
        colorLine2 = noteColor.sublist((currentLine-1) * numberOfNotes,
            min((currentLine-1) * numberOfNotes + numberOfNotes, notes.length));
      }

      if(screenHeight<200){
        return Card(
          color: globals.color('sheet card'),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: oneLineSheet(
                trebleClef, scale, notesLine1, colorLine1, colorIndex, imageHeight),
          ),
        );
      } else {
        return Card(
          color: globals.color('sheet card'),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                oneLineSheet(
                    trebleClef, scale, notesLine1, colorLine1, colorIndex, imageHeight),
                oneLineSheet(
                    trebleClef, scale, notesLine2, colorLine2, colorIndex, imageHeight)
              ],
            ),
          ),
        );
      }
    }
  }
}


class oneLineSheet extends StatelessWidget {
  bool trebleClef;
  String scale;
  List<String> notes;
  List<int> noteColor;
  int colorIndex = 0;
  double imageHeight = globals.sheetMusicSize;


  oneLineSheet(this.trebleClef, this.scale, this.notes, this.noteColor, this.colorIndex, this.imageHeight);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                  globals.color('note') as Color, BlendMode.srcIn),
              child: Image.asset(
                'assets/images/note/none.png',
                height: imageHeight,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                fit: BoxFit.fill,
              ),
            ),
            Row(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      globals.color('note') as Color, BlendMode.srcIn),
                  child: Image.asset(
                    getClefAsset(trebleClef),
                    height: imageHeight,
                  ),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      globals.color('note') as Color, BlendMode.srcIn),
                  child: Image.asset(
                    getScaleAsset(scale, trebleClef),
                    height: imageHeight,
                  ),
                ),
                ...notes.map((note) {
                  Color thisColor = numberToColor(noteColor[colorIndex]);
                  colorIndex++;
                  return ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        thisColor, BlendMode.srcIn),
                    child: Image.asset(
                      getPitchAsset(note, trebleClef),
                      height: imageHeight,
                    ),
                  );
                }).toList(),
              ],
            )
          ],
        )
      ],
    );
  }
}
