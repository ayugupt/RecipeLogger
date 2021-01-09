import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'main.dart';
import 'newLog.dart';
import 'logFileHandling.dart';
import 'logDataClass.dart';
import 'ads.dart';
import 'logInfoDisplay.dart';

class LogsPage extends StatefulWidget {
  String dishName;
  LogsPage(this.dishName);
  LogsPageState createState() => LogsPageState();
}

class LogsPageState extends State<LogsPage> {
  String title, day, month, year;

  List<Widget> logList = new List<Widget>();
  List<Widget> logListOld = new List<Widget>();
  List<Widget> logListHigh = new List<Widget>();
  List<Widget> logListLow = new List<Widget>();
  List<Widget> logListMarked = new List<Widget>();

  List<double> logRatings = new List<double>();
  List<double> logRatingsDesc = new List<double>();

  List<int> markedLogNo = new List<int>();

  List<int> ratedHighLogNo = new List<int>();
  List<int> ratedLowLogNo = new List<int>();

  LogFileHandling logFileHandling = new LogFileHandling();

  bool noLogs = true;
  bool processing = true;

  Map<String, dynamic> logsData = new Map<String, dynamic>();

  String initialPopupvalue = "Old";

  LogBookMark logBookMark = new LogBookMark();

  BannerAd bannerAd;
  Ads ads = new Ads();

