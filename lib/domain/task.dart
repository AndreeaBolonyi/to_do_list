import 'package:to_do_list/domain/user.dart';
import 'package:to_do_list/domain/my_date.dart';

class Task {
  int id = 0;
  String title = "";
  MyDate deadline = MyDate(1,1,2021);
  MyDate created = MyDate(1,1,2021);
  int priority = 0;
  List<User> users = <User>[];
  
  Task(int i, String t, MyDate d, MyDate c, int p, List<User> u) {
    id = i;
    title = t;
    deadline = d;
    created = c;
    priority = p;
    users = u;
  }

  bool containsUser(User user) {
    for (User u in users) {
      if(u.id == user.id) {
        return true;
      }
    }
    return false;
  }
  @override
  String toString() {
    return "${id.toString()} $title ${deadline.toString()} ${created.toString()} ${priority.toString()} ${users.length}";
  }
}