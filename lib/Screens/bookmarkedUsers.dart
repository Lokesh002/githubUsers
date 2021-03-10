import 'dart:async';
import 'dart:developer';
import 'package:flutter_app/Components/reusableUserCard.dart';
import 'package:flutter_app/backEnd/stackPageNavigator.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_app/backEnd/networking.dart';
import 'package:flutter_app/backEnd/user.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:flutter_app/backEnd/sizeConfig.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkedUsers extends StatefulWidget {
  @override
  _BookmarkedUsersState createState() => _BookmarkedUsersState();
}

class _BookmarkedUsersState extends State<BookmarkedUsers> {
  SizeConfig screenSize;
  var _formKey = new GlobalKey<FormState>();
  String query = '';
  StackPage<int> firstpageStack = StackPage<int>();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  BookMarked bookedUsers = BookMarked();
  bool isReady = false;

  Widget getScreen() {
    if (!isReady) {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenSize.screenHeight * 5),
            child: SpinKitWanderingCubes(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              size: 100.0,
            ),
          ),
        ],
      );
    } else {
      return (userList.length == 0
          ? Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                  Container(
                    height: screenSize.screenHeight * 20,
                    child: SvgPicture.asset('svg/noCourses.svg',
                        semanticsLabel: 'A red up arrow'),
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 5,
                  ),
                  Text(
                    "No Users Present",
                  ),
                  SizedBox(
                    height: screenSize.screenHeight * 10,
                  ),
                ],
              ),
            )
          : Container(
              height: screenSize.screenHeight * 90,
              width: screenSize.screenWidth * 100,
              child: ListView.builder(
                  itemBuilder: (BuildContext cntxt, int index) {
                    return ReusableUserCard(
                      userName: userList[index].username,
                      image: userList[index].photoUrl,
                      bookmarked: userList[index].bookmarked,
                      onTap: () async {
                        if (userList[index].bookmarked == false) {
                          userList[index].bookmarked = true;
                          await bookedUsers.addBookedUsers(userList[index]);
                        } else {
                          userList[index].bookmarked = false;
                          await bookedUsers.removeBookedUsers(userList[index]);
                        }

                        setState(() {});
                      },
                    );
                  },
                  itemCount: userList.length,
                  padding: EdgeInsets.fromLTRB(0, screenSize.screenHeight * 2.5,
                      0, screenSize.screenHeight * 7)),
            ));
    }
  }

  List<User> userList = List<User>();
  String previousListUrl;
  int lastUserId;
  int firstUserId;
  int pageFirstUserId;
  int pageLastUserId;

  String nextListUrl;
  void getAllUserData() async {
    var a = bookedUsersLists;

    if (a != null) {
      userList = a;
    } else {
      userList = [];
    }

    isReady = true;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUserData();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(child: getScreen()),
      ),
    );
  }
}
