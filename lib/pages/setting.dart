import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:info_popup/info_popup.dart';
import 'package:note_anki/globals.dart' as globals;

import 'package:note_anki/models/choose_card.dart';
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
    'random weight' : "Random music sheet's weight",
    'random weight explain' : "The weight slider allows you to adjust the balance between generating challenging, completely random music sheets and generating music sheets that target areas where you need to improve.",
    'included clef' : 'Included Clefs:',
    'included scale' : 'Included (Major) Scales:',
    'set to default' : 'Set to default',
    'clear' : 'Clear',
    'choose all' : 'Choose all',
    'volume' : 'Volume:'
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
    'random weight' : 'Trọng số random khung nhạc',
    'random weight explain' : "Thanh trượt trọng số cho phép bạn điều chỉnh cân bằng giữa việc tạo ra các sheet nhạc ngẫu nhiên và các sheet nhạc hướng đến những chỗ mà bạn cần cải thiện.",
    'included clef' : 'Bao gồm các khóa:',
    'included scale' : 'Bao gồm các âm giai(trưởng):',
    'set to default' : 'Đặt về mặc định',
    'clear' : 'Bỏ chọn',
    'choose all' : 'Chọn tất cả',
    'volume' : 'Âm lượng:'
  },
};

//Message theo ngôn ngữ hiện tại
Map<String, String>? messages = docMessages[globals.language];

List<Widget> scaleList= <Widget>[
  Text('C'),
  Text('G'),
  Text('D'),
  Text('A'),
  Text('E'),
  Text('B'),
  Text('F#'),
  Text('C#'),
  Text('F'),
  Text('Bb'),
  Text('Eb'),
  Text('Ab'),
  Text('Db'),
  Text('Gb'),
  Text('Cb'),
];

final scaleScrollController = ScrollController();


