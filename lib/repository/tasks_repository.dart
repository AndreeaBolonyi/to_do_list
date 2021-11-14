import 'dart:developer';
import 'package:rxdart/rxdart.dart';

import 'package:to_do_list/domain/my_date.dart';
import 'package:to_do_list/domain/task.dart';
import 'package:to_do_list/domain/user.dart';
import 'package:to_do_list/utils.dart';

class TasksRepository {
  late BehaviorSubject<List<Task>> _tasks;
  List<Task> allTasks = [];

  TasksRepository() {
    allTasks.add(Task(1, "MA lab", MyDate(20, 11, 2021), MyDate(10, 11, 2021), 2, [
      User(1, "Andreea Bolonyi", "AndreeaBolonyi", "andreea@yahoo.com",
          "andreea")
    ]));
    allTasks.add(Task(2, "PPD lab", MyDate(19, 11, 2021), MyDate(9, 11, 2021), 1, [
      User(1, "Andreea Bolonyi", "AndreeaBolonyi", "andreea@yahoo.com",
          "andreea")
    ]));
    allTasks.add(Task(3, "LFTC lab", MyDate(19, 11, 2021), MyDate(15, 11, 2021), 1,
        [
          User(1, "Andreea Bolonyi", "AndreeaBolonyi", "andreea@yahoo.com",
              "andreea")
        ]));
    allTasks.add(Task(
        4, "MIRPR lab", MyDate(26, 11, 2021), MyDate(11, 11, 2021), 1, [
      User(2, "Flavius Burduleanu", "FlaviusB", "@flavius@yahoo.com", "flavius")
    ]));

    initTasks();

    _tasks.listen((value) {
      log("tasks repo: listen method start");
      for(Task task in value) {
        log(task.toString());
      }
      log("tasks repo: listen method end");
    });
  }

  Stream<List<Task>> get tasksForCurrentUser => _tasks;

  List<Task> getAllForCurrentUser() {
    List<Task> newTasks = [];

    for (Task task in allTasks) {
      if (task.containsUser(Utils.currentUser)) {
        newTasks.add(task);
      }
    }

    log("tasks repo -> size of all tasks is ${allTasks.length}");
    log("tasks repo -> size of tasks for current user is ${newTasks.length}");

    return newTasks;
  }

  void initTasks() {
    List<Task> tasksForCurrentUser = getAllForCurrentUser();
    _tasks = BehaviorSubject.seeded(tasksForCurrentUser);
  }

  bool add(Task task) {
    String errors = validateTask(task);
    if (errors != "") {
      log("tasksRepo add errors: $errors");
      throw Exception(errors);
    }

    log("tasksRepo: tasks size before add: ${_tasks.stream.value}");
    int nextId = getNextId();

    if (nextId != -1) {
      task.id = nextId;
      _tasks.stream.value.add(task);
      log("tasksRepo: tasks size after add: ${_tasks.stream.value}");
      return true;
    }

    return false;
  }

  bool update(Task task) {
    String errors = validateTask(task);
    if (errors != "") {
      log("tasksRepo update errors: $errors");
      throw Exception(errors);
    }

    Utils.selectedTask =
        Task(0, "", MyDate(1, 1, 2021), MyDate(1, 1, 2021), 0, []);
    for (Task t in _tasks.stream.value) {
      if (t.id == task.id) {
        t.created = task.created;
        t.deadline = task.deadline;
        t.priority = task.priority;
        t.title = task.title;
        t.users = task.users;
        return true;
      }
    }

    return false;
  }

  bool delete(int taskId) {
    Utils.selectedTask =
        Task(0, "", MyDate(1, 1, 2021), MyDate(1, 1, 2021), 0, []);
    log("tasksRepo: tasks size before delete: ${_tasks.stream.value.length}");
    log("tasksRepo: task id to delete -> $taskId");

    for (Task t in _tasks.value) {
      if (t.id == taskId) {
        _tasks.value.remove(t);
        log("tasksRepo: tasks size after delete: ${_tasks.stream.value.length}");
        return true;
      }
    }

    return false;
  }

  int getNextId() {
    return _tasks.value.length + 1;
  }

  String validateTask(Task task) {
    var errors = "";

    if (task.deadline.year < task.created.year) {
      errors += "Deadline should be after created\n";
    }

    if (task.deadline.year == task.created.year &&
        task.deadline.month < task.created.month) {
      errors += "Deadline should be after created\n";
    }

    if (task.deadline.year == task.created.year &&
        task.deadline.month < task.created.month &&
        task.deadline.day < task.created.day) {
      errors += "Deadline should be after created\n";
    }

    if (task.title == "") {
      errors += "Title cannot be empty\n";
    }

    if (task.users.isEmpty) {
      errors += "Task should be assigned to an user\n";
    }

    return errors;
  }
}