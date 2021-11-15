import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:to_do_list/domain/my_date.dart';
import 'package:to_do_list/domain/task.dart';
import 'package:to_do_list/domain/user.dart';

import '../utils.dart';
import 'main_screen.dart';

class TasksDetailsDeleteWidget extends StatefulWidget {
  const TasksDetailsDeleteWidget({Key? key}) : super(key: key);

  @override
  _TasksDetailsDeleteState createState() => _TasksDetailsDeleteState();
}

class _TasksDetailsDeleteState extends State<TasksDetailsDeleteWidget> {
  late final TextEditingController titleController;
  late final TextEditingController deadlineController;
  late final TextEditingController createdController;
  late final TextEditingController priorityController;
  late final TextEditingController usersController;

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
      DateTime now = DateTime.now();
      date = MyDate(now.day, now.month, now.year).toString();
    }
    createdController = TextEditingController(text: Utils.selectedTask.title == "" ? date : Utils.selectedTask.created.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Delete task",
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
                enabled: false,
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
                enabled: false,
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
                enabled: false,
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
                enabled: false,
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
                enabled: false,
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
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Are you sure you want to delete the task ?"),
                          insetPadding: const EdgeInsets.all(10),
                          actions: [
                            FlatButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                                shape: RoundedRectangleBorder(side: const BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 0.5,
                                  style: BorderStyle.solid
                                  ), borderRadius: BorderRadius.circular(50)
                                ),
                            ),
                            FlatButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              shape: RoundedRectangleBorder(side: const BorderSide(
                                  color: Colors.pinkAccent,
                                  width: 0.5,
                                  style: BorderStyle.solid
                              ), borderRadius: BorderRadius.circular(50)
                              ),
                            ),
                          ]
                      );
                    },
                  ).then((valueFromDialog){
                    if(valueFromDialog == true) {
                      //delete task
                      Utils.tasksRepo.delete(Utils.selectedTask.id);
                      log("tasksDelete: true for delete");
                      handleNavigateBackToMainPage("Successful");
                    }
                    else {
                      log("tasksDelete: false for delete");
                      handleNavigateBackToMainPage("Delete was canceled");
                    }
                  });
                },
                shape: RoundedRectangleBorder(side: const BorderSide(
                    color: Colors.pinkAccent,
                    width: 1,
                    style: BorderStyle.solid
                ), borderRadius: BorderRadius.circular(50)
                ),
                child: const Text(
                  'Delete',
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