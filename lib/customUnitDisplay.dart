import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import 'customUnit.dart';
import 'main.dart';

class CustomUnitDisplay extends StatefulWidget {
  CustomUnitDisplayState createState() => CustomUnitDisplayState();
}

class CustomUnitDisplayState extends State<CustomUnitDisplay> {
  List<String> units = new List<String>();
  List<File> unitPhoto = new List<File>();

  double aspectRatio = 0.85;

  Future<bool> getUnit() async {
    units = new List<String>();
    unitPhoto = new List<File>();
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Units/Units.txt";
    bool exists = await File(path).exists();
    if (exists) {
      String unitData = await File(path).readAsString();
      List<String> unitDataProcessed = unitData.split("^");
      for (int i = 0; i < unitDataProcessed.length; i++) {
        if (unitDataProcessed[i] != '') {
          units.add(unitDataProcessed[i]);
        }
      }

      String imgPath = "${dir.path}/Units";
      for (int i = 0; i < units.length; i++) {
        unitPhoto.add(File("$imgPath/${units[i]}.png"));
      }
      return true;
    } else {
      return false;
    }
  }

  bool isProcessing = true;

  Widget unitCard(File image, String unit) {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
            child: Card(
              child: Column(
                children: <Widget>[
                  LayoutBuilder(builder: (c, constraints) {
                    return Align(
                        child: Container(
                      child: Image.file(
                        image,
                        fit: BoxFit.cover,
                      ),
                      width: constraints.maxWidth,
                      height: constraints.maxWidth * 0.9 / aspectRatio,
                    ));
                  }),
                  Align(
                      child: Text(
                        "$unit",
                      ),
                      alignment: Alignment.center)
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            onTap: () {
              setState(() {
                Navigator.push(
                    context,
                    PopupLayout(
                      child: Scaffold(
                        body: Container(
                          child: Column(
                            children: <Widget>[
                              Image.file(image),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Text(
                                unit,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              )
                            ],
                          ),
                          color: Colors.black,
                        ),
                        appBar: AppBar(
                          backgroundColor: Colors.black,
                          iconTheme: IconThemeData(color: Colors.white),
                        ),
                      ),
                      bgColor: Colors.black87,
                    ));
              });
            });
      },
    );
  }

  Widget addUnitCard() {
    return Builder(
      builder: (BuildContext context) {
        return InkWell(
          child: Card(
              child: Center(
            child: Icon(
              Icons.add,
              size: 60,
              color: Colors.grey,
            ),
          )),
          onTap: () {
            Navigator.push(
                    context,
                    PopupLayout(
                        child: CustomUnit(
                          top: 20,
                          bottom: 20,
                          left: 20,
                          right: 20,
                        ),
                        top: MediaQuery.of(context).size.height * 0.1,
                        bottom: MediaQuery.of(context).size.height * 0.4,
                        left: 50,
                        right: 50))
                .then((_) {
              setState(() {
                isProcessing = true;
              });
              unitCards = new List<Widget>();
              getUnit().then((_) {
                setState(() {
                  isProcessing = false;
                  for (int i = 0; i < units.length; i++) {
                    unitCards.add(unitCard(unitPhoto[i], units[i]));
                  }
                  unitCards.add(addUnitCard());
                });
              });
            });
          },
        );
      },
    );
  }

  List<Widget> unitCards = new List<Widget>();

  @override
  void initState() {
    getUnit().then((exists) {
      setState(() {
        isProcessing = false;
        if (exists) {
          for (int i = 0; i < units.length; i++) {
            unitCards.add(unitCard(unitPhoto[i], units[i]));
          }
        }
      });
      unitCards.add(addUnitCard());
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: isProcessing
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  children: unitCards,
                  childAspectRatio: aspectRatio,
                )),
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(height: 50),
        color: Colors.orange,
      ),
    );
  }
}
