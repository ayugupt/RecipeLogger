import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CustomUnit extends StatefulWidget {
  double top, bottom, left, right;
  CustomUnit({this.top, this.bottom, this.left, this.right});
  CustomUnitState createState() => CustomUnitState();
}

class CustomUnitState extends State<CustomUnit> {
  final controller = TextEditingController();

  File _image;

  String errorMsg = "";

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Scaffold(
        body: Stack(children: <Widget>[
          Container(
            color: Colors.orange,
          ),
          Center(
              child: Container(
                  child: Column(
                    children: <Widget>[
                      Align(
                          child: Container(
                        child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Enter unit name",
                            )),
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      )),
                      InkWell(
                        child: Container(
                          child: _image == null
                              ? Center(
                                  child: Icon(Icons.add_a_photo),
                                )
                              : Image.file(
                                  _image,
                                  fit: BoxFit.contain,
                                ),
                          color: Colors.orange[200],
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          height: 100,
                        ),
                        onTap: () async {
                          try {
                            await getImage();
                          } catch (e) {
                            print("Error: ${e.message}");
                          }
                          //print("hello");
                        },
                      ),
                      Row(
                        children: <Widget>[
                          FlatButton(
                              child: Text("Create Unit"),
                              onPressed: () async {
                                setState(() {
                                  errorMsg = "";
                                });
                                if (controller.text != "" && _image != null) {
                                  //try {
                                  final directory =
                                      await getApplicationDocumentsDirectory();
                                  bool exists =
                                      await Directory("${directory.path}/Units")
                                          .exists();
                                  if (!exists) {
                                    await Directory("${directory.path}/Units")
                                        .create();
                                  }

                                  String pathTextFile =
                                      "${directory.path}/Units/Units.txt";
                                  String pathImages =
                                      "${directory.path}/Units/${controller.text}.png";

                                  bool txtFileCreated =
                                      await File(pathTextFile).exists();
                                  File txtFile;
                                  if (!txtFileCreated) {
                                    txtFile = await File(pathTextFile).create();
                                  } else {
                                    txtFile = File(pathTextFile);
                                  }

                                  await txtFile.writeAsString("${controller.text}^",
                                      mode: FileMode.append);
                                  await _image.copy(pathImages);
                                  Navigator.pop(context);
                                  /*} catch (e) {
                                    setState(() {
                                      errorMsg = e.message;
                                    });
                                  }*/
                                } else {
                                  setState(() {
                                    errorMsg = "Name or Image not given";
                                  });
                                }
                              }),
                          FlatButton(
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      Center(
                          child: Text(
                        errorMsg,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ))
                    ],
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100]),
                  margin: EdgeInsets.only(
                      bottom: widget.bottom,
                      top: widget.top,
                      left: widget.left,
                      right: widget.right)))
        ]),
        resizeToAvoidBottomPadding: false,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
