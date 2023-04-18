import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_anki/globals.dart' as globals;
import 'package:note_anki/pages/setting.dart';
import 'package:note_anki/models/choose_card.dart';

//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'play': 'Start training!',
    'play explain': 'Read one or multiple notes on the same scale!',
    'scale' : 'Find scale name',
    'scale explain' : 'Find major scale by entering the number and type of key signatures',
  },
  'vi': {
    'play': 'Bắt đầu tập luyện!',
    'play explain': 'Đọc một hoặc một số nốt nhạc trong cùng một âm giai!',
    'scale' : 'Tìm tên âm giai',
    'scale explain' : 'Tìm tên âm giai trưởng bằng cách nhập số lượng và chọn loại dấu hóa'
  },
};




class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //Message theo ngôn ngữ hiện tại
    final Map<String, String>? messages = docMessages[globals.language];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: globals.color('appbar'),
        title:
          Text('Note Anki', style: TextStyle(color: globals.color('text'), fontSize: 40, fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
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
                    child: ChooseCard(CupertinoIcons.arrow_right_circle_fill, messages!['play'] as String, messages!['play explain'] as String, 'icon 1')
                  )
              ),
              Expanded(
                  child: GestureDetector(
                    onTap: ()=>Navigator.pushReplacementNamed(context, '/scale_finder'),
                    child: ChooseCard(CupertinoIcons.book, messages!['scale'] as String, messages!['scale explain'] as String, 'icon 1' )
                  )
              ),
              const SizedBox(height: 20)
            ],
          ),
        ]
      ),
    );
  }
}
