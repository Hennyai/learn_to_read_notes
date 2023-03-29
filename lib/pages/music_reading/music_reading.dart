import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:learn_to_read_notes/models/choose_card.dart';
import 'package:learn_to_read_notes/pages/setting.dart';

//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title' : 'Choose your training',
    'normal reading': 'Note recognition',
    'normal reading explaination': 'Read one or multiple notes on the same scale',
    'sight read' : 'Sight reading',
    'sight read explain' : 'Train sight reading by connecting your midi devices to play'
  },
  'vi': {
    'title' : 'Chọn bài tập',
    'normal reading': 'Nhận biết nốt nhạc',
    'normal reading explaination': 'Đọc một hoặc một số nốt nhạc trong cùng một âm giai',
    'sight read' : 'Thị tấu',
    'sight read explain' : 'Luyện thị tấu bằng cách kết nối thiết bị midi vào máy để chơi'
  },
};



class MusicReading extends StatefulWidget {
  const MusicReading({Key? key}) : super(key: key);

  @override
  State<MusicReading> createState() => _MusicReadingState();
}

class _MusicReadingState extends State<MusicReading> {
  @override
  Widget build(BuildContext context) {
    final Map<String, String>? messages = docMessages[globals.language];
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
              showDialog(context: context, builder: (BuildContext context){return Setting();}).then((value) => setState(() {}));
            },
            color: globals.color('icon 1'),
          ),
        ],
      ),
      backgroundColor: globals.color('background'),
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
              Expanded(
                  child: GestureDetector(
                    onTap: ()=>Navigator.pushReplacementNamed(context, '/music_reading/classic'),
                    child: ChooseCard(CupertinoIcons.double_music_note, messages!['normal reading'] as String, messages!['normal reading explaination'] as String, 'icon 1')
                  )
              ),
              Expanded(child: ChooseCard(CupertinoIcons.piano, messages!['sight read'] as String, messages!['sight read explain'] as String, 'icon 1')),
              SizedBox(height: 20)
            ],
          ),
        ]
      ),
    );
  }
}
