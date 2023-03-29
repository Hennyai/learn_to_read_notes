import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  bool built = false;
  
  void getData() async{
    Future.delayed(const Duration(seconds: 5), () {
       Navigator.pushReplacementNamed(context, '/home');
    });
  }
  
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: EdgeInsets.all(50),
        child: SpinKitPianoWave(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}