import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;

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

class ScaleFinder extends StatefulWidget {
  const ScaleFinder({Key? key}) : super(key: key);

  @override
  State<ScaleFinder> createState() => _ScaleFinderState();
}

class _ScaleFinderState extends State<ScaleFinder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
