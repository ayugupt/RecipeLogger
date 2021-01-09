import 'package:flutter/material.dart';

import 'logInfo.dart';
import 'ads.dart';

class NewLog extends StatefulWidget {
  String dishName;
  int logNo;
  NewLog(this.dishName, this.logNo);
  NewLogState createState() => NewLogState();
}

class NewLogState extends State<NewLog> {
  final formKey = GlobalKey<FormState>();
  String title, day, month, year;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Scaffold(
        body: Container(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.orange,
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  child: Text(
                    "FILL IN THE DETAILS",
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Ubuntu",
                        fontWeight: FontWeight.bold),
                  ),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)),
                        prefixIcon: Icon(Icons.local_pizza),
                        filled: true,
                        labelText: "TITLE",
                        labelStyle: TextStyle(fontSize: 20)),
                    validator: (input) =>
                        input.length > 0 ? null : "Please enter the title",
                    onSaved: (input) => title = input,
                  ),
                  width: MediaQuery.of(context).size.width * 0.7,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Container(
                      child: TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            prefixIcon: Icon(Icons.date_range),
                            filled: true,
                            labelText: "DD",
                            labelStyle: TextStyle(fontSize: 15)),
                        validator: (input) =>
                            input.length > 0 ? null : "Please enter the day",
                        onSaved: (input) => day = input,
                        keyboardType: TextInputType.number,
                      ),
                      width: MediaQuery.of(context).size.width * 0.27,
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(
                                Icons.date_range,
                              ),
                              filled: true,
                              labelText: "MM",
                              labelStyle: TextStyle(fontSize: 15)),
                          validator: (input) => input.length > 0
                              ? null
                              : "Please enter the month",
                          onSaved: (input) => month = input,
                          keyboardType: TextInputType.number),
                      width: MediaQuery.of(context).size.width * 0.27,
                    ),
                    Container(
                      child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              prefixIcon: Icon(Icons.date_range),
                              filled: true,
                              labelText: "YYYY",
                              labelStyle: TextStyle(fontSize: 15)),
                          validator: (input) =>
                              input.length > 0 ? null : "Please enter the year",
                          onSaved: (input) => year = input,
                          keyboardType: TextInputType.number),
                      width: MediaQuery.of(context).size.width * 0.27,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: <Widget>[
                    ButtonTheme(
                      child: RaisedButton(
                        child: Text("Done"),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            if (Ads.bannerAd != null) {
                              await Ads.bannerAd.dispose();
                              Ads.bannerAd = null;
                            }
                            Navigator.push(context,
                                MaterialPageRoute(builder: (BuildContext c) {
                              return LogInfoPage(widget.dishName, title, day,
                                  month, year, widget.logNo);
                            }));
                          }
                        },
                        color: Colors.grey[300],
                        splashColor: Colors.orange,
                      ),
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      height: 40,
                    ),
                    ButtonTheme(
                        child: RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.grey[300],
                          splashColor: Colors.orange,
                        ),
                        minWidth: MediaQuery.of(context).size.width * 0.3,
                        height: 40)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                )
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
      ),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
