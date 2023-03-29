import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;

import 'package:learn_to_read_notes/models/choose_card.dart';

import '../models/number_picker.dart';

//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title': 'Setting',
    'dark theme' : 'Dark theme',
    'dark theme explain' : 'Click to switch to light theme',
    'light theme' : 'Light theme',
    'light theme explain' : 'Click to switch to dark theme',
    'language' : "English",
    'language explain' : "Click to switch to Vietnamese",
  },
  'vi': {
    'title': 'Cài đặt',
    'dark theme' : 'Chế độ tối',
    'dark theme explain' : 'Nhấn để chuyển sang chế độ sáng',
    'light theme' : 'Chế độ sáng',
    'light theme explain' : 'Nhấn để chuyển sang chế độ tối',
    'language' : "Tiếng Việt",
    'language explain' : "Nhấn để chuyển sang tiếng Anh"
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

  @override
  Widget build(BuildContext context) {
    messages = docMessages[globals.language];
    IconData themeIcon;
    if(globals.currentTheme=='dark') themeIcon = Icons.dark_mode;
      else themeIcon = Icons.light_mode;

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
          Column(
            children: [
              NumberPicker(),
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
        ]
      )
    );
  }
}
