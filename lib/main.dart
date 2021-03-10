import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Screens/splashScreen.dart';
import 'package:flutter_app/Screens/homeScreen.dart';
import 'package:flutter_app/Screens/allUsers.dart';
import 'package:flutter_app/Screens/bookmarkedUsers.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      title: 'Github Users',
      theme: ThemeData(
//          primaryColor: primaryColor,
//          accentColor: accentColor,
          primaryColor: Color(0xff000000),
          accentColor: Color(0xffffffff),
          backgroundColor: Colors.white),
      initialRoute: '/',
      themeMode: ThemeMode.light,
      routes: <String, WidgetBuilder>{
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/allUsers': (context) => AllUsers(),
        '/bookmarked': (context) => BookmarkedUsers(),
      },
    );
  }
}
