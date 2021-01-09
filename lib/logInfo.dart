import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logFileHandling.dart';
import 'main.dart';
import 'customUnit.dart';
import 'steps.dart';
import 'customUnitDisplay.dart';
import 'results.dart';
import 'help.dart';
import 'ads.dart';

class LogInfoPage extends StatefulWidget {
  String dishName;
  String logTitle;
  String day, month, year;
  int logNo;
  LogInfoPage(this.dishName, this.logTitle, this.day, this.month, this.year,
      this.logNo);

  LogInfoState createState() => LogInfoState();
}

class LogInfoState extends State<LogInfoPage>
    with SingleTickerProviderStateMixin {
  List<Widget> ingredients = new List<Widget>();
  List<TextEditingController> ingredientController =
      new List<TextEditingController>();
  List<TextEditingController> ingredientAmountController =
      new List<TextEditingController>();
  List<FocusNode> focusNodes = new List<FocusNode>();

  List<String> dropDownList;
  List<String> dropDownVals = new List<String>();

  int ind;

  Ads ads = new Ads();

  List<String> returnIngredients() {
    List<String> list = new List<String>();
    for (int i = 0; i < ingredientController.length; i++) {
      list.add(ingredientController[i].text);
    }
    return list;
  }

  List<String> returnIngredientAmount() {
    List<String> list = new List<String>();
    for (int i = 0; i < ingredientAmountController.length; i++) {
      list.add(ingredientAmountController[i].text);
    }
    return list;
  }

  List<String> returnUnits() {
    return dropDownVals;
  }

  Widget ingredientField() {
    final controller = TextEditingController();
    ingredientController.add(controller);
    final focusNode = FocusNode();
    focusNodes.add(focusNode);
    final amountController = TextEditingController();
    ingredientAmountController.add(amountController);
    String name;
    return Builder(builder: (BuildContext c) {
      return Row(
        children: <Widget>[
          Align(
              child: Container(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (val) {
                name = val;
              },
            ),
            width: MediaQuery.of(c).size.width * 0.4,
          )),
          SizedBox(
            width: 20,
          ),
          Align(
              child: Container(
            child: TextField(
              controller: amountController,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              keyboardType: TextInputType.number,
            ),
            width: MediaQuery.of(c).size.width * 0.1,
          )),
          /*SizedBox(
            width: MediaQuery.of(context).size.width*0.05,
          ),*/
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    });
  }

  Future<List<String>> getUnits() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Units/Units.txt";
    bool exists = await File(path).exists();
    if (exists) {
      File file = File(path);
      String units = await file.readAsString();
      List<String> list = units.split("^");
      for (int i = 0; i < list.length; i++) {
        if (list[i] == '') {
          list.removeAt(i);
        }
      }
      return list;
    } else {
      return null;
    }
  }

  bool unitsRecovered = false;
  Steps steps;
  Results results;

  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    steps = new Steps();
    results = new Results();
    SharedPreferences.getInstance().then((p) {
      prefs = p;
      if (prefs.getBool("Units") == null || prefs.getBool("Units") == false) {
        dropDownList = [
          "Unit",
          "tsp",
          "tbsp",
          "l",
          "ml",
          "kg",
          "g",
        ];
      } else if (prefs.getBool("Units")) {
        dropDownList = ["Unit", "tsp", "tbsp", "gl", "fl oz", "lb", "oz"];
      }
      getUnits().then((units) {
        if (units != null) {
          for (int i = 0; i < units.length; i++) {
            dropDownList.add(units[i]);
          }
        }
        dropDownList.add("N.A.");
        dropDownList.add("Add");
        setState(() {
          unitsRecovered = true;
        });
      });
    });
    ingredients.add(ingredientField());
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    for (int a = 0; a < focusNodes.length; a++) {
      ingredientController[a].dispose();
      focusNodes[a].dispose();
      ingredientAmountController[a].dispose();
    }
    /*for (int b = 0; b < Steps.stepControllers.length; b++) {
      Steps.stepControllers[b].dispose();
    }*/
    super.dispose();
  }

  final listKey = GlobalKey<AnimatedListState>();
  TabController tabController;

  bool isInfoSaved = true;

  @override
  Widget build(BuildContext context) {
    if (ingredients.length > dropDownVals.length) {
      dropDownVals.add("Unit");
    } else if (ingredients.length < dropDownVals.length) {
      dropDownVals.removeAt(ind);
    }
    return WillPopScope(
      child: Stack(children: <Widget>[
        Scaffold(
          body: unitsRecovered
              ? TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    Container(
                      child: AnimatedList(
                        key: listKey,
                        itemBuilder: (BuildContext c, index, animation) {
                          if (index == 0) {
                            return Padding(
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "INGREDIENTS",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              padding: EdgeInsets.only(top: 20),
                            );
                          } else {
                            return SizeTransition(
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      child: Text(
                                        index.toString(),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      padding: EdgeInsets.only(top: 10),
                                    ),
                                    ingredients[index - 1],
                                    Padding(
                                      child: ButtonTheme(
                                        child: DropdownButton<String>(
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black),
                                          value: dropDownVals[index - 1],
                                          onChanged: (String val) {
                                            setState(() {
                                              dropDownVals[index - 1] = val;
                                            });
                                          },
                                          items: dropDownList
                                              .map<DropdownMenuItem<String>>(
                                                  (String v) {
                                            if (v != "Add") {
                                              return DropdownMenuItem(
                                                value: v,
                                                child: Text(v),
                                              );
                                            } else {
                                              return DropdownMenuItem(
                                                value: v,
                                                child: InkWell(
                                                  child: Container(
                                                    child: Text(v),
                                                    width: 40,
                                                    height: 20,
                                                  ),
                                                  onTap: () {
                                                    Navigator.push(
                                                            context,
                                                            PopupLayout(
                                                                child:
                                                                    CustomUnit(
                                                                  top: 20,
                                                                  bottom: 20,
                                                                  left: 20,
                                                                  right: 20,
                                                                ),
                                                                top: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .height *
                                                                    0.1,
                                                                bottom: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.4,
                                                                left: 50,
                                                                right: 50))
                                                        .then((_) {
                                                      getUnits().then((units) {
                                                        if (units != null) {
                                                          if (dropDownList
                                                                      .length -
                                                                  9 !=
                                                              units.length) {
                                                            setState(() {
                                                              dropDownList.removeAt(
                                                                  dropDownList
                                                                          .length -
                                                                      1);
                                                              dropDownList.removeAt(
                                                                  dropDownList
                                                                          .length -
                                                                      1);
                                                              dropDownList.add(
                                                                  units[units
                                                                          .length -
                                                                      1]);
                                                              dropDownList
                                                                  .add("N.A.");
                                                              dropDownList
                                                                  .add("Add");
                                                            });
                                                          }
                                                        }
                                                      });
                                                    });
                                                  },
                                                ),
                                              );
                                            }
                                          }).toList(),
                                        ),
                                        alignedDropdown: true,
                                      ),
                                      padding: EdgeInsets.only(top: 11),
                                    ),
                                    IconButton(
                                      icon: Icon(index == ingredients.length
                                          ? Icons.add
                                          : Icons.remove),
                                      onPressed: () {
                                        if (index == ingredients.length) {
                                          setState(() {
                                            ingredients.add(ingredientField());
                                            listKey.currentState.insertItem(
                                              ingredients.length,
                                            );
                                          });
                                          FocusScope.of(c)
                                              .requestFocus(new FocusNode());
                                          FocusScope.of(c).requestFocus(
                                              focusNodes[
                                                  ingredients.length - 1]);
                                        } else {
                                          setState(() {
                                            listKey.currentState.removeItem(
                                              index,
                                              (context, animation) {
                                                return SizeTransition(
                                                  child: SizedBox(
                                                    height: 0,
                                                    width: 0,
                                                  ),
                                                  sizeFactor: animation,
                                                );
                                              },
                                            );
                                            ind = index - 1;
                                            ingredients.removeAt(index - 1);
                                            ingredientController
                                                .removeAt(index - 1);
                                            ingredientAmountController
                                                .removeAt(index - 1);
                                            focusNodes.removeAt(index - 1);
                                          });
                                        }
                                      },
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                ),
                                sizeFactor: animation);
                          }
                        },
                        initialItemCount: ingredients.length + 1,
                      ),
                    ),
                    steps,
                    results,
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          appBar: AppBar(
            title: Text(
              "Fill in Log details",
              style: TextStyle(fontFamily: "Ubuntu"),
            ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "INGREDIENTS",
                ),
                Tab(
                  text: "STEPS",
                ),
                Tab(text: "RESULTS")
              ],
              controller: tabController,
              indicatorColor: Colors.black,
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.help_outline),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) {
                    return Help();
                  }));
                },
              ),
              Builder(builder: (c) {
                return IconButton(
                  icon: Icon(Icons.done),
                  onPressed: () {
                    if (results.returnImg1() != null ||
                        results.returnImg2() != null ||
                        results.returnImg3() != null) {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (c) {
                            return AlertDialog(
                              title: Text(
                                  "Do you want to complete this log and save? You cannot edit later."),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                ),
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                )
                              ],
                            );
                          }).then((save) async {
                        setState(() {
                          isInfoSaved = false;
                        });
                        try {
                          if (save) {
                            List<String> stepsList = new List<String>();
                            List<String> ingredients = new List<String>();
                            List<String> ingredientAmount = new List<String>();
                            List<String> amountUnit = dropDownVals;

                            stepsList = steps.returnSteps();
                            ingredients = returnIngredients();
                            ingredientAmount = returnIngredientAmount();

                            LogFileHandling logFileHandling =
                                new LogFileHandling(
                                    ingredients: ingredients,
                                    ingredientAmounts: ingredientAmount,
                                    amountUnit: amountUnit,
                                    steps: stepsList,
                                    prepTime: results.returnPreptime(),
                                    cookTime: results.returnCookTime(),
                                    totalTime: results.returnTotalTime(),
                                    servingSize: results.returnServingSize(),
                                    rating: results.returnRating(),
                                    description: results.returnDescription(),
                                    changes: results.returnChanges(),
                                    img1: results.returnImg1(),
                                    img2: results.returnImg2(),
                                    img3: results.returnImg3());

                            await logFileHandling.writeLogToDisk(
                                widget.dishName,
                                widget.logNo,
                                widget.logTitle,
                                widget.day,
                                widget.month,
                                widget.year);

                            await ads.giveInterstitialAd(
                                "ca-app-pub-8930861278958842/9532659646",
                                0,
                                0,
                                AnchorType.bottom);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (BuildContext c) {
                              return HomePage();
                            }), (route) => false);

                            /*Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext c) {
                              return HomePage();
                            }));*/
                          }
                        } catch (e) {
                          Scaffold.of(c).showSnackBar(
                              SnackBar(content: Text("An error Occurred")));
                          setState(() {
                            isInfoSaved = true;
                          });
                        }
                      });
                    } else {
                      Scaffold.of(c).showSnackBar(
                          SnackBar(content: Text("Please add one image")));
                    }
                  },
                );
              }),
              PopupMenuButton<String>(
                initialValue: null,
                itemBuilder: (c) {
                  return ["Custom Units"].map<PopupMenuEntry<String>>((v) {
                    return PopupMenuItem(
                      value: v,
                      child: Text(v),
                    );
                  }).toList();
                },
                onSelected: (v) {
                  if (v == "Custom Units") {
                    Navigator.push(context, MaterialPageRoute(builder: (ctxt) {
                      return CustomUnitDisplay();
                    })).then((_) {
                      getUnits().then((units) {
                        if (units != null) {
                          if (dropDownList.length - 9 != units.length) {
                            setState(() {
                              dropDownList.removeAt(dropDownList.length - 1);
                              dropDownList.removeAt(dropDownList.length - 1);
                              dropDownList.add(units[units.length - 1]);
                              dropDownList.add("N.A.");
                              dropDownList.add("Add");
                            });
                          }
                        }
                      });
                    });
                  }
                },
              )
            ],
          ),
        ),
        isInfoSaved == false
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : SizedBox(
                height: 0,
                width: 0,
              )
      ]),
      onWillPop: () async {
        bool quit = await showDialog(
            context: context,
            builder: (c) {
              return AlertDialog(
                title: Text(
                    "Are you sure want to leave this page? All data will be lost."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Yes"),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  FlatButton(
                    child: Text("No"),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  )
                ],
              );
            },
            barrierDismissible: false);
        return quit;
      },
    );
  }
}
