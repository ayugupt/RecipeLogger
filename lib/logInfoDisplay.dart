import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'logDataClass.dart';
import 'logFileHandling.dart';

import 'dart:io';
import 'dart:ui';

class LogInfoDisplay extends StatefulWidget {
  LogData logData;
  String dishName;
  int logNo;
  LogInfoDisplay(this.logData, this.dishName, this.logNo);
  LogInfoDisplayState createState() => LogInfoDisplayState();
}

class LogInfoDisplayState extends State<LogInfoDisplay>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  LogFileHandling logFile = new LogFileHandling();

  Widget ingredientTile(String ingredient, String ingredientAmount,
      String amountUnit, bool alternate) {
    return Builder(builder: (BuildContext context) {
      return Align(
          child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Padding(
          child: Align(
            child: Text(
              amountUnit != "N.A."
                  ? "$ingredientAmount $amountUnit $ingredient"
                  : "$ingredientAmount $ingredient",
              style: TextStyle(fontSize: 20),
            ),
            alignment: Alignment.center,
          ),
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: MediaQuery.of(context).size.height * 0.02),
        ),
        color: alternate ? Colors.orange[200] : Colors.grey[200],
      ));
    });
  }

  Widget lastIngredientTile(String ingredient, String ingredientAmount,
      String amountUnit, bool alternate) {
    return Builder(
      builder: (BuildContext context) {
        return ClipPath(
          child: Align(
            child: Container(
              child: Padding(
                child: Align(
                  child: Text(
                    amountUnit != "N.A."
                        ? "$ingredientAmount $amountUnit $ingredient"
                        : "$ingredientAmount $ingredient",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.02),
              ),
              width: MediaQuery.of(context).size.width * 0.8,
              color: alternate ? Colors.orange[200] : Colors.grey[200],
            ),
          ),
          clipper: IngredientClipper(),
        );
      },
    );
  }

  Widget stepTile(String step, bool alternate) {
    return Builder(
      builder: (BuildContext context) {
        return Padding(
            child: ClipPath(
              child: Align(
                child: Container(
                  child: Align(
                    child: Padding(
                        child: Text(
                          step,
                          style: TextStyle(fontSize: 18),
                        ),
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.04,
                            bottom: MediaQuery.of(context).size.height * 0.04,
                            left: MediaQuery.of(context).size.width * 0.03,
                            right: MediaQuery.of(context).size.width * 0.03)),
                    alignment: Alignment.centerLeft,
                  ),
                  width: MediaQuery.of(context).size.width * 0.8,
                  color: alternate ? Colors.orange[200] : Colors.grey[200],
                ),
              ),
              clipper: !alternate ? StepClipperRight() : StepClipperLeft(),
            ),
            padding: //alternate?
                EdgeInsets.only(
                    //left: MediaQuery.of(context).size.width * 0.1,
                    bottom: MediaQuery.of(context).size.height * 0.02));
        //: EdgeInsets.only(
        //right: MediaQuery.of(context).size.width * 0.1,
        //bottom: MediaQuery.of(context).size.height * 0.02));
      },
    );
  }

  Widget ratingIcon(double pos, double val, double size) {
    if (pos <= val) {
      return Icon(
        Icons.star,
        size: size,
        color: Colors.yellow,
      );
    } else if (val % 0.5 == 0 && pos == val + 0.5) {
      return Icon(
        Icons.star_half,
        size: size,
        color: Colors.yellow,
      );
    } else {
      return Icon(
        Icons.star_border,
        size: size,
        color: Colors.yellow,
      );
    }
  }

  List<Widget> ingredients = new List<Widget>();
  List<Widget> steps = new List<Widget>();
  List<File> dishImages = new List<File>();

  List<Widget> imageWidget = new List<Widget>();

  bool gotImages = false;
  @override
  void initState() {
    tabController = new TabController(vsync: this, length: 3);

    logFile.returnAllImages(widget.dishName, widget.logNo).then((images) {
      setState(() {
        for (int i = 0; i < images.length; i++) {
          imageWidget.add(
            Padding(
              child: Container(
                child: Image.file(
                  images[i],
                  fit: BoxFit.cover,
                ),
                height: MediaQuery.of(context).size.width * 2 / 3,
                width: MediaQuery.of(context).size.width,
              ),
              padding: EdgeInsets.only(right: 20),
            ),
          );
        }
        gotImages = true;
        dishImages = images;
      });
    });

    ingredients.add(SizedBox(
      height: 20,
    ));
    List<String> s = new List<String>();
    List<String> ing = new List<String>();
    List<String> amount = new List<String>();
    List<String> unit = new List<String>();
    for (int i = 0; i < widget.logData.steps.length; i++) {
      if (widget.logData.steps[i] != '') {
        s.add(widget.logData.steps[i]);
      }
    }

    for (int i = 0; i < widget.logData.ingredients.length; i++) {
      if (widget.logData.ingredients[i] != '') {
        ing.add(widget.logData.ingredients[i]);
        amount.add(widget.logData.ingredientAmount[i]);
        unit.add(widget.logData.amountUnit[i]);
      }
    }

    for (int i = 0; i < ing.length; i++) {
      if (i % 2 == 0 && i != ing.length - 1) {
        ingredients.add(ingredientTile(ing[i], amount[i], unit[i], false));
      } else if (i % 2 != 0 && i != ing.length - 1) {
        ingredients.add(ingredientTile(ing[i], amount[i], unit[i], true));
      } else if (i % 2 == 0 && i == ing.length - 1) {
        ingredients.add(lastIngredientTile(ing[i], amount[i], unit[i], false));
      } else if (i % 2 != 0 && i == ing.length - 1) {
        ingredients.add(lastIngredientTile(ing[i], amount[i], unit[i], true));
      }
    }

    for (int i = 0; i < s.length; i++) {
      steps.add(stepTile(s[i], i % 2 == 0 ? false : true));
      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double size = 50;
    double pad = 10;
    return Scaffold(
      body: TabBarView(controller: tabController, children: <Widget>[
        Center(
            child: ListView(
          children: ingredients,
        )),
        Center(
          child: ListView(
            children: steps,
          ),
        ),
        Padding(
          child: ListView(
            children: <Widget>[
              gotImages
                  ? Align(
                      child: CarouselSlider(
                      items:
                          imageWidget/*<Widget>[
                        Padding(
                          child: Container(
                            child: Image.file(
                              dishImages[0],
                              fit: BoxFit.cover,
                            ),
                            height: MediaQuery.of(context).size.width * 2 / 3,
                            width: MediaQuery.of(context).size.width,
                          ),
                          padding: EdgeInsets.only(right: 20),
                        ),
                        Padding(
                          child: Container(
                            child: Image.file(
                              dishImages[1],
                              fit: BoxFit.cover,
                            ),
                            height: MediaQuery.of(context).size.width * 2 / 3,
                            width: MediaQuery.of(context).size.width,
                          ),
                          padding: EdgeInsets.only(right: 20),
                        ),
                        Padding(
                          child: Container(
                            child: Image.file(
                              dishImages[2],
                              fit: BoxFit.cover,
                            ),
                            height: MediaQuery.of(context).size.width * 2 / 3,
                            width: MediaQuery.of(context).size.width,
                          ),
                          padding: EdgeInsets.only(right: 20),
                        )
                      ]*/
                      ,
                      initialPage: 0,
                    ))
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                  child: Container(
                child: Row(
                  children: <Widget>[
                    ratingIcon(1, widget.logData.rating, size),
                    ratingIcon(2, widget.logData.rating, size),
                    ratingIcon(3, widget.logData.rating, size),
                    ratingIcon(4, widget.logData.rating, size),
                    ratingIcon(5, widget.logData.rating, size)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                width: MediaQuery.of(context).size.width * 0.9,
              )),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: <Widget>[
                  Container(
                    child: Text("Preperation Time: ${widget.logData.prepTime}"),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[200]),
                    padding: EdgeInsets.all(pad),
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  Container(
                      child: Text("Cooking Time: ${widget.logData.cookTime}"),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange[200]),
                      padding: EdgeInsets.all(pad),
                      width: MediaQuery.of(context).size.width * 0.4)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Row(
                children: <Widget>[
                  Container(
                      child: Text("Total Time: ${widget.logData.totalTime}"),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orange[200]),
                      padding: EdgeInsets.all(pad),
                      width: MediaQuery.of(context).size.width * 0.4),
                  Container(
                      child:
                          Text("Serving Size: ${widget.logData.servingSize}"),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: EdgeInsets.all(pad),
                      width: MediaQuery.of(context).size.width * 0.4)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[200]),
                  child: Text("Description:-\n${widget.logData.desc}"),
                  padding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.orange[200]),
                  child: Text(
                      "Changes for a future attempt:-\n${widget.logData.changes}"),
                  padding: EdgeInsets.all(20),
                ),
              )
            ],
          ),
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
        )
      ]),
      appBar: AppBar(
        bottom: TabBar(
          controller: tabController,
          tabs: <Widget>[
            Tab(
              text: "INGREDIENTS",
            ),
            Tab(
              text: "STEPS",
            ),
            Tab(
              text: "DETAILS",
            )
          ],
          indicatorColor: Colors.black,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(height: 50),
        color: Colors.orange,
      ),
    );
  }
}

class IngredientClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    int diff = 5;
    double cuts = 40;

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    int a = 0;

    for (double i = size.width - size.width / cuts;
        i >= 0;
        i -= size.width / cuts) {
      if (a % 2 == 0) {
        path.lineTo(i, size.height - diff);
      } else {
        path.lineTo(i, size.height);
      }
      a++;
    }
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

class StepClipperRight extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, 0);
    path.lineTo(size.width * 0.8, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width * 0.8, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}

class StepClipperLeft extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = new Path();
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width * 0.2, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(oldClipper) => false;
}