class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  void switchNoteNames(){
    setState(() {globals.hideNoteNames=!globals.hideNoteNames;});
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
    setState(() {globals.advancedSettings=!globals.advancedSettings;});
  }
  void setToDefault(){
    setState(() {
      globals.settingsChanged=true;
      globals.numberOfNotes=3;
      globals.randomSheetWeight=51;
      globals.selectedClef[0]=true;
      globals.selectedClef[1]=true;
      globals.selectedScale.fillRange(0, globals.selectedScale.length-1,true);
    });
  }

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
    IconData themeIcon;
    IconData noteNamesIcon;
    String noteNamesTitle;
    String noteNamesExplain;
    String clearOrChooseString;

    int scaleCount = globals.selectedScale.where((element) => element).toList().length;
    if(scaleCount>scaleList.length/2) clearOrChooseString=messages!['clear'] as String;
      else clearOrChooseString=messages!['choose all'] as String;

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

    void clearOrChoose(){
      setState(() {
        globals.settingsChanged=true;
        if(scaleCount>6) globals.selectedScale.fillRange(0, globals.selectedScale.length, false);
          else globals.selectedScale.fillRange(0, globals.selectedScale.length, true);
      });
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
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                                    child: Text(
                                      messages!["volume"] as String,
                                      style: TextStyle(
                                          color: globals.color("text")
                                      ),
                                    ),
                                  ),
                                  SfSlider(
                                    min: 0.0,
                                    max: 100.0,
                                    value: globals.volume*100,
                                    interval: 20,
                                    showTicks: true,
                                    showLabels: false,
                                    enableTooltip: true,
                                    minorTicksPerInterval: 1,
                                    activeColor: globals.color('button') as Color,
                                    inactiveColor: globals.color('inactive slider') as Color,
                                    onChanged: (dynamic value){
                                      globals.settingsChanged=true;
                                      setState(() {
                                        globals.volume = value.ceil()/100;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height:8),
                      ElevatedButton(
                        style: ButtonStyle(
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                                (Set<MaterialState> states) {
                              return BorderSide(
                                color: globals.color('button') as Color,
                                width: 3.0,
                              );
                            },
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              globals.color('button text') as Color),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(globals.color('button') as Color),
                          elevation: MaterialStateProperty.all<double>(3.0),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: setToDefault,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(messages!['set to default'] as String),
                        ),
                      ),
                      SizedBox(height: 5,),
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
                                    padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            messages!["random weight"] as String,
                                            style: TextStyle(
                                              color: globals.color("text")
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InfoPopupWidget(
                                                contentTitle: messages!['random weight explain'] as String,
                                                arrowTheme: InfoPopupArrowTheme(
                                                  color: globals.color('button') as Color,
                                                  arrowDirection: ArrowDirection.up,
                                                ),
                                                contentTheme: InfoPopupContentTheme(
                                                  infoContainerBackgroundColor: globals.color('card') as Color,
                                                  infoTextStyle: TextStyle(color: globals.color('text') as Color),
                                                  contentPadding: const EdgeInsets.all(8),
                                                  contentBorderRadius: BorderRadius.all(Radius.circular(10)),
                                                  infoTextAlign: TextAlign.center,
                                                ),
                                                dismissTriggerBehavior: PopupDismissTriggerBehavior.onTapArea,
                                                areaBackgroundColor: Colors.transparent,
                                                indicatorOffset: Offset.zero,
                                                contentOffset: Offset.zero,
                                                child: Icon(
                                                  Icons.info,
                                                  color: globals.color('button') as Color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SfSlider(
                                    min: 0.0,
                                    max: 500.0,
                                    value: globals.randomSheetWeight.toDouble()-1,
                                    interval: 50,
                                    showTicks: true,
                                    showLabels: false,
                                    enableTooltip: true,
                                    minorTicksPerInterval: 1,
                                    activeColor: globals.color('button') as Color,
                                    inactiveColor: globals.color('inactive slider') as Color,
                                    onChanged: (dynamic value){
                                      globals.settingsChanged=true;
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
                      //Included clef
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
                                      messages!['included clef'] as String,
                                    style: TextStyle(
                                      color: globals.color('text'),
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Padding(
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
                                              backgroundColor: MaterialStateProperty.all<Color>(toggleBackgroundColor(globals.selectedClef[0])),
                                            ),
                                            onPressed: (){
                                              globals.settingsChanged=true;
                                              setState(() {
                                                if(globals.selectedClef[1]) globals.selectedClef[0]=!globals.selectedClef[0];
                                                  else {
                                                    globals.selectedClef[0]=!globals.selectedClef[0];
                                                    globals.selectedClef[1]=!globals.selectedClef[1];
                                                  }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child:Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ColorFiltered(
                                                    colorFilter: ColorFilter.mode(
                                                      toggleForegroundColor(globals.selectedClef[0]),
                                                        BlendMode.srcIn
                                                    ),
                                                    child: Image.asset(
                                                      'assets/icons/treble-clef.png',
                                                      height: 50,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        child: Padding(
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
                                              backgroundColor: MaterialStateProperty.all<Color>(toggleBackgroundColor(globals.selectedClef[1])),
                                            ),
                                            onPressed: () {
                                              globals.settingsChanged=true;
                                              setState(() {
                                                if(globals.selectedClef[0]) globals.selectedClef[1]=!globals.selectedClef[1];
                                                else {
                                                  globals.selectedClef[0]=!globals.selectedClef[0];
                                                  globals.selectedClef[1]=!globals.selectedClef[1];
                                                }
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(8, 13, 8, 13),
                                                  child: ColorFiltered(
                                                    colorFilter: ColorFilter.mode(
                                                        toggleForegroundColor(globals.selectedClef[1]),
                                                        BlendMode.srcIn
                                                    ),
                                                    child: Image.asset(
                                                      'assets/icons/bass-clef.png',
                                                      height: 40,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
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
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                        child: Text(
                                          messages!['included scale'] as String,
                                          style: TextStyle(
                                            color: globals.color('text'),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(globals.color('button') as Color),
                                            foregroundColor: MaterialStateProperty.all<Color>(globals.color('button text') as Color),
                                          ),
                                          onPressed: clearOrChoose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              clearOrChooseString
                                            ),
                                          ),
                                        )
                                      ),
                                    ]
                                  ),
                                ),
                                Center(
                                  child: Scrollbar(
                                    thumbVisibility: true,
                                    controller: scaleScrollController,
                                    child: Stack(
                                      children: [
                                          Center(
                                            child: SingleChildScrollView(
                                            controller: scaleScrollController,
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: ToggleButtons(
                                                    onPressed: (int index) {
                                                      globals.settingsChanged=true;
                                                      // All buttons are selectable.
                                                      setState(() {
                                                        globals.selectedScale[index] = !globals.selectedScale[index];
                                                      });
                                                    },
                                                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                                                    selectedBorderColor: globals.color('toggle border'),
                                                    selectedColor: globals.color('button text'),
                                                    fillColor: globals.color('button'),
                                                    color: globals.color('button'),
                                                    borderWidth: 2,
                                                    constraints: const BoxConstraints(
                                                      minHeight: 40.0,
                                                      minWidth: 80.0,
                                                    ),
                                                    isSelected: globals.selectedScale,
                                                    children: scaleList,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ),
                                          ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 10,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: globals.color('card'),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
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
                      SizedBox(height: 20),
                      SizedBox(height: 50),
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
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                                    child: Text(
                                      messages!["volume"] as String,
                                      style: TextStyle(
                                          color: globals.color("text")
                                      ),
                                    ),
                                  ),
                                  SfSlider(
                                    min: 0.0,
                                    max: 100.0,
                                    value: globals.volume*100,
                                    interval: 20,
                                    showTicks: true,
                                    showLabels: false,
                                    enableTooltip: true,
                                    minorTicksPerInterval: 1,
                                    activeColor: globals.color('button') as Color,
                                    inactiveColor: globals.color('inactive slider') as Color,
                                    onChanged: (dynamic value){
                                      globals.settingsChanged=true;
                                      setState(() {
                                        globals.volume = value.ceil()/100;
                                      });
                                    },
                                  ),
                                ],
                              ),
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
