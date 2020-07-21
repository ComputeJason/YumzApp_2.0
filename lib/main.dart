import 'package:flutter/material.dart';
import 'screens/add_recipe.dart';
import 'screens/profile.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/edit_profile.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      //Named routes of pages
      initialRoute: Login.route,
      routes: {
        Login.route: (context) => Login(),
        Home.route: (context) => Home(),
        Profile.route: (context) => Profile(),
        EditProfile.route: (context) => EditProfile(),
        AddRecipe.route: (context) => AddRecipe(),

      },
    );
  }

}

