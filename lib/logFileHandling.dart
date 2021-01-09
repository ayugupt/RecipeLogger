import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:convert';

class LogFileHandling {
  List<String> ingredients;
  List<String> ingredientAmounts;
  List<String> amountUnit;
  List<String> steps;
  String prepTime;
  String cookTime;
  String totalTime;
  String servingSize;
  double rating;
  String description;
  String changes;
  File img1;
  File img2;
  File img3;

  LogFileHandling(
      {this.ingredients,
      this.ingredientAmounts,
      this.amountUnit,
      this.steps,
      this.prepTime,
      this.cookTime,
      this.totalTime,
      this.servingSize,
      this.rating,
      this.description,
      this.changes,
      this.img1,
      this.img2,
      this.img3});

  Future<void> writeLogToDisk(String dishName, int logNo, String logTitle,
      String day, String month, String year) async {
    Map<String, dynamic> logMap = new Map<String, dynamic>();
    logMap["Ingredients"] = ingredients;
    logMap["IngredientAmounts"] = ingredientAmounts;
    logMap["AmountUnits"] = amountUnit;
    logMap["Steps"] = steps;
    logMap["PrepTime"] = prepTime;
    logMap["CookTime"] = cookTime;
    logMap["TotalTime"] = totalTime;
    logMap["ServingSize"] = servingSize;
    logMap["Rating"] = rating;
    logMap["Description"] = description;
    logMap["Changes"] = changes;
    logMap["Title"] = logTitle;
    logMap["Day"] = day;
    logMap["Month"] = month;
    logMap["Year"] = year;

    Map<String, dynamic> logs = new Map<String, dynamic>();

    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    await Directory(path).create(recursive: true);
    bool exists = await File("$path/Logs$dishName.json").exists();
    File dataFile;
    if (!exists) {
      dataFile = await File("$path/Logs$dishName.json").create();
      logs["Log$logNo"] = logMap;
      String dataString = jsonEncode(logs);
      await dataFile.writeAsString(dataString);
    } else {
      dataFile = File("$path/Logs$dishName.json");
      String prevData = await dataFile.readAsString();
      logs = jsonDecode(prevData);
      logs["Log$logNo"] = logMap;
      String dataString = jsonEncode(logs);
      await dataFile.writeAsString(dataString);
    }
    if (img1 != null) {
      await img1.copy("$path/${logNo}image1.png");
    }
    if (img2 != null) {
      await img2.copy("$path/${logNo}image2.png");
    }
    if (img3 != null) {
      await img3.copy("$path/${logNo}image3.png");
    }
  }

  Future<Map<String, dynamic>> readLogFile(String dishName) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    bool exists = await File("$path/Logs$dishName.json").exists();
    if (!exists) {
      return null;
    } else {
      File file = File("$path/Logs$dishName.json");
      String data = await file.readAsString();
      Map<String, dynamic> dataMap = jsonDecode(data);
      return dataMap;
    }
  }

  Future<List<File>> returnFirstImage(String dishName, int noOfLogs) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";

    List<File> images = new List<File>();
    for (int i = 1; i <= noOfLogs; i++) {
      if (await File("$path/${i}image1.png").exists()) {
        images.add(File("$path/${i}image1.png"));
      } else if (await File("$path/${i}image2.png").exists()) {
        images.add(File("$path/${i}image2.png"));
      } else {
        images.add(File("$path/${i}image3.png"));
      }
    }
    return images;
  }

  Future<List<File>> returnAllImages(String dishName, int logNo) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    List<File> images = new List<File>();
    bool img1Exists = await File("$path/${logNo}image1.png").exists();
    bool img2Exists = await File("$path/${logNo}image2.png").exists();
    bool img3Exists = await File("$path/${logNo}image3.png").exists();
    if (img1Exists) {
      images.add(File("$path/${logNo}image1.png"));
    }
    if (img2Exists) {
      images.add(File("$path/${logNo}image2.png"));
    }
    if (img3Exists) {
      images.add(File("$path/${logNo}image3.png"));
    }
    return images;
  }
}

class DishFileHandling {
  String name;
  DishFileHandling({this.name});

  Future<void> writeDishFile() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes";
    bool exists = await Directory(path).exists();
    if (!exists) {
      await Directory(path).create();
    }
    await File("$path/DishNames.txt")
        .writeAsString("$name^", mode: FileMode.append);
  }

  Future<List<String>> readDishFile() async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes";
    bool exists = await File("$path/DishNames.txt").exists();
    if (!exists) {
      return null;
    } else {
      String data = await File("$path/DishNames.txt").readAsString();
      List<String> names = data.split("^");
      for (int i = 0; i < names.length; i++) {
        if (names[i] == '') {
          names.removeAt(i);
        }
      }
      return names;
    }
  }

  Future<void> deleteDishAndLogs(String dishName) async {
    final dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    bool exists = await Directory("$path").exists();
    if (exists) {
      await Directory("$path").delete(recursive: true);
      //await File("$path/Logs$dishName.json").delete();

    }
    String dishPath = "${dir.path}/Dishes";
    File file = File("$dishPath/DishNames.txt");
    String data = await file.readAsString();
    List<String> names = data.split("^");
    data = '';
    for (int i = 0; i < names.length; i++) {
      if (names[i] != '' && names[i] != dishName) {
        data = "${data}${names[i]}^";
      }
    }
    await file.writeAsString(data);
  }
}

class LogBookMark {
  Future<void> markLog(String dishName, int logNo) async {
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    await File("$path/Bookmarked.txt")
        .writeAsString("$logNo ", mode: FileMode.append);
  }

  Future<List<String>> getMarks(String dishName) async {
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    bool exists = await File("$path/Bookmarked.txt").exists();
    if (exists) {
      String data = await File("$path/Bookmarked.txt").readAsString();
      List<String> marked = data.split(" ");
      marked.removeLast();
      //print(marked);
      return marked;
    } else {
      return null;
    }
  }

  Future<void> removeMark(String dishName, int logNo) async {
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}/Dishes/$dishName";
    String data = await File("$path/Bookmarked.txt").readAsString();
    List<String> marked = data.split(" ");
    for (int j = 0; j < marked.length; j++) {
      if (marked[j] == '') {
        marked.removeAt(j);
      }
    }
    data = '';
    for (int i = 0; i < marked.length; i++) {
      if (int.parse(marked[i]) != logNo) {
        data = data + "${marked[i]} ";
      }
    }

    await File("$path/Bookmarked.txt").writeAsString(data);
  }
}
/*
class SettingsData {
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}";
    String data = jsonEncode(settings);
    await File("$path/Settings.json").writeAsString(data);
  }

  Future<Map<String, dynamic>> returnSettings() async {
    var dir = await getApplicationDocumentsDirectory();
    String path = "${dir.path}";
    bool exists = await File("$path/Settings.json").exists();
    if (exists) {
      String data = await File("$path/Settings.json").readAsString();
      Map<String, dynamic> map = jsonDecode(data);
      return map;
    } else if (!exists) {
      return null;
    }
  }
}
*/