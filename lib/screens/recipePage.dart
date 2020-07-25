import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yumzapp/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


final _store = Firestore.instance; //FireStore instance
final _auth = FirebaseAuth.instance; //Fire_Auth instance

// ignore: must_be_immutable
class RecipePage extends StatefulWidget {
  String recipeRef;

  RecipePage({Key key, @required this.recipeRef}) : super(key: key);

  @override
  _RecipePageState createState() => _RecipePageState(this.recipeRef);
}

class _RecipePageState extends State<RecipePage> {
  bool _progressController = true;

  String recipeRef;
  //store information for recipe
  String name;
  String description = 'loading...';
  List tags;
  List ingredients;
  List steps;
  double difficulty;
  int hour;
  int minute;
  bool imageAdded;
  String downloadRecipePicUrl;
  bool retrievedPic = false;//Network image for Display Pic
  bool retrievedInfo = false;

  _RecipePageState(this.recipeRef);

  @override
  void initState() {
    super.initState();
    this.recipeRef = widget.recipeRef;
    getRecipe();
    downloadRecipePic();
  }

  void getRecipe() async {
    //retrieve recipe info from firestore Database based on recipeRef
    DocumentReference result = _store.collection('recipes').document(recipeRef);
    await result.get().then((recipeSnapshot) {
      print('yes');
      //store information for recipe
      name = recipeSnapshot.data['name'].toString();
      description = recipeSnapshot.data['description'].toString();
      tags = recipeSnapshot.data['tags'];
      ingredients = recipeSnapshot.data['ingredients'];
      steps = recipeSnapshot.data['steps'];
      difficulty = recipeSnapshot.data['difficulty'];
      hour = recipeSnapshot.data['duration/hour'];
      minute = recipeSnapshot.data['duration/minute'];
      imageAdded = recipeSnapshot.data['image'];
    });
    setState(() {
      retrievedInfo = true;
      if (retrievedPic) {
        setState(() {
          _progressController = false;
        }); }
    });

  }

  void downloadRecipePic() async {
    //if user stored their own display pic, display that pic
    try {
      StorageReference reference =
      FirebaseStorage.instance.ref().child('$recipeRef.jpg');
      String downloadAddress = await reference.getDownloadURL();
      setState(() {
        downloadRecipePicUrl = downloadAddress;
      });

      //else if that pic doesnt exist, display the default pic
    } catch (e) {
      print(e);
      setState(() {
        downloadRecipePicUrl =
        'https://images.app.goo.gl/Xy7wgtnb99G6W6Zi7';
      });
    }
    setState(() {
      retrievedPic = true;
      if (retrievedInfo) {
        setState(() {
          _progressController = false;
        }); }
    });
    print('Fetched profile pic');
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kIconOrButtonColor,
            size: 34,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Recipe',
          style: TextStyle(
            fontFamily: 'Playball',
            fontSize: 30,
          ),
        ),
      ),
      body: _progressController
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Image.network(
                        downloadRecipePicUrl),
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                      offset: Offset(2, 2),
                                      color: Colors.white,
                                      blurRadius: 3)
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSizedBox,
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Difficulty',
                          style: kAddHeading,
                        ),
                        RatingBar(
                          initialRating: difficulty,
                          minRating: 1,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                  kSizedBox,
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                    child: Text(
                      'Duration',
                      style: kAddHeading,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      hour.toString() + ' hr ' + minute.toString() + ' min ',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  kSizedBox,
                  Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0,),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Ingredients',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: createIngredients(ingredients)),
                            ],
                          ))),
                  kSizedBox,
                  Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0,),
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white,
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Steps',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: createSteps(steps)),
                            ],
                          )))
                ],
              ),
            ),
    );
  }

  createIngredients(List ingredients) {
    var ingredientLine = <Column>[];

    ingredients.forEach((i) {
      return ingredientLine.add(Column(
        children: <Widget>[
          Text(
            i,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 1,
          ),
        ],
      ));
    });
    return ingredientLine;
  }

  createSteps(List steps) {
    var stepLine = <Column>[];

    steps.forEach((i) {
      return stepLine.add(Column(
        children: <Widget>[
          Text(
            i,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 1,
          ),
        ],
      ));
    });
    return stepLine;
  }
}
