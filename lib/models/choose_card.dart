import 'package:learn_to_read_notes/globals.dart' as globals;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String explain;
  final String iconColor;
  ChooseCard(this.icon, this.title, this.explain, this.iconColor);

  @override
  State<ChooseCard> createState() => _ChooseCardState();
}

class _ChooseCardState extends State<ChooseCard> {
  String cardColor = 'card';
  double margins = 16;

  void notHover(){
    cardColor = 'card';
    margins = 16;
  }

  void onHover(){
    cardColor = 'card hover';
    margins = 15;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => onHover()),
      onExit: (_) => setState(() => notHover()),
      child: Card(
        color: globals.color(cardColor),
        margin: EdgeInsets.fromLTRB(margins, margins, margins, 0),
        child: Container(
          decoration: BoxDecoration(
            color: globals.color(cardColor),
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
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    widget.icon,
                    color: globals.color(widget.iconColor),
                    size: 60,
                  ),
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 10),
                      Text(
                        widget.title,
                        style: TextStyle(
                            fontSize: 24,
                            color: globals.color('text')
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.explain,
                        style: TextStyle(
                          fontSize: 15,
                          color: globals.color('light text'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
