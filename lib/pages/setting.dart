import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;

import 'package:learn_to_read_notes/models/choose_card.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../models/number_picker.dart';

//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title': 'Settings',
    'dark theme' : 'Dark theme',
    'dark theme explain' : 'Click to switch to light theme',
    'light theme' : 'Light theme',
    'light theme explain' : 'Click to switch to dark theme',
    'language' : "English",
    'language explain' : "Click to switch to Vietnamese",
    'show note names' : "Show note names",
    'hide note names' : "Hide note names",
    'hide note explain' : "Hide the C3, C#3, D3... on the keys",
    'show note explain' : "Show the C3, C#3, D3... on the keys",
    'advanced' : 'Advanced',
    'random weight' : "Random music sheet's weight"
  },
  'vi': {
    'title': 'Cài đặt',
    'dark theme' : 'Chế độ tối',
    'dark theme explain' : 'Nhấn để chuyển sang chế độ sáng',
    'light theme' : 'Chế độ sáng',
    'light theme explain' : 'Nhấn để chuyển sang chế độ tối',
    'language' : "Tiếng Việt",
    'language explain' : "Nhấn để chuyển sang tiếng Anh",
    'show note names' : "Hiển thị tên nốt",
    'hide note names' : "Ẩn tên nốt",
    'hide note explain' : "Ẩn những tên C3, C#3, D3... trên phím đàn",
    'show note explain' : "Hiện những tên C3, C#3, D3... trên phím đàn",
    'advanced' : 'Nâng cao',
    'random weight' : 'Trọng số random khung nhạc'
  },
};

//Message theo ngôn ngữ hiện tại
Map<String, String>? messages = docMessages[globals.language];


