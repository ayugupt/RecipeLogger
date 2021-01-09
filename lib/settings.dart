import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  SharedPreferences prefs;

  bool isProcessing = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((p) {
      setState(() {
        prefs = p;
        isProcessing = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !isProcessing
          ? Container(
              child: ListView(
                children: <Widget>[
                  SwitchListTile(
                    title: Text("Imperial Units"),
                    value: prefs.getBool("Units") ?? false,
                    onChanged: (val) {
                      setState(() {
                        prefs.setBool("Units", val);
                      });
                    },
                  )
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
      appBar: AppBar(),
    );
  }
}
