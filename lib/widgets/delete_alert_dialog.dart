import 'package:flutter/material.dart';
import 'package:to_do_list/domain/task.dart';

import '../utils.dart';

class DeleteDialog extends StatefulWidget {
  final Task task;

  DeleteDialog(this.task) : super(key: ObjectKey(task.id));

  @override
  _DeleteDialogState createState() => _DeleteDialogState(task);
}

class _DeleteDialogState extends State<DeleteDialog> {
  final Task task;

  _DeleteDialogState(this.task);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to delete?'),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              const TextStyle(color: Colors.black),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text('Delete'),
          onPressed: () {
            Utils.tasksRepo.delete(task.id);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}