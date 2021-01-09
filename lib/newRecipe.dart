import 'package:flutter/material.dart';
import 'main.dart';
import 'dish.dart';

class NewRecipe extends StatefulWidget {
  NewRecipeState createState() => NewRecipeState();
}

class NewRecipeState extends State<NewRecipe> {
  TextEditingController textFieldController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Container(
        child: Column(children: <Widget>[
          Align(
            child: Text(
              "Add a new dish",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            alignment: Alignment.topCenter,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            child: TextFormField(
              controller: textFieldController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  hintText: "Enter dish name",
                  filled: true,
                  fillColor: Colors.white),
            ),
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          SizedBox(
            height: 40,
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                child: Text("Done"),
                onPressed: () {
                  Dish.name = textFieldController.text;
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                child: Text("Cancel"),
                onPressed: () {
                  Dish.name = '';
                  Navigator.pop(context);
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          )
        ]),
        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.orange[500], Colors.orange[300]])),
      ),
      borderRadius: BorderRadius.circular(20), 
    );
  }
}
