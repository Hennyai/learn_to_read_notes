import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:note_anki/globals.dart' as globals;

final Map<String, Map<String, String>> docMessages = {
  'en': {
    'title' : 'Number of notes each time: ',
    'select' : 'Change'
  },
  'vi': {
    'title' : 'Số lượng nốt mỗi lần tập: ',
    'select' : 'Thay đổi'
  },
};

Map<String, String>? messages = docMessages[globals.language];

class NumberPicker extends StatefulWidget {
  @override
  _NumberPickerState createState() => _NumberPickerState();
}

class _NumberPickerState extends State<NumberPicker> {
  int _selectedNumber = globals.numberOfNotes;

  void _showNumberPicker() {
    Picker(
      adapter: NumberPickerAdapter(data: [
        NumberPickerColumn(begin: 0, end: 9),
        NumberPickerColumn(begin: 0, end: 9),
      ]),
      selecteds: [globals.numberOfNotes ~/ 10, globals.numberOfNotes % 10],
      hideHeader: true,
      title: Text('Select a Number'),
      onConfirm: (picker, List<int> value) {
        globals.settingsChanged = true;
        if(int.parse(value.join())>0) globals.numberOfNotes = int.parse(value.join());
          else globals.numberOfNotes=1;
        setState(() {
          _selectedNumber = int.parse(value.join());
        });
      },
    ).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    messages = docMessages[globals.language];

    return Padding(
      padding: const EdgeInsets.all(11.0),
      child: Card(
        color: globals.color('card'),
        child: Container(
          decoration: BoxDecoration(
            color: globals.color('card'),
            borderRadius: BorderRadius.circular(8),
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
            child: Row(
              children: [
                Expanded(child: Text(
                    (messages!['title'] as String)+_selectedNumber.toString(),
                    style: TextStyle(
                      color: globals.color('text'),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(globals.color('button') as Color),
                    foregroundColor: MaterialStateProperty.all<Color>(globals.color('button text') as Color),
                  ),
                  onPressed: _showNumberPicker,
                  child: Text(messages!['select'] as String),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
