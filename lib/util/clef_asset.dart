import 'dart:math';

import 'package:learn_to_read_notes/globals.dart' as globals;
import 'assets.dart';

String getClefAsset(bool trebleClef) {
  if (trebleClef) return trebleClef_asset;
  return bassClef_asset;
}

bool randomClef(){
  if(globals.selectedClef[0]&&globals.selectedClef[1]) return Random().nextBool();
  return globals.selectedClef[0];
}

bool revisionHaveClef(){
  if(globals.selectedClef[0]&&globals.selectedClef[1]) return true;
  else if(globals.selectedClef[0]){
    for (int i = 0; i < globals.notesFailed.length; i++){
      if(globals.notesFailed[i].note.trebleClef){
        return true;
      }
    }
  } else{
    for (int i = 0; i < globals.notesFailed.length; i++){
      if(!globals.notesFailed[i].note.trebleClef){
        return true;
      }
    }
  }
  return false;
}