class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  void switchNoteNames(){
    if(globals.hideNoteNames) globals.hideNoteNames=false;
      else globals.hideNoteNames=true;
    setState(() {});
  }
  void switchTheme(){
    if(globals.currentTheme == 'dark') globals.currentTheme = 'light';
      else globals.currentTheme = 'dark';
    setState(() {});
  }
  void switchLanguage(){
    if(globals.language == 'en') globals.language = 'vi';
      else globals.language = 'en';
    setState(() {});
  }
  void switchAdvanced(){
    if(globals.advancedSettings) globals.advancedSettings=false;
      else globals.advancedSettings=true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    messages = docMessages[globals.language];
    IconData themeIcon;
    IconData noteNamesIcon;
    String noteNamesTitle;
    String noteNamesExplain;
    if(globals.currentTheme=='dark') themeIcon = Icons.dark_mode;
      else themeIcon = Icons.light_mode;
    if(globals.hideNoteNames){
      noteNamesIcon = Icons.abc;
      noteNamesTitle = messages!['show note names'] as String;
      noteNamesExplain = messages!['show note explain'] as String;
    } else {
      noteNamesIcon = CupertinoIcons.piano;
      noteNamesTitle = messages!['hide note names'] as String;
      noteNamesExplain = messages!['hide note explain'] as String;
    }


    if(globals.advancedSettings){
      return Scaffold(
          backgroundColor: globals.color('background'),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: globals.color('text'),

            ),
            backgroundColor: globals.color('appbar'),
            title:
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.settings, color: globals.color('text'),),
                ),
                Text(messages!['title'] as String, style: TextStyle(color: globals.color('text'), fontSize: 40, fontWeight: FontWeight.bold)),
                Expanded(child: SizedBox()),
                ElevatedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.resolveWith<BorderSide>(
                            (Set<MaterialState> states) {
                          return BorderSide(
                            color: globals.color('button') as Color,
                            width: 2.0,
                          );
                        },
                      ),
                    backgroundColor: MaterialStateProperty.all<Color>(globals.color('button') as Color),
                    foregroundColor: MaterialStateProperty.all<Color>(globals.color('button text') as Color),
                  ),
                  onPressed: switchAdvanced,
                  child: Text(messages!['advanced'] as String),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(globals.color('background pattern') as Color, BlendMode.srcIn),
                        child: Image.asset('assets/images/pattern/marumarumaru.png', height: 300, repeat: ImageRepeat.repeat,)
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      NumberPicker(),
                      //Random weight slider
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                        child: Card(
                          color: globals.color('card'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: globals.color('card'),
                              boxShadow: [
                                BoxShadow(
                                  color: globals.color('shadow') as Color,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text(
                                      messages!["random weight"] as String,
                                      style: TextStyle(
                                        color: globals.color("text")
                                      ),
                                    ),
                                  ),
                                  SfSlider(
                                    min: 0.0,
                                    max: 300.0,
                                    value: globals.randomSheetWeight.toDouble()-1,
                                    interval: 50,
                                    showTicks: true,
                                    showLabels: false,
                                    enableTooltip: true,
                                    minorTicksPerInterval: 1,
                                    activeColor: globals.color('button') as Color,
                                    inactiveColor: globals.color('inactive slider') as Color,
                                    onChanged: (dynamic value){
                                      setState(() {
                                        globals.randomSheetWeight = value.ceil()+1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(11, 0, 11, 0),
                        child: Card(
                          color: globals.color('card'),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: globals.color('card'),
                              boxShadow: [
                                BoxShadow(
                                  color: globals.color('shadow') as Color,
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(4, 4, 0, 4),
                                      child: Card(
                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                "Treble Clef"
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                                      child: Card(
                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                                "Bass Clef"
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          onTap: () => switchNoteNames(),
                          child: ChooseCard(noteNamesIcon, noteNamesTitle, noteNamesExplain, 'icon 1')
                      ),
                      GestureDetector(
                          onTap: () => switchTheme(),
                          child: ChooseCard(themeIcon, messages!['dark theme'] as String, messages!['dark theme explain'] as String, 'icon 1')
                      ),
                      GestureDetector(
                          onTap: () =>switchLanguage(),
                          child: ChooseCard(Icons.language, messages!['language'] as String, messages!['language explain'] as String, 'icon 1' )
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              ]
          )
      );
    }else{
      return Scaffold(
          backgroundColor: globals.color('background'),
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: globals.color('text'),

            ),
            backgroundColor: globals.color('appbar'),
            title:
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Icon(Icons.settings, color: globals.color('text'),),
                ),
                Text(messages!['title'] as String, style: TextStyle(color: globals.color('text'), fontSize: 40, fontWeight: FontWeight.bold)),
                Expanded(child: SizedBox()),
                ElevatedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.resolveWith<BorderSide>(
                          (Set<MaterialState> states) {
                        return BorderSide(
                          color: globals.color('button') as Color,
                          width: 2.0,
                        );
                      },
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(globals.color('button text') as Color),
                    foregroundColor: MaterialStateProperty.all<Color>(globals.color('button') as Color),
                  ),
                  onPressed: switchAdvanced,
                  child: Text(messages!['advanced'] as String),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ColorFiltered(
                        colorFilter: ColorFilter.mode(globals.color('background pattern') as Color, BlendMode.srcIn),
                        child: Image.asset('assets/images/pattern/marumarumaru.png', height: 300, repeat: ImageRepeat.repeat,)
                    ),
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      NumberPicker(),
                      GestureDetector(
                          onTap: () => switchNoteNames(),
                          child: ChooseCard(noteNamesIcon, noteNamesTitle, noteNamesExplain, 'icon 1')
                      ),
                      GestureDetector(
                          onTap: () => switchTheme(),
                          child: ChooseCard(themeIcon, messages!['dark theme'] as String, messages!['dark theme explain'] as String, 'icon 1')
                      ),
                      GestureDetector(
                          onTap: () =>switchLanguage(),
                          child: ChooseCard(Icons.language, messages!['language'] as String, messages!['language explain'] as String, 'icon 1' )
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ]
          )
      );
    }
  }
}
