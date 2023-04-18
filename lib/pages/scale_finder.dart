import 'package:flutter/material.dart';
import 'package:note_anki/globals.dart' as globals;
import 'package:note_anki/pages/setting.dart';


//Danh sách message
final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title' : 'Find the scale',
    'dropdown title' : 'Number of key signatures: ',
    'key signature' : 'Key signature type:',
    'alternative' : 'Relative scale: '
  },
  'vi': {
    'title' : 'Tìm âm giai',
    'dropdown title' : 'Số lượng dấu hóa: ',
    'key signature' : 'Loại dấu hóa:',
    'alternative' : 'Âm giai tương thích: '
  },
};
Map<String, String>? messages = docMessages[globals.language];

class ScaleFinder extends StatefulWidget {
  const ScaleFinder({Key? key}) : super(key: key);

  @override
  State<ScaleFinder> createState() => _ScaleFinderState();
}

class _ScaleFinderState extends State<ScaleFinder> {
  List<bool> selectedSignature = [true, false];

  int _selectedNumber=0;

  List<int> _numbers = List<int>.generate(8, (index) => index);

  Color toggleBackgroundColor(bool check){
    if(check) return globals.color('button') as Color;
    return globals.color('button text') as Color;
  }
  Color toggleForegroundColor(bool check){
    if(check) return globals.color('button text') as Color;
    return globals.color('button') as Color;
  }

  @override
  Widget build(BuildContext context) {
    messages = docMessages[globals.language];
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.topCenter,
                  child: Card(
                    color: globals.color('card') as Color,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: globals.color('card'),
                        boxShadow: [
                          BoxShadow(
                            color: (globals.color('shadow') as Color).withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              messages!['dropdown title'] as String,
                              style: TextStyle(
                                fontSize: 20,
                                color: globals.color('text') as Color
                              ),
                            ),
                            DropdownButton<int>(
                              focusColor: Colors.transparent,
                              value: _selectedNumber,
                              icon: Icon(Icons.arrow_downward, color: globals.color('icon 1')),
                              elevation: 16,
                              style: TextStyle(color: globals.color('icon 1') as Color),
                              dropdownColor: globals.color('card') as Color,
                              underline: Container(
                                height: 2,
                                color: globals.color('icon 1') as Color,
                              ),
                              items: _numbers.map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                                    child: Text(
                                      '$value',
                                      style: const TextStyle(
                                        fontSize: 20
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (int? value) {
                                // This is called when the user selects an item.
                                setState(() {
                                  _selectedNumber = value!;
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
                //Included signature
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                            child: Text(
                              messages!['key signature'] as String,
                              style: TextStyle(
                                color: globals.color('text'),
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(8, 8, 4, 8),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                        return BorderSide(
                                          color: globals.color('button') as Color,
                                          width: 2.0,
                                        );
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(toggleBackgroundColor(selectedSignature[0])),
                                  ),
                                  onPressed: (){
                                    setState(() {
                                      selectedSignature[0]=!selectedSignature[0];
                                      selectedSignature[1]=!selectedSignature[0];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child:Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              toggleForegroundColor(selectedSignature[0]),
                                              BlendMode.srcIn
                                          ),
                                          child: Image.asset(
                                            'assets/icons/sharp.png',
                                            height: 50,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(4, 8, 8, 8),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                        return BorderSide(
                                          color: globals.color('button') as Color,
                                          width: 2.0,
                                        );
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(toggleBackgroundColor(selectedSignature[1])),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      selectedSignature[1]=!selectedSignature[1];
                                      selectedSignature[0]=!selectedSignature[1];
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 13, 8, 13),
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.mode(
                                              toggleForegroundColor(selectedSignature[1]),
                                              BlendMode.srcIn
                                          ),
                                          child: Image.asset(
                                            'assets/icons/flat.png',
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height:12),
                Padding(
                  padding: EdgeInsets.all(12.0),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          textAlign: TextAlign.center,
                          scaleAnswer(_selectedNumber, selectedSignature[0]),
                          style: TextStyle(
                            fontSize: 30,
                            color: globals.color('text'),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]
      )
    );
  }
}

String scaleAnswer(int numberOfSignature, bool signature){
  if(signature){
    switch(numberOfSignature) {
      case 0:
        return "C Major\n" + (messages!['alternative'] as String) + "A Minor";
      case 1:
        return "G Major\n" + (messages!['alternative'] as String) + "E Minor";
      case 2:
        return "D Major\n" + (messages!['alternative'] as String) + "B Minor";
      case 3:
        return "A Major\n" + (messages!['alternative'] as String) + "F# Minor";
      case 4:
        return "E Major\n" + (messages!['alternative'] as String) + "C# Minor";
      case 5:
        return "B Major\n" + (messages!['alternative'] as String) + "G# Minor";
      case 6:
        return "F# Major\n" + (messages!['alternative'] as String) + "D# Minor";
      case 7:
        return "C# Major\n" + (messages!['alternative'] as String) + "A# Minor";
    }
    return("");
  } else {
    switch (numberOfSignature) {
      case 0:
        return "C Major\n" + (messages!['alternative'] as String) + "A Minor";
      case 1:
        return "F Major\n" + (messages!['alternative'] as String) + "D Minor";
      case 2:
        return "Bb Major\n" + (messages!['alternative'] as String) + "G Minor";
      case 3:
        return "Eb Major\n" + (messages!['alternative'] as String) + "C Minor";
      case 4:
        return "Ab Major\n" + (messages!['alternative'] as String) + "F Minor";
      case 5:
        return "Db Major\n" + (messages!['alternative'] as String) + "Bb Minor";
      case 6:
        return "Gb Major\n" + (messages!['alternative'] as String) + "Eb Minor";
      case 7:
        return "Cb Major\n" + (messages!['alternative'] as String) + "Ab Minor";
    }
    return ("");
  }
}