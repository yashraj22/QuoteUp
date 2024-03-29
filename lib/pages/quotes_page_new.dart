import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';

class Quote_Page extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _Quote_PageState createState() => _Quote_PageState();
}

class _Quote_PageState extends State<Quote_Page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuoteUp',
      theme: ThemeData(),
      home: QuotePage(title: 'QuoteUp'),
    );
  }
}

class QuotePage extends StatefulWidget {
  QuotePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  var url = "https://type.fit/api/quotes";
  var isPressed = false;
  //var url = "https://raw.githubusercontent.com/lukePeavey/quotable/master/data/sample/quotes.json";
  var data;
  var index = Constants.prefs?.getInt("index") ?? 0;
  @override
  void initState() {
    super.initState();
    fetchData();
    print(data);
  }

  fetchData() async {
    var res = await http.get(Uri.parse(url));
    data = jsonDecode(res.body);
    /* filter out data with null author name */
    /* source - https://stackoverflow.com/questions/55360386/how-to-filter-json-data-in-itembuilder */
    data.removeWhere((m) => m['author'] == null);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var Iconn = (isPressed) ? Icon(Icons.star) : Icon(Icons.star_border);
    return Scaffold(
        backgroundColor: HexColor("#1a1a2e"),
        appBar: AppBar(
          backgroundColor: HexColor("#16213e"),
          centerTitle: true,
          title: Text(this.widget.title, textAlign: TextAlign.center),
        ),
        body: data == null
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Container(
                    padding: EdgeInsets.fromLTRB(20, 35, 20, 0),
                    margin: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                        color: HexColor("#16213e"),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ]),
                    child: Center(
                        child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // SizedBox(
                                //   height: 25,
                                // ),
                                Text(
                                  //data[index]["content"],
                                  data[index]["text"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.white, //Hexcolor("#1a1a2e")
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  //data[index]["text"],
                                  data[index]["author"]
                                              .toString()
                                              .split(",")
                                              .length >
                                          1
                                      ? data[index]["author"]
                                          .toString()
                                          .split(",")[0]
                                      : "Unknown Author",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors.white, //Hexcolor("#16213e"),
                                      fontSize: 20),
                                  overflow: TextOverflow.visible,
                                ),
                                // SizedBox(
                                //   height: 50,
                                // ),
                                // Padding(padding: EdgeInsets.all(75)),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.navigate_before),
                                color: Colors.white, //Hexcolor("#1a1a2e"),
                                onPressed: () {
                                  setState(() {
                                    if (index > 0) {
                                      index--;
                                      Constants.prefs?.setInt("index", index);
                                    }
                                  });
                                }),
                            IconButton(
                              icon: Icon(Icons.content_copy),
                              color: Colors.white, //Hexcolor("#1a1a2e"),
                              //size: 25.0,
                              onPressed: () {
                                setState(() {
                                  Clipboard.setData(new ClipboardData(
                                      text:
                                          "${data[index]["content"]} - ${data[index]["author"].toString().split(",")[0]}"));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text("Quote Copied !"),
                                  ));
                                });
                              },
                            ),
                            // IconButton(
                            //     color: Colors.white,
                            //     icon: Iconn,
                            //     onPressed: () {
                            //       setState(() {
                            //         isPressed = !isPressed;
                            //       });
                            //     }),
                            IconButton(
                                icon: Icon(Icons.navigate_next),
                                color: Colors.white, //Hexcolor("#1a1a2e"),
                                onPressed: () {
                                  setState(() {
                                    index++;
                                    Constants.prefs?.setInt("index", index);
                                    if (index == data.length) {
                                      index = 0;
                                      Constants.prefs?.setInt("index", index);
                                      fetchData();
                                    }
                                  });
                                }),
                          ],
                        ),
                      ],
                    )))));
  }
}
