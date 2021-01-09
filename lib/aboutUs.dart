import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              child: Center(
                  child: Container(
                child: Image.asset("assets/recipeLog.png"),
              )),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02),
            ),
            Center(
              child: Text(
                "Developed by Gamet",
                style: TextStyle(fontSize: 20, fontFamily: "Ubuntu"),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Center(
              child: Text(
                "Send an Email on gametvgs123@gmail.com if you have a problem",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Ubuntu",
                ),
                textAlign: TextAlign.center,
              ),
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
