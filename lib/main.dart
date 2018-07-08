import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:morii/models/Post.dart';

import 'package:morii/components/Timeline.dart';

final String accessToken = "ACCESS_TOKEN_HERE"; // TODO: Put this into an OAath flow

Future<List<Post>> fetchPost() async {
  final response =
      await http.get('https://photog.social/api/v1/timelines/public/?only_media=true&local=false&limit=40', headers: {
        "Authorization": "Bearer $accessToken"
      });
  final List<dynamic> responseJson = json.decode(response.body);

  return responseJson.map((post) {
    return new Post.fromJson(post);
  }).where((post) => post.mediaTypes == 'image' && !post.isSensitive).toList();
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final ThemeData lightTheme = new ThemeData(
        primaryColor: Colors.grey[50],
        primaryColorLight: Colors.white,
        primaryColorDark: Colors.grey[200],
        accentColor: Colors.black,
        brightness: Brightness.light,
        iconTheme: new IconThemeData(
          color: Colors.blueGrey[900]
        ),
        fontFamily: 'Source Sans Pro'
      );

  final ThemeData darkTheme = new ThemeData(
        primaryColor: Colors.blueGrey[800],
        primaryColorLight: Colors.blueGrey[700],
        primaryColorDark: Colors.blueGrey[900],
        accentColor: Colors.white,
        brightness: Brightness.dark,
        iconTheme: new IconThemeData(
          color: Colors.white
        )
      );
  
    final ThemeData oledTheme = new ThemeData(
        primaryColor: Colors.blueGrey[900],
        primaryColorLight: Colors.black,
        primaryColorDark: Colors.black,
        accentColor: Colors.white,
        brightness: Brightness.dark,
        iconTheme: new IconThemeData(
          color: Colors.white
        )
    );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'morii',
      theme: lightTheme,
      home: new MyHomePage()
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Timeline(posts: fetchPost())
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        hasNotch: true,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.menu), onPressed: () {},),
            IconButton(icon: Icon(Icons.favorite), onPressed: () {},),
            IconButton(icon: Icon(null), onPressed: null,),
            IconButton(icon: Icon(Icons.public), onPressed: () {},),
            IconButton(icon: Icon(Icons.person), onPressed: () {},),
          ],
        ),
      ),
      floatingActionButtonLocation: 
        FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        onPressed: (){},
        tooltip: 'New Post',
        child: new Icon(Icons.camera_alt),
        notchMargin: 4.0,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
