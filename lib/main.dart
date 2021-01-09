import 'dart:core';

import 'package:app/logsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'newRecipe.dart';
import 'dish.dart';
import 'logFileHandling.dart';
import 'customUnitDisplay.dart';
import 'aboutUs.dart';
import 'help.dart';
import 'ads.dart';
import 'settings.dart';

void main()async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  //String dish;
  //HomePage({this.dish});
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Widget> recipeList = new List<Widget>();
  List<String> nameList = new List<String>();

  DishFileHandling dishFile = new DishFileHandling();

  @override
  void initState() {
    if (Ads.bannerAd == null) {
      Ads.giveBannerAd(
          "ca-app-pub-8930861278958842/7812723171", 0, 0, AnchorType.bottom);
    }
    dishFile.readDishFile().then((list) {
      if (list != null) {
        List<String> names = list;
        setState(() {
          for (int i = 0; i < names.length; i++) {
            nameList.add(names[i]);
            recipeList.add(dishTile(names[i]));
          }
        });
      }
    });
    searchController.addListener(() {
      count = 0;
      resultDishes = new List<int>();
      setState(() {
        for (int i = 0; i < nameList.length; i++) {
          List<String> words = nameList[i].split(" ");
          List<bool> equalDiff = new List<bool>(words.length);
          for (int k = 0; k < equalDiff.length; k++) {
            equalDiff[k] = true;
          }
          for (int l = 0; l < equalDiff.length; l++) {
            for (int j = 0;
                j <
                        (searchController.text.length > words[l].length
                            ? words[l].length
                            : searchController.text.length) &&
                    equalDiff[l];
                j++) {
              if (searchController.text[j].toLowerCase() !=
                  words[l][j].toLowerCase()) {
                equalDiff[l] = false;
              }
            }
          }
          bool equal = false;
          for (int m = 0; m < equalDiff.length && !equal; m++) {
            if (equalDiff[m]) {
              resultDishes.add(i);
              count++;
              equal = true;
            }
          }
        }
      });
    });
    super.initState();
  }

  int count;
  List<int> resultDishes;

  Widget dishTile(String name) {
    return Builder(builder: (cntxt) {
      return ListTile(
        title: Row(children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.remove_circle_outline),
            onPressed: () {
              showDialog(
                  context: cntxt,
                  barrierDismissible: false,
                  builder: (c) {
                    return AlertDialog(
                        title: Text(
                            "Are you sure you want to permanently delete this Dish and it's logs?"),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text("Yes"),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text("No"),
                          )
                        ]);
                  }).then((delete) {
                if (delete) {
                  dishFile.deleteDishAndLogs(name);
                  setState(() {
                    bool found = false;
                    for (int i = 0;
                        i < nameList.length && found == false;
                        i++) {
                      if (name == nameList[i]) {
                        nameList.removeAt(i);
                        recipeList.removeAt(i);
                        found = true;
                      }
                    }
                  });
                }
              });
            },
          )
        ]),
        onTap: () async {
          //if(bannerAd != null){
          // /await bannerAd.dispose();
          // }
          Navigator.push(cntxt, MaterialPageRoute(builder: (BuildContext c) {
            return LogsPage(name);
          }));
        },
      );
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focus.dispose();
    super.dispose();
  }

  final searchController = TextEditingController();

  final focus = FocusNode();

  Widget noDishes() {
    return Builder(
      builder: (BuildContext context) {
        return Center(
            child: Container(
                child: Text(
          "No Dishes Created",
          style: TextStyle(color: Colors.grey[300], fontSize: 30),
          textAlign: TextAlign.center,
        )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dishes",
        ),
        actions: <Widget>[
          Padding(
            child: Align(
                child: Container(
              child: Row(
                children: <Widget>[
                  Align(
                      child: Container(
                    child: TextField(
                      focusNode: focus,
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search a Dish",
                        contentPadding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.012,
                          //bottom: MediaQuery.of(context).size.height * 0.01
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.05,
                  )),
                  searchController.text != ''
                      ? IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            searchController.text = '';
                            focus.unfocus();
                          },
                        )
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
            )),
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.02),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            PopupLayout(
                top: 80, left: 30, right: 30, bottom: 300, child: NewRecipe()),
          ).then((_) {
            setState(() {
              if (Dish.name != '') {
                nameList.add(Dish.name);
                recipeList.add(dishTile(Dish.name));
                DishFileHandling dishFileHandling =
                    new DishFileHandling(name: Dish.name);
                dishFileHandling.writeDishFile();
              }
            });
          });
        },
      ),
      body: Container(
        child: recipeList.length != 0
            ? ListView.separated(
                itemBuilder: (BuildContext context, index) {
                  if (searchController.text == '') {
                    return recipeList[index];
                  } else {
                    return recipeList[resultDishes[index]];
                  }
                },
                itemCount:
                    searchController.text == '' ? recipeList.length : count,
                separatorBuilder: (context, index) {
                  return Divider(
                    indent: 20,
                    endIndent: 20,
                    thickness: 1,
                  );
                },
              )
            : noDishes(),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.orange[500], Colors.orange[200]],
              )),
              child: Image.asset("assets/recipeLog.png"),
            ),
            ListTile(
              leading: Icon(Icons.kitchen),
              title: Text("Custom Units"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext c) {
                  return CustomUnitDisplay();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text("Help"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return Help();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("About Us"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) {
                  return AboutUs();
                }));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (ct) {
                  return Settings();
                }));
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(height: 50),
        color: Colors.orange,
      ),
    );
  }
}

class PopupLayout extends ModalRoute {
  double top;
  double bottom;
  double left;
  double right;
  Color bgColor;
  final Widget child;

  PopupLayout(
      {Key key,
      this.bgColor,
      @required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
  @override
  bool get opaque => false;
  @override
  bool get barrierDismissible => false;
  @override
  Color get barrierColor =>
      bgColor == null ? Colors.black.withOpacity(0.5) : bgColor;
  @override
  String get barrierLabel => null;
  @override
  bool get maintainState => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    if (top == null) this.top = 10;
    if (bottom == null) this.bottom = 20;
    if (left == null) this.left = 20;
    if (right == null) this.right = 20;

    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom: this.bottom,
          left: this.left,
          right: this.right,
          top: this.top),
      child: child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
