import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';






class IngredientMeasurement extends StatelessWidget {
  IngredientMeasurement(this.string);

  final String string;

  @override
  Widget build(BuildContext context) {
    String input = string;
    return Chip(
      backgroundColor: kHeading,
      label: Text(input),
      deleteIcon: Icon(CupertinoIcons.clear_thick_circled),
      onDeleted: (){}, //TODO: deleting tags
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Icon(icon, color: kBackgroundColor),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 25.0,
        height: 25.0,
      ),
      shape: CircleBorder(),
      fillColor: kIconOrButtonColor,
    );
  }
}