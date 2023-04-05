import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
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


  SheetMusic(this.trebleClef, this.scale, this.notes, this.noteColor){
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
    double totalWidth = widget.totalWidth;

    double screenSize = MediaQuery.of(context).size.width - padding * 2 - 6.8;
    bool overflow = totalWidth > screenSize;

    if(!overflow) {
      return Card(
          color: globals.color('sheet card'),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: oneLineSheet(trebleClef, scale, notes, noteColor, colorIndex),
          )
      );
    } else {
      int overflowNumber = ((totalWidth-screenSize)/getNoteWidth()).ceil();
      print(overflowNumber);
      int numberOfNotes = notes.length-overflowNumber;

      List<String> notesLine1 = notes.sublist(0,numberOfNotes);
      List<int> colorLine1 = noteColor.sublist(0,numberOfNotes);
      List<String> notesLine2 = notes.sublist(numberOfNotes,numberOfNotes*2);
      List<int> colorLine2 = noteColor.sublist(numberOfNotes,numberOfNotes*2);


      return Card(
        color: globals.color('sheet card'),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            children: [
              oneLineSheet(trebleClef, scale, notesLine1, colorLine1, colorIndex),
              oneLineSheet(trebleClef, scale, notesLine2, colorLine2, colorIndex)
            ],
          ),
        ),
      );
    }
  }
}


class oneLineSheet extends StatelessWidget {
  bool trebleClef;
  String scale;
  List<String> notes;
  List<int> noteColor;
  int colorIndex = 0;


  oneLineSheet(this.trebleClef, this.scale, this.notes, this.noteColor, this.colorIndex);

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
                height: globals.sheetMusicSize,
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
                    height: globals.sheetMusicSize,
                  ),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      globals.color('note') as Color, BlendMode.srcIn),
                  child: Image.asset(
                    getScaleAsset(scale, trebleClef),
                    height: globals.sheetMusicSize,
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
                      height: globals.sheetMusicSize,
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
