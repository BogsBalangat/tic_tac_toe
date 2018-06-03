import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tic_tac_toe/drawing/constants.dart';
import 'package:tic_tac_toe/drawing/hash.dart';
import 'package:tic_tac_toe/drawing/o.dart';
import 'package:tic_tac_toe/drawing/x.dart';

/*
* Fastest implementation of tic tac toe
* */

void main() => runApp(new HomePage());

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(title: new Text("Tic Tac Toe")),
            body: TicTacToe(),

        )
    );
  }
}

class TicTacToe extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => TicTacToeState();
}
class TicTacToeState extends State<TicTacToe>{

  Map<String, String> ticTacMap = Map();
  bool isO = false;
  bool showHash = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    initializeTicTacMap();
  }

  void initializeTicTacMap() async {
    setState((){
      ticTacMap = new Map();
      for(int col = 1; col < 4; col++){
        for(int row = 1; row < 4; row++){
          ticTacMap[getElementKey(col, row)] =  blank;
        }
      }
      showHash = false;
      Future.delayed(new Duration(milliseconds: 100), (){
        setState(() {
          showHash = true;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(child: Text("Tic Tac Toe Game", style:
            TextStyle(fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.deepOrange)))
          ),
          Expanded(
            flex: 2,
            child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                            flex:  1,
                            child: showHash ? Hash() : Container())
                      ],
                    )
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        generateTicTacTowRow(1),
                        generateTicTacTowRow(2),
                        generateTicTacTowRow(3),
                      ],
                    )
                  )
                ]
            )
          ),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                      child:  RaisedButton(
                          child: Text("New Game", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                          onPressed: (){
                            initializeTicTacMap();
                          },
                          color: Colors.green,
                      )
                  ),
                  Center(child: Text("By Bogs Balangat"))
                ]
              )
          ),
        ],
      )
      );
  }

  Widget generateTicTacTowRow(int row){
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          getTicTacBox(1, row),
          getTicTacBox(2, row),
          getTicTacBox(3, row)
        ],
      )
    );
  }

  Widget getTicTacBox(int col, int row){
    String element = col.toString() + ":" + row.toString();
    return (ticTacMap[element] == o ||  ticTacMap[element] == x) ?
      (getXorO(element)) :
      (new Container(
          width: ELEMENT_SIZE,
          height: ELEMENT_SIZE,
          child: new Center(child:
          FlatButton(
            onPressed: (){
              setState(() {
                ticTacMap[element] = isO ? o : x;
                isO = !isO;
              });
              validateTicTacToeMap();
            },
            child: Container(),
      ))));
  }

  Widget getXorO(String element){
    if(ticTacMap[element] == o){
      return new X();
    } else {
      return new O();
    }
  }

  void validateTicTacToeMap() {
    Text title;
    Text message;
    if(isTicTacToeComplete()){
      title = Text("Oops!");
      message = Text("No one wins!, play again");
      showDialogMessage(title, message);
      return;
    }
    if(doesAPlayerWins()){
      title = Text("Congratulations!");
      message = isO ? Text("Player 'O' wins!"): Text("Player 'X' wins!");
      showDialogMessage(title, message);
    }
  }

  bool isTicTacToeComplete(){
    bool isComplete = true;
    ticTacMap.forEach((key,value){
      if(value == blank){
        isComplete = false;
      }
    });
    return isComplete;
  }

  bool doesAPlayerWins(){
    bool win = false;
    win = isAnyRowWins()
      || isAnyColumnWins()
      || validateX(false)
      || validateX(true);
    return win;
  }

  bool isAnyRowWins(){
    for(int i = 1; i < 4; i ++){
      if(doesRowOrColumnPatternWins(i, true)){
        return true;
      }
    }
    return false;
  }

  bool isAnyColumnWins(){
    for(int i = 1; i < 4; i ++){
      if(doesRowOrColumnPatternWins(i, false)){
        return true;
      }
    }
    return false;
  }



  bool doesRowOrColumnPatternWins(int index, bool isRow){
    bool win = false;
    Set<String> combinations = new Set();
    for(int i=1;i < 4;i++){
      String element = isRow ? getElementKey(index, i) : getElementKey(i, index) ;
      combinations.add(ticTacMap[element]);
    }
    if(combinations.length == 1 && !combinations.contains(blank)){
      win = true;
    }
    return win;
  }

  bool validateX(bool isReverse){
    bool win = false;
    Set<String> combinations = new Set();
    for(int i = 1; i < 4; i++){
      int col = isReverse ? (4 - i) : i;
      combinations.add(ticTacMap[getElementKey(col, i)]);
    }
    if(combinations.length == 1 && !combinations.contains(blank)){
      win = true;
    }
    return win;
  }

  void showDialogMessage(Text title, Text message) async {
    await showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
        new AlertDialog(
          title: title,
          content: message,
          actions: <Widget>[
            new FlatButton(
              child: new Text("Play again"),
              onPressed: () {
                initializeTicTacMap();
                Navigator.pop(context);
              },
            )
          ]
        )
    );
  }

  String getElementKey(int col, int row){
    return col.toString() + ":" + row.toString();
  }

  final String blank = "";
  final String o = "o";
  final String x = "x";
}



