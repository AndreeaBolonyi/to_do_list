import 'package:to_do_list/domain/user.dart';
import 'package:to_do_list/repository/tasks_repository.dart';
import 'package:to_do_list/repository/users_repository.dart';

import 'domain/my_date.dart';
import 'domain/task.dart';

class Utils {
  static User currentUser = User(0, "", "", "", "");
  static UsersRepository usersRepo = UsersRepository();
  static TasksRepository tasksRepo = TasksRepository();
  static Task selectedTask = Task(0,"",MyDate(1,1,2021),MyDate(1,1,2021),0,[]);
}