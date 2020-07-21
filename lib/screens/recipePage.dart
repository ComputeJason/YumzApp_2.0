import 'package:flutter/material.dart';
import 'package:yumzapp/constants.dart';

class RecipePage extends StatelessWidget {
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.network('https://hips.hearstapps.com/prima.cdnds.net/assets/16/02/980x490/landscape-1452786528-dairy-free-vanilla-and-blueberry-cheesecake.jpg?resize=1200:*'),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Blueberry',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              shadows: [
                                Shadow(
                                    offset: Offset(2,2),
                                    color: Colors.white,
                                    blurRadius: 3
                                )
                              ]
                          ),
                        ),
                        Text(
                          'CheeseCake',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            shadows: [
                              Shadow(
                                  offset: Offset(2,2),
                                  color: Colors.white,
                                  blurRadius: 3
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'A delicious cheesy cake that is easy to make!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'Steps',
                        style: TextStyle(
                          color: kHeading,
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 374,
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
                          SizedBox(
                            height: 7,
                          ),
                          Text(
                            '1) 2 1/3 cups graham cracker crumbs',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '2) 1/2 cup (1 stick) unsalted butter, melted',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '3) 1/4 cup sugar',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '4) 4 8-ounce packages cream cheese',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '5) 1/4 cup all purpose flour',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '6) 1 1/2 cups sugar',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '7) 5 large eggs',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '8) 1 16-ounce container sour cream',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '9) 1/4 cup milk',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}