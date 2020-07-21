import 'package:flutter/material.dart';
import 'constants.dart';
class BottomButton extends StatelessWidget {

  BottomButton({this.text, this.onTap});

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            text,
            style: kPageHeading,
          ),
        ),
        color: kBackgroundColor,
        padding: EdgeInsets.only(bottom: 20.0),
        margin: EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 100.0,
      ),
    );
  }
}