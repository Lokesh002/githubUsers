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

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  SizeConfig screenSize;
  var _formKey = new GlobalKey<FormState>();
  var searchController = TextEditingController();
  String query = '';
  StackPage<int> firstpageStack = StackPage<int>();
  @override
  void dispose() {
    searchController.clear();
    searchController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  BookMarked bookmarkedUsers = BookMarked();

  bool isReady = false;
  List<User> fullUserList = List<User>();

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
          : Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  height: screenSize.screenHeight * 63,
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
                              await bookmarkedUsers
                                  .addBookedUsers(userList[index]);
                            } else {
                              userList[index].bookmarked = false;
                              await bookmarkedUsers
                                  .removeBookedUsers(userList[index]);
                            }

                            setState(() {});
                          },
                        );
                      },
                      itemCount: userList.length,
                      padding: EdgeInsets.fromLTRB(
                          0,
                          screenSize.screenHeight * 2.5,
                          0,
                          screenSize.screenHeight * 7)),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenSize.screenHeight * 1),
                  child: Container(
                    height: screenSize.screenHeight * 7,
                    width: screenSize.screenWidth * 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            isReady = false;
                            getPreviousPage();
                          },
                          child: Material(
                            child: Center(
                              child: Container(
                                  height: screenSize.screenHeight * 5,
                                  width: screenSize.screenWidth * 27,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.only(
                                        left: screenSize.screenWidth * 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.arrow_left),
                                        Text(
                                          "Prev",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ))),
                            ),
                            elevation: 5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isReady = false;
                              getNextPage();
                            });
                          },
                          child: Material(
                            child: Center(
                              child: Container(
                                  height: screenSize.screenHeight * 5,
                                  width: screenSize.screenWidth * 27,
                                  child: Center(
                                      child: Padding(
                                    padding: EdgeInsets.only(
                                        right: screenSize.screenWidth * 5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Next",
                                          textAlign: TextAlign.center,
                                        ),
                                        Icon(Icons.arrow_right),
                                      ],
                                    ),
                                  ))),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
    firstpageStack.clear();
    Networking networking = Networking();
    http.Response response = await networking
        .getData('https://api.github.com/users?per_page=30&since=0');
    if (response != null) {
      var responseBody = convert.jsonDecode(response.body);

      LoadUsers users = LoadUsers(responseBody);
      userList = await users.getUser();
      fullUserList = userList;
      //page nav data
      firstUserId = userList[0].userId;

      firstpageStack.push(firstUserId);
      firstpageStack.push(userList[userList.length - 1].userId);
    } else {
      userList = [];
    }

    print(firstpageStack.getAll().toString());
    isReady = true;
    setState(() {});
  }

  void currentData() async {
    Networking networking = Networking();
    firstpageStack.pop();
    pageFirstUserId = firstpageStack.getAll().length > 1
        ? firstpageStack.getHead()
        : firstpageStack.getHead() - 1;
    http.Response response = await networking.getData(
        'https://api.github.com/users?per_page=30&since=$pageFirstUserId');
    if (response != null) {
      var responseBody = convert.jsonDecode(response.body);

      LoadUsers users = LoadUsers(responseBody);
      userList = await users.getUser();

      //page nav data

      firstpageStack.push(userList[userList.length - 1].userId);
    } else {
      userList = [];
    }

    print(firstpageStack.getAll().toString());
    isReady = true;
    setState(() {});
  }

  void getNextPage() async {
    pageLastUserId = firstpageStack.getHead();
    Networking networking = Networking();
    print('going to id $pageLastUserId');
    http.Response response = await networking.getData(
        'https://api.github.com/users?per_page=30&since=$pageLastUserId');
    if (response != null) {
      LoadUsers users = LoadUsers(convert.jsonDecode(response.body));
      userList = await users.getUser();
      fullUserList = userList;
      firstpageStack.push(userList[userList.length - 1].userId);
    } else {
      userList = [];
    }
    isReady = true;
    setState(() {});
    print(firstpageStack.getAll().toString());
  }

  void getPreviousPage() async {
    pageFirstUserId = firstpageStack.getHead();

    if (firstpageStack.getAll().length > 2) {
      firstpageStack.pop();
      firstpageStack.pop();

      print('going to id ${firstpageStack.getHead()}');

      Networking networking = Networking();
      http.Response response = await networking.getData(
          'https://api.github.com/users?per_page=30&since=${firstpageStack.getAll().length > 1 ? firstpageStack.getHead() : firstpageStack.getHead() - 1}');
      if (response != null) {
        LoadUsers users = LoadUsers(convert.jsonDecode(response.body));
        userList = await users.getUser();
        fullUserList = userList;
        firstpageStack.push(userList[userList.length - 1].userId);
      } else {
        userList = [];
      }
    } else {
      Fluttertoast.showToast(msg: "Already on page 1");
    }
    isReady = true;
    setState(() {});
    print(firstpageStack.getAll().toString());
  }

  getFilteredUsers() {
    List<User> newUserList = List<User>();
    for (int i = 0; i < fullUserList.length; i++) {
      if (fullUserList[i].username.contains(query)) {
        newUserList.add(fullUserList[i]);
      }
    }
    userList = newUserList;
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
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.screenHeight * 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.screenWidth * 2,
                    vertical: screenSize.screenHeight * 2),
                child: Form(
                  key: _formKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenSize.screenWidth * 80,
                        child: TextFormField(
                          minLines: 1,

                          maxLines: 5,
                          validator: (val) =>
                              val.isEmpty ? 'Please enter query first.' : null,
                          controller: searchController,
                          keyboardType: TextInputType.text,
                          textAlign: TextAlign.start,
                          onChanged: (query) {
                            this.query = query;
                            setState(() {
                              getFilteredUsers();
                            });
                            setState(() {});
                          },
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: screenSize.screenHeight * 2),
                          // focusNode: focusNode,

                          decoration: InputDecoration(
                            hintText: "Search",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    screenSize.screenHeight * 2)),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(left: screenSize.screenWidth * 3),
                        child: GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isReady = false;
                              });
                            }
                          },
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(
                              screenSize.screenHeight * 2.8,
                            ),
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              radius: screenSize.screenHeight * 3,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: screenSize.screenHeight * 2.8,
                                child: Icon(
                                  Icons.search,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Visibility(
                  visible: true,
                  child: RefreshIndicator(
                    child: getScreen(),
                    color: Colors.black,
                    onRefresh: _getData,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getData() async {
    setState(() {
      currentData();
    });
  }
}
