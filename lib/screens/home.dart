import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/foundation.dart';
import 'package:yumzapp/constants.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:yumzapp/screens/profile.dart';
import 'package:yumzapp/search_screen.dart';

class HomeHeader implements SliverPersistentHeaderDelegate {
  HomeHeader({
    this.onLayoutToggle,
    this.minExtent,
    this.maxExtent,
  });
  final VoidCallback onLayoutToggle;
  double maxExtent;
  double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'images/yumz_logo.png',
          fit: BoxFit.cover,
        ),
        Positioned(
          right: 10,
          top: 4,
          child: SafeArea(
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.route);
              },
            ),
          ),
        ),
        Positioned(
          left: 6,
          top: 4,
          child: SafeArea(
            child: IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pushNamed(context, Profile.route);
              },
            ),
          ),
        )
      ],
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration get stretchConfiguration =>
      OverScrollHeaderStretchConfiguration();
}

class Home extends StatelessWidget {
  static const String route = 'home';

  Home({Key key, this.onLayoutToggle}) : super(key: key);
  final VoidCallback onLayoutToggle;

  final List<String> assetNames = [
    'images/10_easy_pasta_dishes.jpg',
    'images/bakes_for_this_quarantine.jpg',
    'images/healthy_recipes.jpg',
    'images/zuccini_recipe.jpg',
  ];

  final List<String> assetTitles = [
    '10 easy pasta dishes',
    'bakes',
    'healthy recipes',
    'craze for zuccini',
  ];

  final List<String> recipeAssets = [
    'images/Trail-Mix-Cookies.jpg',
    'images/buttermilk_springchicken.jpg',
    'images/dokbokki.jpg',
    'images/Chicken-Parmesean.jpg',
    'images/crispy_ricebowl.jpg',
    'images/Grilled-Pork-Shoulder-Steaks-Herb-Salad.jpg',
  ];

  final List<String> recipeNames = [
    'Trail Mix Cookies',
    'Buttermilk Spring Chicken',
    'Deokbokki',
    'Chicken Parmesean',
    'Crispy Ricebowl',
    'Grilled Pork Shoulder Steaks Herb Salad',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _scrollView(context),
    );
  }

  Widget _scrollView(BuildContext context) {
    // Use LayoutBuilder to get the hero header size while keeping the image aspect-ratio
    return SafeArea(
      child: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: HomeHeader(
                onLayoutToggle: onLayoutToggle,
                minExtent: 150.0,
                maxExtent: 250.0,
              ),
            ),
            SliverStickyHeader(
              header: Container(
                height: 60.0,
                color: kAppBarColor,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'What\'s New?',
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                ),
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 0.0,
                  crossAxisSpacing: 0.0,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: _edgeInsetsForIndex(index),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                  assetNames[index % assetNames.length],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                                stops: [0.5, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.repeated,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                            child: Text(
                              assetTitles[index % assetNames.length],
                              style:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: assetNames.length,
                ),
              ),
            ),
            SliverStickyHeader(
              header: Container(
                height: 60.0,
                color: kAppBarColor,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Poplar recipes',
                  style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
                ),
              ),
              sliver: SliverFixedExtentList(
                itemExtent: 400.0,
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                  recipeAssets[index],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black54,
                                ],
                                stops: [0.5, 1.0],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                tileMode: TileMode.repeated,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            right: 16.0,
                            bottom: 16.0,
                            child: Text(
                              recipeNames[index],
                              style:
                              TextStyle(fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: recipeAssets.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _edgeInsetsForIndex(int index) {
    if (index % 2 == 0) {
      return EdgeInsets.only(top: 4.0, left: 8.0, right: 4.0, bottom: 4.0);
    } else {
      return EdgeInsets.only(top: 4.0, left: 4.0, right: 8.0, bottom: 4.0);
    }
  }
}