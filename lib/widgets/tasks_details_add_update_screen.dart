import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/domain/my_date.dart';
import 'package:to_do_list/domain/task.dart';
import 'package:to_do_list/domain/user.dart';
import 'package:to_do_list/widgets/main_screen.dart';

import '../utils.dart';

class TasksDetailsAddUpdateWidget extends StatefulWidget {
  const TasksDetailsAddUpdateWidget({Key? key}) : super(key: key);

  @override
  _TasksDetailsAddUpdateState createState() => _TasksDetailsAddUpdateState();
}

class _TasksDetailsAddUpdateState extends State<TasksDetailsAddUpdateWidget> {
  late final TextEditingController titleController;
  late final TextEditingController deadlineController;
  late final TextEditingController createdController;
  late final TextEditingController priorityController;
  late final TextEditingController usersController;
  bool createdIsEnabled = true;

  @override
  void dispose() {
    titleController.dispose();
    createdController.dispose();
    deadlineController.dispose();
    priorityController.dispose();
    usersController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: Utils.selectedTask.title == "" ? "" : Utils.selectedTask.title);
    deadlineController = TextEditingController(text: Utils.selectedTask.title == "" ? "" : Utils.selectedTask.deadline.toString());
    priorityController = TextEditingController(text: Utils.selectedTask.title == "" ? "" : Utils.selectedTask.priority.toString());
    usersController = TextEditingController(text: Utils.selectedTask.title == "" ? "" : parseUsersToString(Utils.selectedTask.users));

    String date = "";
    if (Utils.selectedTask.title == "") {
      createdIsEnabled = false;
      DateTime now = DateTime.now();
      date = MyDate(now.day, now.month, now.year).toString();
    }
    createdController = TextEditingController(text: Utils.selectedTask.title == "" ? date : Utils.selectedTask.created.toString());
  }


  List<User> getUsersFromTextField(String text) {
    log("tasksWidget: getUsers $text");

    if (!text.contains(" ")) {
      User? userFound = Utils.usersRepo.findByGitHubUsername(text);
      if(userFound != null) {
        return [userFound];
      }
      return [];
    }

    List<User> users = [];
    List<String> aux = [];

    for(String t in aux) {
      if(t != "") {
        User? userFound = Utils.usersRepo.findByGitHubUsername(t);

        if(userFound != null) {
          users.add(userFound);
        }
        else {
          throw Exception("Invalid GitHub username\n");
        }
      }
    }

    return users;
  }

  MyDate parseDateFromString(String text) {
    log("tasksWidget: parseDate $text");

    if(!text.contains(".")) {
      throw Exception("invalid format for date\n");
    }
    else {
      List<String> aux = text.split(".");
      if (aux.length != 3) {
        throw Exception("invalid format for date\n");

      } else {
        int day = int.parse(aux[0]);
        int month = int.parse(aux[1]);
        int year = int.parse(aux[2]);

        if (day < 1 || day > 31) {
          throw Exception("Invalid day");
        }

        if (month < 1 || month > 12) {
          throw Exception("Invalid month");
        }

        return MyDate(day, month, year);
      }
    }
  }

  String parseUsersToString(List<User> users) {
    String text = "";

    for(int i=0; i<users.length; i++) {
      text += users[i].gitHubUsername!;
      if(i != users.length-1) {
        text += " ";
      }
    }

    return text;
  }

  void handleOnClick() {
    String title = titleController.text;
    String created = createdController.text;
    String deadline = deadlineController.text;
    String priority = priorityController.text;
    String users = usersController.text;

    Task task = Task(0,"",MyDate(1,1,2021),MyDate(1,1,2021),0,[]);
    try {
      task = Task(0, title, parseDateFromString(deadline), parseDateFromString(created), int.parse(priority), getUsersFromTextField(users));
      if(Utils.selectedTask.title != "") {
        task.id = Utils.selectedTask.id;
      }
    }
    on FormatException catch(e) {
      handleNavigateBackToMainPage("You should insert a number at priority field\n");
    }
    on Exception catch(e) {
      handleNavigateBackToMainPage(e.toString());
    }

    if(task.title != "") {
      try {
        if(Utils.selectedTask.title != "") {
          log("taskWidget: task to update: ${task.toString()}");
          Utils.tasksRepo.update(task);
        }
        else {
          log("taskWidget: task to add: ${task.toString()}");
          Utils.tasksRepo.add(task);
        }
        handleNavigateBackToMainPage("Successful!");
      }
      on Exception catch(e) {
        handleNavigateBackToMainPage(e.toString());
      }
    }
  }

  TextStyle getTextButtonStyle() {
    return const TextStyle(color: Colors.pinkAccent, fontSize: 16);
  }

  InputDecoration getInputDecoration(String labelTextValue) {
    return InputDecoration(
        border: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 0.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.pinkAccent, width: 0.5),
        ),
        labelText: labelTextValue,
        labelStyle: getTextButtonStyle()
    );
  }

  void handleNavigateBackToMainPage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            message,
            style: const TextStyle(color: Colors.pinkAccent, fontSize: 18)
        ),
        backgroundColor: Colors.white
    ));

    Utils.selectedTask = Task(0,"",MyDate(1,1,2021),MyDate(1,1,2021),0,[]);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Update your to do list",
          style: TextStyle(color: Colors.pinkAccent, fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
                height: 50
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: getInputDecoration("Title"),
                controller: titleController,
              ),
            ),
            const SizedBox(
                height: 30
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: getInputDecoration("Deadline"),
                controller: deadlineController,
              ),
            ),
            const SizedBox(
                height: 30
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: getInputDecoration("Created"),
                controller: createdController,
                enabled: createdIsEnabled,
              ),
            ),
            const SizedBox(
                height: 30
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: getInputDecoration("Priority"),
                controller: priorityController,
              ),
            ),
            const SizedBox(
                height: 30
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: getInputDecoration("Users"),
                controller: usersController,
              ),
            ),
            const SizedBox(
                height: 30
            ),
            SizedBox(
              height: 30,
              width: 250,
              child: FlatButton(
                onPressed: () {
                  handleOnClick();
                },
                shape: RoundedRectangleBorder(side: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.pinkAccent, fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}