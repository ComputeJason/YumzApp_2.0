import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yumzapp/constants.dart';
import 'package:yumzapp/screens/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditProfile extends StatefulWidget {
  static const String route = 'editProfile';
  final FirebaseUser user;
  final String url;

  //pass in the User from the ProfilePage
  EditProfile({this.user,this.url});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _store = Firestore.instance; //instantiate fireStore
  String route = 'editProfile'; //pushNamed route

  bool spin = false; //ModalSpinner while waiting

  String bio = '';
  bool bioChanged = false; //check if bio field was touched
  String username = '';
  bool usernameChanged = false; //check if username field was touched

  bool imageChanged = false; //check if the image was changed
  bool imageUploaded = false; //check if the image was uploaded to fireStore
  File _finalImage;
  final _picker = ImagePicker();

  //function to pick image from gallery
  Future _getImage() async{
    PickedFile pickedImage = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _finalImage = File(pickedImage.path);
      imageChanged = true;
      print('image changed to:  $_finalImage}');
    });
  }

  //function to upload image into firebase Storage
  Future _uploadImage() async {
    StorageReference reference = FirebaseStorage.instance.ref().child('${widget.user.email}.jpg');
    StorageUploadTask uploadTask = reference.putFile(_finalImage);
    print('uploading');
  }

  //function to push the page to Profile page
  void pushToProfile(){
    Navigator.pushNamed(context, Profile.route);
  }


  //main BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spin,
      child: Scaffold(
        backgroundColor: kBackgroundColor,

        //mainly the back button
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Profile.route);
              }),
          title: Text(
            'Settings',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Playball',
            ),
          ),
        ),

        //body for TextFields , Display pic & Buttons
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),

              //DISPLAY PIC
              CircleAvatar(
                radius: 60,
                backgroundImage: (_finalImage != null) ? FileImage(_finalImage): NetworkImage( widget.url == null ? 'https://st2.depositphotos.com/6759912/11383/i/950/depositphotos_113833926-stock-photo-sandwich-burger-on-white-background.jpg' : widget.url),
              ),

              //CHANGE PROFILE PIC BUTTON --> opens gallery
              FlatButton(
                color: kIconOrButtonColor,
                onPressed: _getImage,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text('+Change Profile Picture',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),),
              ),

              //USERNAME TITLE
              Padding(
                padding: const EdgeInsets.only(top: 25,),
                child: Text(
                  'Change Username',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              //TEXT FIELD TO CHANGE USERNAME
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'new username',
                    focusColor: kIconOrButtonColor,
                  ),
                  onChanged: (value) {
                    username = value;
                    if(username.length > 0){
                      usernameChanged = true;
                    }
                  },
                ),
              ),

              //BIO TITLE
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Change Bio',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              //TEXT FIELD TO CHANGE BIO
              Container(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  decoration:
                  InputDecoration(hintText: "I like cooking because....."),
                  onChanged: (value) {
                    bio = value;
                    if(bio.length > 0){
                      bioChanged = true;
                    }
                  },
                ),
              ),

              //SAVE BUTTON!!! --> LOGIC FOR ALL THE FIRESTORE UPDATING
              Container(
                padding: EdgeInsets.only(top: 30),
                child: RaisedButton(
                  color: kRandomBlockGrey,
                  onPressed: () {
                    //if nvr touch any textfields --> pop back to profile
                    if (!bioChanged && !usernameChanged && !imageChanged) {
                      Navigator.pop(context);

                      //if the textfields were changed --> show dialog pop-up to confirm
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoAlertDialog(
                            title: Text('Do you want to save these changes?'),
                            actions: <Widget>[

                              //YES button --> save into firebase
                              CupertinoDialogAction(
                                child: FlatButton(
                                  child: Text('Yes'),
                                  //if YES ,save changes into fireStore and go back to profile page
                                  onPressed: () async {

                                    //IF IMAGE CHANGED
                                    if(imageChanged){
                                      print('initiate image uploading');
                                      await _uploadImage();
                                      imageUploaded = true;
                                      print('image upload success');
                                    }
                                    //if ONLY BIO TEXTFIELD CHANGED
                                    if (bioChanged && !usernameChanged) {
                                      _store
                                          .collection('users')
                                          .document(widget.user.email)
                                          .updateData({
                                        'bio': bio,
                                      });
                                      //if ONLY USERNAME TEXTFIELD CHANGED
                                    } else if (!bioChanged && usernameChanged) {
                                      _store
                                          .collection('users')
                                          .document(widget.user.email)
                                          .updateData({
                                        'username': username,
                                      });

                                      //if BOTH TEXTFIELDS CHANGE
                                    } else if (bioChanged && usernameChanged) {
                                      _store
                                          .collection('users')
                                          .document(widget.user.email)
                                          .updateData({
                                        'username': username,
                                        'bio': bio,
                                      });
                                    }

                                    //AFTER DONE SAVING POP THE DIALOG
                                    Navigator.pop(context);

                                    //MAKE SPINNER SPIN FOR 2 SECONDS WHILE FIREBASE UPLOADS
                                    setState(() {
                                      spin = true;
                                    });
                                    await Future.delayed(const Duration(seconds:2));
                                    print('delaying 3 seconds');
                                    setState(() {
                                      spin = false;
                                    });

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
                    }
                  },
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}