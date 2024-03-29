import 'package:flutter/material.dart';
import 'package:flutter_app/pages/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'pages/quotes_page.dart';
import 'pages/quotes_page_new.dart';
import 'package:hexcolor/hexcolor.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Constants.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuoteUp',
        theme: ThemeData(),
        home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#1a1a2e"),
      appBar: AppBar(
        backgroundColor: HexColor("#16213e"),
        title: Text('QuoteUp'),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
              color: Colors.white,
              child: Text("Quotes"),
              textColor: HexColor("#1a1a2e"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quote_Page()),
                );
              }),
          MaterialButton(
              color: Colors.white,
              child: Text("About"),
              textColor: HexColor("#1a1a2e"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text("About"),
                    titleTextStyle: TextStyle(
                      color: Colors.blue,
                    ),
                    contentTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    backgroundColor: HexColor("#1a1a2e"),
                    content: Text(
                      "This App is Developed by Yashraj22",
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: Text("Back"),
                      ),
                    ],
                  ),
                );
              }),
          // MaterialButton(
          //   color: Colors.white,
          //   textColor: HexColor("#1a1a2e"),
          //   onPressed: () {},
          //   child: Text("Favourites"),
          // ),
        ],
      )),
    );
  }
}
