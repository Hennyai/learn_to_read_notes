import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:learn_to_read_notes/util/clef_asset.dart';
import 'package:learn_to_read_notes/util/pitch_asset.dart';

import '../util/scale_asset.dart';


class SheetMusic extends StatefulWidget {
  //const SheetMusic({Key? key}) : super(key: key);
  bool trebleClef;
  String scale;
  List<String> notes;
  List<int> noteColor;


  SheetMusic(this.trebleClef, this.scale, this.notes, this.noteColor);




  @override
  State<SheetMusic> createState() => _SheetMusicState();
}

class _SheetMusicState extends State<SheetMusic> {

  Color numberToColor(int i){
    switch(i){
      case 1: return globals.color('correct') as Color;
      case 2: return globals.color('incorrect') as Color;
    };
    return globals.color('note') as Color;
  }

  @override
  Widget build(BuildContext context) {
    bool trebleClef = widget.trebleClef;
    String scale = widget.scale;
    List<String> notes = widget.notes;
    List<int> noteColor = widget.noteColor;
    int colorIndex = 0;

    return Card(
      color: globals.color('sheet card'),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(globals.color('note') as Color, BlendMode.srcIn),
                  child: Image.asset(
                    'assets/images/note/none.png',
                    height: globals.sheetMusicSize,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                  ),
                ),
                Row(
                  children: [
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(globals.color('note') as Color, BlendMode.srcIn),
                      child: Image.asset(
                        getClefAsset(trebleClef),
                        height: globals.sheetMusicSize,
                      ),
                    ),
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(globals.color('note') as Color, BlendMode.srcIn),
                      child: Image.asset(
                        getScaleAsset(scale, trebleClef),
                        height: globals.sheetMusicSize,
                      ),
                    ),
                    ...notes.map((note) {
                      Color thisColor = numberToColor(noteColor[colorIndex]);
                      colorIndex++;
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(thisColor, BlendMode.srcIn),
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
        ),
      ),
    );
  }
}
