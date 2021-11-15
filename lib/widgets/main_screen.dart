import 'dart:developer';
import 'package:flutter/material.dart';

import 'package:to_do_list/domain/my_date.dart';
import 'package:to_do_list/domain/task.dart';
import 'package:to_do_list/widgets/tasks_details_add_update_screen.dart';
import 'package:to_do_list/widgets/tasks_details_delete_screen.dart';

import '../utils.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreenWidget> {

  TextStyle getTextButtonStyle() {
    return const TextStyle(color: Colors.pinkAccent, fontSize: 16);
  }

  RoundedRectangleBorder getButtonBorderStyle() {
    return RoundedRectangleBorder(side: const BorderSide(
        color: Colors.pinkAccent,
        width: 0.5,
        style: BorderStyle.solid
    ), borderRadius: BorderRadius.circular(50)
    );
  }

  void handleAdd() {
    Utils.selectedTask = Task(0,"",MyDate(1,1,2021),MyDate(1,1,2021),0,[]);
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TasksDetailsAddUpdateWidget()));
  }

  void handleUpdate() {
    if (Utils.selectedTask.title == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Please select a task to update",
          style: TextStyle(color: Colors.pinkAccent, fontSize: 20)
        ),
        backgroundColor: Colors.white,
      ));
      return;
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TasksDetailsAddUpdateWidget()));
  }

  void handleDelete() {
    if (Utils.selectedTask.title == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            "Please select a task to delete",
            style: TextStyle(color: Colors.pinkAccent, fontSize: 20)
        ),
        backgroundColor: Colors.white,
      ));
      return;
    }

    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const TasksDetailsDeleteWidget()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To Do List",
          style: TextStyle(color: Colors.pinkAccent, fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
        body: SingleChildScrollView(
            child:  Column(
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            handleAdd();
                          },
                          shape: getButtonBorderStyle(),
                          child: Text( 'Add', style: getTextButtonStyle(),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            handleUpdate();
                          },
                          shape: getButtonBorderStyle(),
                          child: Text( 'Update', style: getTextButtonStyle(),
                          ),
                        ),
                        FlatButton(
                          onPressed: () {
                            handleDelete();
                          },
                          shape: getButtonBorderStyle(),
                          child: Text( 'Delete',  style: getTextButtonStyle(),
                          ),
                        ),
                      ],
                  ),
                  const SizedBox(
                      height: 50
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Text("  Title", style: getTextButtonStyle()),
                        Text("        |      ", style: getTextButtonStyle()),
                        Text("Deadline", style: getTextButtonStyle()),
                        Text("        |      ", style: getTextButtonStyle()),
                        Text("Created", style: getTextButtonStyle()),
                        Text("        |      ", style: getTextButtonStyle()),
                        Text("Priority", style: getTextButtonStyle())
                      ],
                    )
                  ),
                  const SizedBox(
                      height: 20
                  ),
                  SizedBox(
                      height: 1000,
                      child: StreamBuilder<List<Task>> (
                        stream: Utils.tasksRepo.tasksForCurrentUser,
                        builder: (context, response) {
                          if(!response.hasData) {
                            return const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(),
                            );
                          }

                          final tasks = response.data;

                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: tasks!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: getTitle(tasks[index]),
                                  tileColor: tasks[index].id == Utils.selectedTask.id ? Colors.grey : Colors.white,
                                  onTap: () {
                                    setState(() {
                                      log("selected task : ${tasks[index].toString()}");
                                      Utils.selectedTask = tasks[index];
                                    });
                                  },
                                );
                              }
                          );
                        },
                      )
                  )
                ]),
    ));
  }
}

Text getTitle(Task task) {
  String text = "${task.title}\t\t|\t\t${task.deadline.toString()}\t\t|\t\t${task.created.toString()}\t\t|\t\t${task.priority.toString()}";
  return Text(
    text,
    style: const TextStyle(color: Colors.pinkAccent, fontSize: 18)
  );
}

