import 'dart:convert' as convert;
import 'dart:developer';

import 'package:flutter_app/backEnd/sharedPref.dart';

List<User> bookedUsersLists = List<User>();

class User {
  String username;
  String photoUrl;
  bool bookmarked;
  int userId;
}

class LoadUsers {
  var decData;
  LoadUsers(this.decData);
  List<User> userList = List<User>();

  bool getBool(int id) {
    for (int j = 0; j < bookedUsersLists.length; j++) {
      if (bookedUsersLists[j].userId == id) {
        return true;
      }
    }
    return false;
  }

  Future<List<User>> getUser() async {
    BookMarked bookMarked = BookMarked();
    bookedUsersLists = await bookMarked.getBookedUsers();
    for (int i = 0; i < decData.length; i++) {
      User user = User();
      user.username = decData[i]['login'];
      user.photoUrl = decData[i]['avatar_url'];
      user.userId = decData[i]['id'];
      if (bookedUsersLists.length > 0) {
        user.bookmarked = getBool(user.userId);
      } else {
        user.bookmarked = false;
      }
      userList.add(user);
    }

    return userList;
  }
}

class BookMarked {
  BookMarked();
  SavedData savedData = SavedData();
  Future<List<User>> getBookedUsers() async {
    List<String> data = List<String>();
    data = await savedData.getBookedUsers();
    bookedUsersLists = [];
    if (data != null) {
      for (int i = 0; i < data.length; i++) {
        var d = convert.jsonDecode(data[i]);

        User user = User();
        user.username = d['username'].toString();
        user.photoUrl = d['photoUrl'].toString();
        user.userId = int.parse(d['userId']);
        user.bookmarked = d['bookmarked'] == 'true' ? true : false;
        bookedUsersLists.add(user);
      }
    } else {
      bookedUsersLists = [];
    }
    return bookedUsersLists;
  }

  Future<List<User>> addBookedUsers(User user) async {
    bookedUsersLists.add(user);
    await saveBookedUsers();
    return bookedUsersLists;
  }

  Future<List<User>> removeBookedUsers(User user) async {
    for (int i = 0; i < bookedUsersLists.length; i++) {
      print(bookedUsersLists[i].username);
      if (bookedUsersLists[i].userId == user.userId) {
        bookedUsersLists.remove(bookedUsersLists[i]);
      }
    }
    print(user.username);
    await saveBookedUsers();
    return bookedUsersLists;
  }

  Future<void> saveBookedUsers() async {
    List<String> data = List<String>();
    for (int i = 0; i < bookedUsersLists.length; i++) {
      Map<String, String> userMap = Map<String, String>();
      userMap.addAll({
        'username': bookedUsersLists[i].username,
        'photoUrl': bookedUsersLists[i].photoUrl,
        'userId': bookedUsersLists[i].userId.toString(),
        'bookmarked': bookedUsersLists[i].bookmarked.toString()
      });

      data.add(convert.jsonEncode(userMap));
    }
    savedData.setBookedUsers(data);
  }
}
