import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yumzapp/constants.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yumzapp/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Login extends StatefulWidget {
  static const String route = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _store = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  String email;
  String password = '';
  bool signIn = true;
  //to remove texts after wrong Sign In
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //validation function + show error if got smth wrong
  void checkLogin() async {
    //sign up
    if(!signIn) {

      //if password less than 6 char show error on submit
      if (password.length < 6) {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Password too short'),
              content: Text('password must be atleast six characters long'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: FlatButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            );
          },
        );

        //if password long enough, send for making acc
      } else {
        try {
          final newUser = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
          if (newUser != null) {
            _store.collection('users').document(email).setData({
              'email': email,
              'bio' : '',
              'username' : '',
              'recipe' : [],
            });
            Navigator.pushNamed(context, Profile.route);
          }

          //if acc alr made, or invalid email show error
        } catch (e) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text('Invalid Input'),
                content: Text('please try again'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: FlatButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            },
          );
          print(e);
          print('ERROR 1 HERE');
        }
      }

      //sign in
    } else if(signIn) {
      try{
        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
        if(user != null){
          Navigator.pushNamed(context, Home.route);
        } else {
          print('ERROR 2 HERE');
        }

        //if wrong details show error
      } catch (e){
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('Invalid input'),
              content: Text('Make sure you have an account or Try again'),
              actions: <Widget>[
                //button to go to register page
                CupertinoDialogAction(
                  child: FlatButton(
                    child: Text("Register"),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        signIn = false;
                      });

                    },
                  ),
                ),

                //button to try again
                CupertinoDialogAction(
                  child: FlatButton(
                    child: Text("Try Again"),
                    onPressed: () {
                      Navigator.pop(context);
                      emailController.clear();
                      passwordController.clear();
                    },
                  ),
                ),
              ],
            );
          },
        );
        print(e);
        print('ERROR 3 HERE');
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            //Logo
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 5),
              child: ClipRect(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    widthFactor: 0.6,
                    heightFactor: 0.6,
                    child: Image.asset(
                      'images/yumzDrawing.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            //Sign in/up toggle
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Container(
                width: 190,
                height: 35,
                decoration: BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            signIn = !signIn;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: signIn
                                ? kIconOrButtonColor
                                : kIconOrButtonColor.withOpacity(0.4),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: signIn ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      child: Container(
                        color: Colors.grey.shade300,
                        height: 50,
                        width: 2,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            signIn = !signIn;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: signIn
                                  ? kIconOrButtonColor.withOpacity(0.4)
                                  : kIconOrButtonColor,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Center(
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontWeight: !signIn ? FontWeight.bold : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            //Username
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 5, left: 73),
                  child: Text(
                    'EMAIL',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 360,
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  fillColor: kRandomBlockGrey,
                  filled: true,
                  hintText: 'Enter your email',
                  icon: Icon(
                    Icons.people,
                    color: kIconOrButtonColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
            ),

            //Password
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 5, left: 73),
                  child: Text(
                    'PASSWORD',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 360,
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: kRandomBlockGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: 'Enter your password',
                  icon: Icon(
                    Icons.lock,
                    color: kIconOrButtonColor,
                  ),
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 70),
                  child: Text(
                    '*atleast 6 chars long*',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            //submit button
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: FlatButton(
                onPressed: checkLogin,
                child: Container(
                  child: Text(
                    signIn ? 'Sign in' : 'Sign up',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                color: kIconOrButtonColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}