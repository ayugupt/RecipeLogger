import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Results extends StatefulWidget {
  final prepController = TextEditingController();
  final cookController = TextEditingController();
  final totalController = TextEditingController();
  final servingController = TextEditingController();
  final descriptionController = TextEditingController();
  final changesController = TextEditingController();
  File image1;
  File image2;
  File image3;
  double rating = 0;

  String returnCookTime() => cookController.text;
  String returnPreptime() => prepController.text;
  String returnTotalTime() => totalController.text;
  String returnServingSize() => servingController.text;
  double returnRating() => rating;
  String returnDescription() => descriptionController.text;
  String returnChanges() => changesController.text;
  File returnImg1() => image1;
  File returnImg2() => image2;
  File returnImg3() => image3;

  ResultsState createState() => ResultsState();
}

class ResultsState extends State<Results> {
  Future<File> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = 60;
    return Container(
      child: ListView(children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          children: <Widget>[
            Align(
              child: Container(
                child: TextField(
                  controller: widget.prepController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Preperation Time",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      prefixIcon: Icon(Icons.timer)),
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Align(
              child: Container(
                child: TextField(
                  controller: widget.cookController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Cooking Time",
                      labelStyle: TextStyle(fontSize: 12, color: Colors.black),
                      prefixIcon: Icon(Icons.timer)),
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          children: <Widget>[
            Align(
              child: Container(
                child: TextField(
                  controller: widget.totalController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Total Time",
                      labelStyle: TextStyle(fontSize: 12, color: Colors.black),
                      prefixIcon: Icon(Icons.access_time)),
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            ),
            Align(
              child: Container(
                child: TextField(
                  controller: widget.servingController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Serving Size",
                      labelStyle: TextStyle(color: Colors.black, fontSize: 12),
                      prefixIcon: Icon(Icons.room_service)),
                ),
                width: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                    color: Colors.orange[200],
                    borderRadius: BorderRadius.circular(20)),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Padding(
          child: Row(
            children: <Widget>[
              InkWell(
                child: Container(
                  child: widget.image1 == null
                      ? Center(
                          child: Icon(Icons.camera_alt),
                        )
                      : Image.file(widget.image1, fit: BoxFit.cover),
                  width: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.orange[200],
                  height: MediaQuery.of(context).size.width * 0.5,
                ),
                onTap: () {
                  getImage().then((img) {
                    setState(() {
                      if (img != null) {
                        widget.image1 = img;
                      }
                    });
                  });
                },
              ),
              Column(
                children: <Widget>[
                  Padding(
                    child: InkWell(
                      child: Container(
                          child: widget.image2 == null
                              ? Center(
                                  child: Icon(Icons.camera_alt),
                                )
                              : Image.file(widget.image2, fit: BoxFit.cover),
                          width: MediaQuery.of(context).size.width * 0.23,
                          color: Colors.orange[200],
                          height: MediaQuery.of(context).size.width * 0.23),
                      onTap: () {
                        getImage().then((img) {
                          setState(() {
                            if (img != null) {
                              widget.image2 = img;
                            }
                          });
                        });
                      },
                    ),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05,
                        bottom: MediaQuery.of(context).size.width * 0.04),
                  ),
                  Padding(
                    child: InkWell(
                      child: Container(
                        child: widget.image3 == null
                            ? Center(
                                child: Icon(Icons.camera_alt),
                              )
                            : Image.file(widget.image3, fit: BoxFit.cover),
                        width: MediaQuery.of(context).size.width * 0.23,
                        color: Colors.orange[200],
                        height: MediaQuery.of(context).size.width * 0.23,
                      ),
                      onTap: () {
                        getImage().then((img) {
                          setState(() {
                            if (img != null) {
                              widget.image3 = img;
                            }
                          });
                        });
                      },
                    ),
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.05),
                  )
                ],
              )
            ],
          ),
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Stack(children: <Widget>[
          Padding(
            child: Row(
              children: <Widget>[
                ratingIcon(1, widget.rating, size),
                ratingIcon(2, widget.rating, size),
                ratingIcon(3, widget.rating, size),
                ratingIcon(4, widget.rating, size),
                ratingIcon(5, widget.rating, size)
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0),
          ),
          Center(
              child: Padding(
            child: Container(
              child: Opacity(
                child: Slider(
                  value: widget.rating,
                  onChanged: (newVal) {
                    setState(() {
                      widget.rating = newVal;
                    });
                  },
                  min: 0,
                  max: 5,
                  divisions: 10,
                ),
                opacity: 0,
              ),
              width: MediaQuery.of(context).size.width * 0.9,
            ),
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
          ))
        ]),
        Center(
          child: Text("RATING"),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Align(
          child: Container(
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: widget.descriptionController,
              decoration: InputDecoration(
                  hintText: "Describe the final dish",
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Icon(Icons.description)),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Align(
          child: Container(
            child: TextField(
              maxLines: null,
              keyboardType: TextInputType.multiline,
              controller: widget.changesController,
              decoration: InputDecoration(
                  hintText:
                      "Things you would do different for a future attempt",
                  hintStyle: TextStyle(fontSize: 14),
                  prefixIcon: Icon(Icons.event_note)),
            ),
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ]),
    );
  }
}
