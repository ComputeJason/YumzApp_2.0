import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../constants.dart';
import 'package:flutter/widgets.dart';
import 'dart:core';
import '../widgets.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yumzapp/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumzapp/recipe.dart';
import 'recipePage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final _store = Firestore.instance; //FireStore instance
final _auth = FirebaseAuth.instance; //Fire_Auth instance

class SearchResults extends StatefulWidget {
  static const String route = 'results';

  SearchResults({Key key, this.keyword, this.difficulty, this.duration}) : super(key: key);


  String keyword;
  int difficulty;
  int duration;

  @override
  _SearchResultsState createState() => _SearchResultsState(this.keyword, this.difficulty, this.duration);
}

class _SearchResultsState extends State<SearchResults> {

  _SearchResultsState(this.keyword, this.difficulty, this.duration);

  //to store values to filters
  String keyword;
  int difficulty;
  int duration;
  FirebaseUser loggedInUser;

  List recipeArray;
  String recipeName;
  String recipeDescription;
  String recipeRef;
  int recipeDiff;
  int recipeDur;
  double recipeDurHr;
  double recipeDurMin;
  List<Recipe> recipes = [];
  List<Recipe> recipesAll = [];
  List<Recipe> recipesName = [];
  List<Recipe> recipesDifficulty = [];
  List<Recipe> recipesDuration = [];


  bool _progressController = true;

  @override
  void initState() {
    super.initState();
    this.keyword = widget.keyword;
    this.difficulty = widget.difficulty;
    this.duration = widget.duration;
    getRecipeList();
  }

  //getting the hour and min from duration that is stored as total minutes
  int getHour(int duration) {
    return duration ~/ 60;
  }

  int getMin(int duration) {
    return duration % 60;
  }

  void getRecipeList() async {

    var recipesDoc = await _store
        .collection('recipes')
        .getDocuments();

    var recipesDoc3 = await _store
        .collection('recipes')
        .where('duration', isEqualTo: duration)
        .getDocuments();

    recipesDoc.documents.forEach((res) {
      if (res['name'] != null ) {
        final recipeName = res['name'];
        final recipeDescription = res['description'];
        final recipeDiff = res['difficulty'];
        print(recipeDiff);
        final recipeDurHr = res['duration/hour'] == null ? 0 : res['duration/hour'];
        print(recipeDurHr);
        final recipeDurMin = res['duration/minute'];
        print(recipeDurMin);
        final recipeRef = res.documentID;
        final addRecipe = Recipe(recipeDescription: recipeDescription, recipeName: recipeName, recipeRef: recipeRef, recipeDiff: recipeDiff, recipeDurHr: recipeDurHr, recipeDurMin: recipeDurMin);
        recipes.add(addRecipe);
        setState(() {
          _progressController = false;
        });
      }
    });

    recipesName = recipes.where((p) => p.recipeName.startsWith(keyword)).toList();
    recipesAll = recipesName.where((p) => p.recipeDiff == difficulty && p.recipeDur == duration).toList();
    recipesDifficulty = recipes.where((p) => p.recipeDiff == difficulty).toList();
    recipesDuration = recipes.where((p) => p.getDuration() == duration).toList();


    setState(() {
      _progressController = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kHeading,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
            Padding(
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
                      'Search results',
                      style: kPageHeadingInverse,
                    ),
                  ),
                  kSizedBox,
                  Container(child:  _progressController
                      ? Center(child: CircularProgressIndicator())
                      : _buildContent(recipesAll, recipesName,recipesDifficulty,recipesDuration)),
                ],
              ),
            ),
          ],),
        ),
      ),
    );
  }
  //listview builder
  Widget _buildContent(all, name, diff, dur) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(padding: EdgeInsets.only(left: 5.0),child: Text('All Match', style: kAddHeading,)),
            kSmallGap,
            all.length == 0 ? Container(padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 8.0,),child: Text('no results', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
            : ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Recipe recipe = all[index];
                return Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RecipePage(recipeRef: recipe.recipeRef)),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color(0xFFD9C38A),
                            child: RecipeListTile(recipe),
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
              itemCount: name.length,
            ),
            kSizedBox,
            Container(padding: EdgeInsets.only(left: 5.0),child:Text('By Name', style: kAddHeading,)),
            kSmallGap,
            name.length == 0 ? Container(padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 8.0,),child: Text('no results', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                :ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
               Recipe recipe = name[index];
              return Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RecipePage(recipeRef: recipe.recipeRef)),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Color(0xFFD9C38A),
                          child: RecipeListTile(recipe),
                        ),
                        Divider(
                          height: 2,
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
            itemCount: name.length,
          ),
            kSizedBox,
            Container(padding: EdgeInsets.only(left: 5.0),child:Text('By Difficulty', style: kAddHeading,)),
            kSmallGap,
            diff.length == 0 ? Container(padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 8.0,),child: Text('no results', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                :ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Recipe recipe = diff[index];
                return Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RecipePage(recipeRef: recipe.recipeRef)),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color(0xFFD9C38A),
                            child: RecipeListTile(recipe),
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
              itemCount: diff.length,
            ),
            kSizedBox,
            Container(padding: EdgeInsets.only(left: 5.0), child:Text('By Duration', style: kAddHeading,)),
            kSmallGap,
            dur.length == 0 ? Container(padding: EdgeInsets.only(left: 15.0, top: 8.0, bottom: 8.0,),child: Text('no results', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),))
                :ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                Recipe recipe = dur[index];
                return Column(
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RecipePage(recipeRef: recipe.recipeRef)),
                        ).then((value) {
                          setState(() {});
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            color: Color(0xFFD9C38A),
                            child: RecipeListTile(recipe),
                          ),
                          Divider(
                            height: 2,
                            thickness: 1,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              },
              itemCount: dur.length,
            ),

        ],),
      );
    }
  }


//listtile content
class RecipeListTile extends ListTile {
  RecipeListTile(Recipe recipe)
      : super(
    title: Text(
      recipe.recipeName,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    ),
    subtitle: Text(recipe.recipeDescription),
    leading: Icon(Icons.fastfood),
  );
}

