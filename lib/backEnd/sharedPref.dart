import 'package:shared_preferences/shared_preferences.dart';

class SavedData {
  setBookedUsers(List<String> users) async {
    print("savesharepref" + users.toString());
    final savedUser = await SharedPreferences.getInstance();
    await savedUser.setStringList('bookmarked', []);
    await savedUser.setStringList('bookmarked', users);
  }

  Future<List<String>> getBookedUsers() async {
    final savedUser = await SharedPreferences.getInstance();
    final name = savedUser.getStringList('bookmarked');
    if (name == null) {
      return null;
    } else
      print("sharedPrefPrint" + name.toString());
    return name;
  }
}
