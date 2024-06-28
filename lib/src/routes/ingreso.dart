import 'package:flutter/material.dart';

class IngresoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
        PreferredSize(
        preferredSize: Size.fromHeight(100.0), // here the desired height
    child: AppBar(
    automaticallyImplyLeading: false,
        backgroundColor: Color(0XFF17A48B),
        title:Row(

            mainAxisAlignment: MainAxisAlignment.center,
          children: [

        Text('UTC', style: TextStyle(
          fontFamily: 'Hanuman',
          fontSize: 30,
          fontWeight: FontWeight.w300,
          color: Color(0xFFFFFFFF),
          )),
          ],),)),
      body:
      Text('xd'),

    );
  }
}