import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/allUsers.dart';
import 'package:flutter_app/Screens/bookmarkedUsers.dart';
import 'package:flutter_app/backEnd/sizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int currentIndex = 0;
  PageController pageController = new PageController();
  @override
  void dispose() {
    pageController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  SizeConfig screenSize;

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                      height: screenSize.screenHeight * 5,
                      child: Image.asset('images/media/logo.png')),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenSize.screenWidth * 5),
                  child: Text("Github Users",
                      style: TextStyle(
                          color: Colors.black,
                          textBaseline: TextBaseline.ideographic,
                          fontSize: screenSize.screenHeight * 2.5)),
                ),
              ],
            ),
            backgroundColor: Colors.white,
            elevation: 5,
          ),
          body: PageView(
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            controller: pageController,
            children: [AllUsers(), BookmarkedUsers()],
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              onTap: (page) {
                setState(() {
                  currentIndex = page;
                });
                pageController.jumpToPage(page);
              },
              currentIndex: currentIndex,
              selectedIconTheme: IconThemeData(color: Colors.black),
              unselectedIconTheme: IconThemeData(color: Colors.black),
              unselectedLabelStyle: TextStyle(color: Colors.white),
              backgroundColor: Colors.white,
              unselectedItemColor: Colors.black,
              items: [
                BottomNavigationBarItem(
                  icon: Container(
                    child: CircleAvatar(
                      radius: screenSize.screenHeight * 2.5,
                      backgroundColor:
                          currentIndex == 0 ? Colors.black : Colors.white,
                      child: Icon(
                        Icons.account_circle,
                        color: currentIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  label: "All Users",
                ),
                BottomNavigationBarItem(
                    icon: Container(
                      child: CircleAvatar(
                        radius: screenSize.screenHeight * 2.5,
                        backgroundColor:
                            currentIndex == 1 ? Colors.black : Colors.white,
                        child: Icon(
                          currentIndex == 1
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              currentIndex == 1 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    label: 'Bookmarked'),
              ]),
        ));
  }

  DateTime currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press back again to exit!");
      return Future.value(false);
    }
    return Future.value(true);
  }
}

class ActionInfo {
  final String id;
  final Icon icon;
  final String text;
  final Function func;

  const ActionInfo(
      {@required this.id,
      @required this.text,
      @required this.icon,
      @required this.func});
}
