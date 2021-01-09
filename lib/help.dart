import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Padding(
              child: Text(
                "Special feature - Custom Units",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  top: MediaQuery.of(context).size.height * 0.02),
            ),
            Padding(
              child: Text(
                "You can add your own spoons and utensils as units in addition to the standardized units like teaspoons and tablespoons. To make and view custom units you can go to \"Custom Units\" in the HomePage or when you are creating a new Log",
                style: TextStyle(fontSize: 17),
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  top: MediaQuery.of(context).size.height * 0.02),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset("assets/homeinfo.png"),
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                Container(
                  child: Image.asset("assets/customInfo.png"),
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),
            Padding(
              child: Text(
                "You can also add Custom Units by tapping on the \"Add\" option in the \"Unit\" DropDown Menu\nYou can also choose the \"N.A.\" option if you don't want to specify any unit",
                style: TextStyle(fontSize: 17),
              ),
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.02,
                  top: MediaQuery.of(context).size.height * 0.02),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Align(
                child: Container(
              child: Image.asset("assets/addOption.png"),
              width: MediaQuery.of(context).size.width * 0.4,
            )),
          ],
        ),
      ),
      appBar: AppBar(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(height: 50),
        color: Colors.orange,
      ),
    );
  }
}
