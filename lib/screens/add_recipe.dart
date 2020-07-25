import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:yumzapp/constants.dart';
import 'package:yumzapp/screens/profile.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:yumzapp/recipe.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';




final _store = Firestore.instance; //FireStore instance
final _auth = FirebaseAuth.instance; //Fire_Auth instance

class AddRecipe extends StatefulWidget {
  static const String route = 'addRecipe';
  final FirebaseUser user;
  final String url;


  //pass in the User from the ProfilePage
  AddRecipe({this.user,this.url});

  @override
  _AddRecipeState createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {

  FirebaseUser loggedInUser;

  Widget buildBottomSheet(BuildContext context) {
    return Container(child: Center(child: Text('hello')));
  }

  bool spin = false; //ModalSpinner while waiting

  //lists to store information
  List<IngredientTag> ingredientTagsList = [];
  List<String> ingredientTagsNameList = [];
  List<IngredientMeasurement> ingredientMeasurementList = [];
  List<String> ingredientMeasurementNameList = [];
  List<Step> stepsList = [];
  List<String> stepsStringList = [];

  //text editing controllers for text fields
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _hourController = TextEditingController();
  TextEditingController _minuteController = TextEditingController();
  TextEditingController _tagController = TextEditingController();
  TextEditingController _ingredientMeasurementController = TextEditingController();
  TextEditingController _stepsController = TextEditingController();

  //store information for recipe
  String name;
  String description;
  String newTag;
  String newIngredient;
  String newUnit;
  String newName;
  String newStep;
  String recipeID;
  double difficulty;
  int hour;
  int minute;

  //for uploading image
  final _picker = ImagePicker();
  bool imageAdded = false;
  bool imageUploaded = false; //check if the image was uploaded to fireStore
  File _finalImage;

  //function to pick image from gallery
  Future _getImage() async{
    PickedFile pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _finalImage = File(pickedImage.path);
      setState(() {
        imageAdded = true;
      });
      print('image changed to:  $_finalImage}');
    });
  }

  //function to upload image into firebase Storage
  Future _uploadImage() async {
    StorageReference reference = FirebaseStorage.instance.ref().child('${recipeID}.jpg');
    StorageUploadTask uploadTask = reference.putFile(_finalImage);
    print('uploading');
  }

  //function to push the page to Profile page
  void pushToProfile(){
    Navigator.pushNamed(context, Profile.route);
  }

  //function to upload recipe on to fire store
  Future uploadRecipe() async {
    final user = await _auth.currentUser();
    loggedInUser = user;
    String email = loggedInUser.email;

    final docRef = await Firestore.instance.collection('recipes').add({
      'name': name,
      'description': _descriptionController.text,
      'difficulty': difficulty,
      'duration/hour': int.tryParse(_hourController.text),
      'duration/minute' : int.tryParse(_minuteController.text),
      'tags' : ingredientTagsNameList,
      'ingredients': ingredientMeasurementNameList,
      'steps' : stepsStringList,
      'user': user.email,
      'image': imageAdded,
      //'created': DateTime.fromMillisecondsSinceEpoch(created.creationTimeMillis, isUtc: true).toString(),
    });
    recipeID = docRef.documentID; //to be used to reference to the photo
    await Firestore.instance
        .collection('users')
        .document(user.email)
        .updateData({'recipe': FieldValue.arrayUnion([recipeID])});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      kSmallGap,
                      Container(
                        child: Text(
                          'Add Recipe',
                          style: kPageHeading,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
                            child: SizedBox(
                              width: 300.0,
                              child: TextField(
                                onChanged: (newInput){
                                  name = newInput;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'RECIPE NAME',
                                  labelStyle: kAddHeading,
                                  hintText: 'add recipe name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: GestureDetector(
                              onTap: () {_getImage();},
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.camera_alt, color: kHeading, size: 25,),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(imageAdded ? 'image selected' : 'no image selected',
                          style: TextStyle(fontSize: 10.0),),
                        ),
                      ),
                      SizedBox(
                        width: 300.0,
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'DESCRIPTION',
                            labelStyle: kAddHeading,
                            hintText: 'add description',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                kSizedBox,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  width: double.infinity,
                  decoration: kRoundedCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      kSizedBox,
                      Container(child: Text('DIFFICULTY', style: kAddHeading)),
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
                          difficulty = rating;
                        },
                      ),
                      kSizedBox,
                      Container(child: Text('DURATION', style: kAddHeading)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 35.0,
                            child: TextField(
                                controller: _hourController,
                                textAlign: TextAlign.center),
                          ),
                          Container(child: Text(' hr ')),
                          SizedBox(
                            width: 35.0,
                            child: TextField(
                                controller: _minuteController,
                                textAlign: TextAlign.center),
                          ),
                          Container(child: Text(' min ')),
                        ],
                      ),
                      kSizedBox,
                      Container(child: Text('ADD TAGS', style: kAddHeading)),
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
                      kSizedBox,
                      Container(
                          child: Text('ADD INGREDIENTS', style: kAddHeading)),
                      Column(
                        children: ingredientMeasurementList,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: 'amount, unit, ingredient'),
                              controller: _ingredientMeasurementController,
                              autofocus: true,
                              textAlign: TextAlign.center,
                              onChanged: (newInput){
                                newIngredient = newInput;
                              },
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          FlatButton(onPressed: (){
                            setState(() {
                              if(_ingredientMeasurementController.text.isNotEmpty) {
                                ingredientMeasurementNameList.add(
                                    newIngredient);
                                ingredientMeasurementList.add(
                                    IngredientMeasurement(newIngredient));
                                _ingredientMeasurementController.clear();
                              }
                            });
                          }, child: Text('add'), color: kHeading)
                        ],),
                      kSizedBox,
                      Container(child: Text('ADD STEPS', style: kAddHeading)),
                      Column(
                        children: stepsList,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(hintText: 'add steps...'),
                              controller: _stepsController,
                              autofocus: true,
                              textAlign: TextAlign.center,
                              onChanged: (newInput){
                                newStep = newInput;
                              },
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          FlatButton(onPressed: (){
                            setState(() {
                              if(_stepsController.text.isNotEmpty) {
                                stepsStringList.add(newStep);
                                stepsList.add(Step(newStep, stepsList.length));
                                _stepsController.clear();
                              }
                            });
                          }, child: Text('add'), color: kHeading)
                        ],),
                      kSizedBox,
                      //SAVE BUTTON!!! --> LOGIC FOR ALL THE FIRESTORE UPDATING
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: RaisedButton(
                          color: kRandomBlockGrey,
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Text('Publish recipe?'),
                                  actions: <Widget>[

                                    //YES button --> save into firebase
                                    CupertinoDialogAction(
                                      child: FlatButton(
                                        child: Text('Yes'),
                                        //if YES ,save changes into fireStore and go back to profile page
                                        onPressed: () async {
                                          await uploadRecipe();
                                          if(imageAdded) {
                                            print('initiate image uploading');
                                            await _uploadImage();
                                            imageUploaded = true;
                                            print('image upload success');
                                          }
                                          //at the end push back to profile page w changes made
                                          pushToProfile();
                                        },
                                      ),
                                    ),

                                    // NO button, just close the pop-up and let them try again
                                    CupertinoDialogAction(
                                      child: FlatButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text('Publish'),
                        ),
                      ),
                      /*Center(
                      child: FlatButton(
                        onPressed: () {
                          uploadRecipe();
                          pushToProfile();
                        },
                        child: Container(
                          width: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            color: kIconOrButtonColor,
                          ),
                          child: Center(
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: Icon(CupertinoIcons.add),
                                ),
                                Text('Add Recipe'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ), */
                      kSizedBox,
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
      onDeleted: (){}, //TODO: deleting tags
    );
  }
}

class Step extends StatelessWidget {
  Step(this.stepName, this.stepNum);

  final String stepName;
  final int stepNum;

  @override
  Widget build(BuildContext context) {
    String input = (stepNum+1).toString() + '. ' + stepName;
    return Chip(
      backgroundColor: kHeading,
      label: Text(input),
      deleteIcon: Icon(CupertinoIcons.clear_thick_circled),
      onDeleted: (){}, //TODO: deleting tags
    );
  }
}

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