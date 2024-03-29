import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
    print(data);
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
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 300,
                    enlargeCenterPage: true,
                    viewportFraction: .8,
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index, realIDx) {
                    return Builder(builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white, //Hexcolor("#f4f4f4"),
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                blurRadius: 5,
                              )
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              data[index]["author"],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  color: HexColor("#1a1a2e")),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              data[index]["text"],
                              style: TextStyle(
                                  color: HexColor("#16213e"), fontSize: 15),
                              overflow: TextOverflow.visible,
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Icon(
                                  Icons.navigate_before,
                                  color: HexColor("#1a1a2e"),
                                  size: 35.0,
                                  semanticLabel:
                                      'Text to announce in accessibility modes',
                                ),
                                IconButton(
                                  icon: Icon(Icons.content_copy),
                                  color: HexColor("#1a1a2e"),
                                  //size: 25.0,
                                  onPressed: () {
                                    setState(() {
                                      Clipboard.setData(new ClipboardData(
                                          text:
                                              "${data[index]["text"]} - ${data[index]["author"]}"));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Quote Copied !"),
                                      ));
                                    });
                                  },
                                ),
                                Icon(
                                  Icons.navigate_next,
                                  color: HexColor("#1a1a2e"),
                                  size: 35.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
                  },
                ),
              ));
  }
}
