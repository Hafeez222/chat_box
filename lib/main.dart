import 'dart:convert' ;
import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import "package:intl/intl.dart";
void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  void response(query) async {
    final String json = _getJson();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: json).build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    setState(() {
      messsages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
    print("Response............................ .....");
    print(aiResponse);
    print(aiResponse.getListMessage()[0]["text"]["text"][0].toString());
  }
  final messageInsert = TextEditingController();
  List<Map> messsages = List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJson();
  }

  _getJson() async {
    await rootBundle.loadString('assets/json/aa.json');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff269de8),

        title:

        Center(child: Text("ChatBox")),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    itemCount: messsages.length,
                    itemBuilder: (context, index) => chat(
                        messsages[index]["message"].toString(),
                        messsages[index]["data"]))),
            SizedBox(
              height: 20,
            ),
            Container(
              child: ListTile(
                  title: Container(
                    margin: EdgeInsets.only(top: 4),
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.black12,
                    ),
                    padding: EdgeInsets.only(left: 20),
                    child: TextFormField(
                      maxLines: 10,
                      controller: messageInsert,
                      decoration: InputDecoration(
                        hintText: "Enter a Message...",
                        hintStyle: TextStyle(color: Colors.black26),
                        border: InputBorder.none,
                       // focusedBorder: InputBorder.none,
                       // enabledBorder: InputBorder.none,
                       // errorBorder: InputBorder.none,
                       // disabledBorder: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                      onChanged: (value) {},
                    ),
                  ),
                  trailing: Container(
                    height: 39,
                    width: 40,
                    decoration:BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,) ,
                    child: Padding(
                      padding: const EdgeInsets.symmetric( horizontal: 1.0,vertical: 0.0),
                      child: IconButton(
                          icon:Icon(
                              Icons.send,
                              size: 26.0,
                              color: Colors.white,
                            ),
                          onPressed: () {
                            if (messageInsert.text.isEmpty) {
                              print("empty message");
                            }else{
                              setState(() {
                                messsages.insert(
                                    0, {"data": 1, "message": messageInsert.text});
                              });
                              response(messageInsert.text);
                              messageInsert.clear();
                            }
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          }),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 32.0,
            )
          ],
        ),
      ),
    );
  }
  Widget chat(String message, int data) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment:
            data == 1 ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          data == 0
              ? Container(
                  height: 60,
                  width: 60,
                )
              : Container(),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Bubble(
                radius: Radius.circular(10.0),
                color: data == 0
                    ? Color.fromRGBO(23, 157, 139, 1)
                    : Colors.blue,
                elevation: 0.0,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        width: 10.0,
                      ),
                      Flexible(
                       child: Container(
                          constraints: BoxConstraints(maxWidth: 200),
                          child: Text(
                          message, style: TextStyle(
                                color: Colors.black, fontWeight: FontWeight.w100, ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
          data == 1
              ? Container(
                  height: 30,
                  width: 30,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/default.jpg"),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }}