import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:yumzapp/screens/search_results.dart';
import '../constants.dart';
import '../filter_card.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import '../widgets.dart';
import '../bottom_button.dart';
import 'dart:math';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:yumzapp/screens/profile.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yumzapp/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SearchScreen extends StatefulWidget {
  static const String route = 'search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  //to store values to filters
  String keywords;
  int difficulty;
  int duration = 70;

  //lists to store information
  List<IngredientTag> ingredientTagsList = [];
  List<String> ingredientTagsNameList = [];
  List<IngredientMeasurement> ingredientMeasurementList = [];
  List<String> ingredientMeasurementNameList = [];


  //text editing controllers for text fields
  TextEditingController _keywordController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  TextEditingController _ingredientMeasurementController = TextEditingController();
  TextEditingController _stepsController = TextEditingController();

  //store information for recipe
  String newTag;


  //getting the hour and min from duration that is stored as total minutes
  int getHour(int duration) {
    return duration ~/ 60;
  }

  int getMin(int duration) {
    return duration % 60;
  }

  void deleteTag(String input) {
    ingredientTagsList.removeWhere((IngredientTag tag) {
      return input == tag.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHeading,
      body: Padding(
        padding: EdgeInsets.only(top: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: kIconOrButtonColor,
                      size: 34,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right:  20.0,),
              child: Text(
                'Search recipe',
                style: kPageHeadingInverse,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right:  20.0,),
              child: TextField(
                controller: _keywordController,
                decoration: InputDecoration(
                  hintText: 'keyword here...',
                  hintStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                  ),
                  hoverColor: kHeading,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: FilterCard(
                colour: kBackgroundColor,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Difficulty',
                      style: kAddHeading,
                    ),
                    RatingBar(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        difficulty = rating.toInt();
                      },
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FilterCard(
                colour: kBackgroundColor,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Duration',
                      style: kAddHeading,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          getHour(duration).toString(),
                        ),
                        Text(
                          'hr',
                        ),
                        Text(
                          getMin(duration).toString(),
                        ),
                        Text(
                          'min',
                        ),
                      ],
                    ),
                    Slider(
                      value: duration.toDouble(),
                      onChanged: (double newValue) {
                        setState(() {
                          duration = newValue.round();
                        });
                      },
                      min: 0.0,
                      max: 120.0,
                      activeColor: kHeading,
                      inactiveColor: kAppBarColor,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: FilterCard(
                colour: kBackgroundColor,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Tags',
                      style: kAddHeading,
                    ),
                    Wrap(
                      direction: Axis.horizontal,
                      children: ingredientTagsList,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _tagController,
                            autofocus: true,
                            textAlign: TextAlign.center,
                            onChanged: (newInput){
                              newTag = newInput;
                            },
                          ),
                        ),
                        FlatButton(onPressed: (){
                          setState(() {
                            if(_tagController.text.isNotEmpty) {
                              ingredientTagsNameList.add(newTag);
                              ingredientTagsList.add(IngredientTag(newTag));
                              _tagController.clear();
                            }
                          });
                        }, child: Text('add'), color: kHeading)
                      ],),
                  ],
                ),
              ),
            ),
            BottomButton(
              text: 'Search',
              onTap:() {
                print(_keywordController.text);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new SearchResults(keyword: _keywordController.text, difficulty: difficulty, duration: duration)),
                ).then((value) {
                  setState(() {});
                });                /* CalculatorBrain calc = CalculatorBrain(height: height, weight: weight);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResultsPage(
                              bmiResults: calc.calculateBMI(),
                              resultText: calc.getResult(),
                              interpretation: calc.getInterpretation(),
                            ))); */
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TagsList extends StatefulWidget {
  @override
  State createState() => TagsState();
}

class TagsListState extends State<TagsList> {
  final List<String> _tags = <String>[];

  Iterable<Widget> get tagsWidgets sync* {
    for (final String tag in _tags) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
          backgroundColor: kHeading,
          deleteIcon: Icon(CupertinoIcons.clear_thick_circled),
          label: Text(tag),
          onDeleted: () {
            setState(() {
              _tags.remove(tag);
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: tagsWidgets.toList(),
    );
  }
}

class IngredientTag extends StatelessWidget {
  IngredientTag(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: kHeading,
      label: Text(name),
      deleteIcon: Icon(CupertinoIcons.clear_thick_circled),
      onDeleted: (){
        //_SearchScreenState.deleteTag(name);
      },
    );
  }
}