  void initState() {
    /*ads.giveBannerAd("a", 0, 0, AnchorType.top).then((ad) {
      setState(() {
        bannerAd = ad;
      });
    });*/
    logFileHandling.readLogFile(widget.dishName).then((map) {
      if (map == null) {
        setState(() {
          noLogs = true;
          processing = false;
        });
      } else {
        logFileHandling
            .returnFirstImage(widget.dishName, map.keys.toList().length)
            .then((images) {
          logBookMark.getMarks(widget.dishName).then((marked) {
            if (marked != null) {
              for (int q = 0; q < marked.length; q++) {
                markedLogNo.add(int.parse(marked[q]));
              }
            }
            List<File> imageList = images;
            //setState(() {
            logsData = map;
            for (int i = 1; i <= logsData.keys.toList().length; i++) {
              List<dynamic> ingredientsD = logsData["Log$i"]["Ingredients"];
              List<dynamic> ingredientAmountD =
                  logsData["Log$i"]["IngredientAmounts"];
              List<dynamic> amountUnitsD = logsData["Log$i"]["AmountUnits"];
              List<dynamic> stepsD = logsData["Log$i"]["Steps"];
              String prepTime = logsData["Log$i"]["PrepTime"].toString();
              String cookTime = logsData["Log$i"]["CookTime"].toString();
              String totalTime = logsData["Log$i"]["TotalTime"].toString();
              String servingSize = logsData["Log$i"]["ServingSize"].toString();
              double rating = logsData["Log$i"]["Rating"];
              String description = logsData["Log$i"]["Description"].toString();
              String changes = logsData["Log$i"]["Changes"].toString();
              String title = logsData["Log$i"]["Title"].toString();
              String day = logsData["Log$i"]["Day"].toString();
              String month = logsData["Log$i"]["Month"].toString();
              String year = logsData["Log$i"]["Year"].toString();

              List<String> ingredients = new List<String>();
              List<String> ingredientAmount = new List<String>();
              List<String> amountUnits = new List<String>();
              List<String> steps = new List<String>();

              ingredientsD.forEach((s) {
                ingredients.add(s.toString());
              });
              ingredientAmountD.forEach((s) {
                ingredientAmount.add(s.toString());
              });
              amountUnitsD.forEach((s) {
                amountUnits.add(s.toString());
              });
              stepsD.forEach((s) {
                steps.add(s.toString());
              });

              logRatings.add(rating);
              logRatingsDesc.add(rating);

              bool bookMarked = false;
              if (marked != null) {
                for (int d = 0; d < markedLogNo.length; d++) {
                  if (markedLogNo[d] == i) {
                    bookMarked = true;
                  }
                }
              }

              Widget card = logCard(
                  ingredients,
                  ingredientAmount,
                  amountUnits,
                  steps,
                  prepTime,
                  cookTime,
                  totalTime,
                  servingSize,
                  rating,
                  description,
                  changes,
                  imageList[i - 1],
                  title,
                  day,
                  month,
                  year,
                  i,
                  bookMarked);

              logList.add(card);
              logListHigh.add(card);
              logListLow.add(card);

              ratedHighLogNo.add(i);
              ratedLowLogNo.add(i);

              if (bookMarked) {
                logListMarked.add(card);
              }
            }
            processing = false;
            noLogs = false;

            for (int a = logList.length - 1; a >= 0; a--) {
              logListOld.add(logList[a]);
            }

            for (int r = 0; r < logRatings.length - 1; r++) {
              for (int c = 0; c < logRatings.length - r - 1; c++) {
                if (logRatings[c] > logRatings[c + 1]) {
                  double temp = logRatings[c];
                  logRatings[c] = logRatings[c + 1];
                  logRatings[c + 1] = temp;

                  Widget tempWidget = logListLow[c];
                  logListLow[c] = logListLow[c + 1];
                  logListLow[c + 1] = tempWidget;

                  int tempNo = ratedLowLogNo[c];
                  ratedLowLogNo[c] = ratedLowLogNo[c + 1];
                  ratedLowLogNo[c + 1] = tempNo;
                }

                if (logRatingsDesc[c] < logRatingsDesc[c + 1]) {
                  double temp = logRatingsDesc[c];
                  logRatingsDesc[c] = logRatingsDesc[c + 1];
                  logRatingsDesc[c + 1] = temp;

                  Widget tempWidget2 = logListHigh[c];
                  logListHigh[c] = logListHigh[c + 1];
                  logListHigh[c + 1] = tempWidget2;

                  int tempNo = ratedHighLogNo[c];
                  ratedHighLogNo[c] = ratedHighLogNo[c + 1];
                  ratedHighLogNo[c + 1] = tempNo;
                }
              }
            }
            setState(() {});
          });

          //});
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    print("disposed");
    super.dispose();
  }

  Widget firstLog(BuildContext cntxt) {
    return Center(
      child: InkWell(
        child: Container(
          child: Column(
            children: <Widget>[
              Icon(
                Icons.add_circle_outline,
                size: MediaQuery.of(cntxt).size.width * 0.2,
                color: Colors.grey[300],
              ),
              Text(
                "Add your first Log!",
                style: TextStyle(color: Colors.grey[300], fontSize: 20),
              )
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          height: MediaQuery.of(cntxt).size.height * 0.3,
        ),
        onTap: () {
          Navigator.push(
              cntxt,
              PopupLayout(
                  bottom: 180,
                  top: 100,
                  right: 20,
                  left: 20,
                  child: NewLog(widget.dishName, logList.length + 1)));
        },
        splashColor: Colors.white,
        highlightColor: Colors.white,
      ),
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

  double size = 30;
  Widget logCard(
      List<String> ingredients,
      List<String> ingredientAmount,
      List<String> amountUnit,
      List<String> steps,
      String prepTime,
      String cookTime,
      String totalTime,
      String servingSize,
      double rating,
      String desc,
      String changes,
      File image,
      String title,
      String day,
      String month,
      String year,
      int logNo,
      bool bookMarked) {
    return Builder(
      builder: (BuildContext c) {
        return InkWell(
          child: Align(
            child: Container(
              child: Card(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ratingIcon(1, rating, size),
                            ratingIcon(2, rating, size),
                            ratingIcon(3, rating, size),
                            ratingIcon(4, rating, size),
                            ratingIcon(5, rating, size)
                          ],
                        ),
                        Text(
                          "Made on $day/$month/$year",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    Padding(
                      child: Row(
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Log$logNo: $title",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Ubuntu",
                                  fontWeight: FontWeight.bold),
                            ),
                            width: MediaQuery.of(c).size.width * 0.7,
                          ),
                          IconButton(
                            icon: Icon(!bookMarked
                                ? Icons.bookmark_border
                                : Icons.bookmark),
                            onPressed: () {
                              setState(() {
                                bookMarked = !bookMarked;
                                if (bookMarked) {
                                  logBookMark.markLog(widget.dishName, logNo);
                                  Widget newLogCard = logCard(
                                      ingredients,
                                      ingredientAmount,
                                      amountUnit,
                                      steps,
                                      prepTime,
                                      cookTime,
                                      totalTime,
                                      servingSize,
                                      rating,
                                      desc,
                                      changes,
                                      image,
                                      title,
                                      day,
                                      month,
                                      year,
                                      logNo,
                                      bookMarked);

                                  logListMarked.add(newLogCard);
                                  markedLogNo.add(logNo);
                                  logList[logNo - 1] = newLogCard;
                                  logListOld[logListOld.length - logNo] =
                                      newLogCard;
                                  int e = 0;
                                  for (int w = 0;
                                      w < logListHigh.length && e < 2;
                                      w++) {
                                    if (ratedHighLogNo[w] == logNo) {
                                      logListHigh[w] = newLogCard;
                                      e++;
                                    }
                                    if (ratedLowLogNo[w] == logNo) {
                                      logListLow[w] = newLogCard;
                                      e++;
                                    }
                                  }
                                } else {
                                  logBookMark.removeMark(
                                      widget.dishName, logNo);
                                  Widget newLogCard = logCard(
                                      ingredients,
                                      ingredientAmount,
                                      amountUnit,
                                      steps,
                                      prepTime,
                                      cookTime,
                                      totalTime,
                                      servingSize,
                                      rating,
                                      desc,
                                      changes,
                                      image,
                                      title,
                                      day,
                                      month,
                                      year,
                                      logNo,
                                      bookMarked);
                                  //logListMarked.add(newLogCard);

                                  for (int t = 0; t < markedLogNo.length; t++) {
                                    if (markedLogNo[t] == logNo) {
                                      logListMarked.removeAt(t);
                                      markedLogNo.removeAt(t);
                                      break;
                                    }
                                  }

                                  logList[logNo - 1] = newLogCard;
                                  logListOld[logListOld.length - logNo] =
                                      newLogCard;
                                  int e = 0;
                                  for (int w = 0;
                                      w < logListHigh.length && e < 2;
                                      w++) {
                                    if (ratedHighLogNo[w] == logNo) {
                                      logListHigh[w] = newLogCard;
                                      e++;
                                    }
                                    if (ratedLowLogNo[w] == logNo) {
                                      logListLow[w] = newLogCard;
                                      e++;
                                    }
                                  }
                                }
                              });
                              //setState(() {});
                            },
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(c).size.width * 0.02),
                    ),
                    SizedBox(
                      height: MediaQuery.of(c).size.height * 0.02,
                    ),
                    Container(
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                      width: MediaQuery.of(c).size.width,
                      height: MediaQuery.of(c).size.height * 0.4,
                    ),
                    Padding(
                      child: Align(
                        child: Container(
                          child: Text(
                            desc,
                            style:
                                TextStyle(fontSize: 18, fontFamily: "Ubuntu"),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(c).size.width * 0.03,
                          top: MediaQuery.of(c).size.height * 0.02,
                          bottom: MediaQuery.of(c).size.height * 0.02),
                    ),
                  ],
                ),
              ),
              width: MediaQuery.of(c).size.width * 1,
            ),
          ),
          onTap: () {
            LogData logData = new LogData(
                ingredients,
                ingredientAmount,
                amountUnit,
                steps,
                prepTime,
                cookTime,
                totalTime,
                servingSize,
                rating,
                desc,
                changes,
                day,
                month,
                year,
                title);
            Navigator.push(c, MaterialPageRoute(builder: (BuildContext cntxt) {
              return LogInfoDisplay(logData, widget.dishName, logNo);
            }));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !processing
          ? Container(
              child: noLogs
                  ? firstLog(context)
                  : ListView.builder(
                      itemCount: initialPopupvalue == "BookMarked"
                          ? (logListMarked.length != 0
                              ? logListMarked.length
                              : 1)
                          : logList.length,
                      itemBuilder: (c, index) {
                        //print(logListMarked.length);
                        return initialPopupvalue == "Old"
                            ? logList[index]
                            : (initialPopupvalue == "New"
                                ? logListOld[index]
                                : (initialPopupvalue == "High Rated"
                                    ? logListHigh[index]
                                    : (initialPopupvalue == "BookMarked"
                                        ? (logListMarked.length != 0
                                            ? logListMarked[index]
                                            : SizedBox(
                                                height: 0,
                                                width: 0,
                                              ))
                                        : logListLow[index])));
                      },
                    ))
          : Center(
              child: CircularProgressIndicator(),
            ),
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            initialValue: initialPopupvalue,
            itemBuilder: (cntxt) {
              return ["Old", "New", "High Rated", "Low Rated", "BookMarked"]
                  .map<PopupMenuEntry<String>>((String a) {
                return PopupMenuItem(
                  child: Text(a),
                  value: a,
                );
              }).toList();
            },
            onSelected: (val) {
              setState(() {
                initialPopupvalue = val;
              });
            },
          )
        ],
      ),
      floatingActionButton: noLogs
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    PopupLayout(
                        bottom: 180,
                        top: 100,
                        right: 20,
                        left: 20,
                        child: NewLog(widget.dishName, logList.length + 1)));
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 50,
        ),
        color: Colors.orange,
      ),
    );
  }
}
