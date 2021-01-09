import 'package:flutter/material.dart';

class Steps extends StatefulWidget {
  List<TextEditingController> stepControllers =
      new List<TextEditingController>();

  List<String> returnSteps() {
    List<String> list = new List<String>();
    for (int i = 0; i < stepControllers.length; i++) {
      list.add(stepControllers[i].text);
    }
    return list;
  }

  int count = 1;
  final listKey = GlobalKey<AnimatedListState>();

  StepsState createState() => StepsState();
}

class StepsState extends State<Steps> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    /*for (int i = 0; i < widget.stepControllers.length; i++) {
      widget.stepControllers[i].dispose();
    }*/
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stepControllers.length < widget.count) {
      widget.stepControllers.add(TextEditingController());
    } else if (widget.stepControllers.length > widget.count) {
      widget.stepControllers.removeLast();
    }
    return Container(
      child: AnimatedList(
        key: widget.listKey,
        initialItemCount: widget.count + 1,
        itemBuilder: (BuildContext c, index, animation) {
          if (index == 0) {
            return Padding(
              child: Center(
                child: Text(
                  "PROCEDURE",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              padding: EdgeInsets.only(top: 20),
            );
          } else {
            animation.addListener(() {
              setState(() {});
            });
            return Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  "$index",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20 * animation.value),
                ),
                SizedBox(
                  width: 10,
                ),
                Align(
                    child: Container(
                  child: TextField(
                    controller: widget.stepControllers[index - 1],
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                  width:
                      MediaQuery.of(context).size.width * animation.value * 0.6,
                )),
                index == widget.count
                    ? Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                widget.count++;
                                widget.listKey.currentState.insertItem(
                                    widget.count,
                                    duration: Duration(seconds: 1));
                              });
                            },
                          ),
                          index != 1
                              ? IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    setState(() {
                                      widget.count--;
                                      widget.listKey.currentState.removeItem(
                                          widget.count, (c, animation) {
                                        return SizedBox(
                                          width: 0,
                                          height: 0,
                                        );
                                      });
                                    });
                                  },
                                )
                              : SizedBox(
                                  width: 0,
                                  height: 0,
                                )
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      )
                    : SizedBox(
                        width: 0,
                        height: 0,
                      )
              ],
            );
          }
        },
      ),
    );
  }
}
