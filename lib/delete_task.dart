import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DeleteTask extends StatefulWidget {
  final String taskId;
  const DeleteTask({Key? key, required this.taskId});

  @override
  State<DeleteTask> createState() => _DeleteTaskState();
}

class _DeleteTaskState extends State<DeleteTask> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Delete Task",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.10,
        width: MediaQuery.of(context).size.width,
        child: Text(
          "Are you sure you want to delete this task ?",
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.grey)),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            deleteTask();
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text("Delete"),
        )
      ],
    );
  }

  Future deleteTask() async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Task').doc(widget.taskId);
    documentReference.delete();

    // .then((_) => print('Deleted'))
    // .catchError((error) => print('Error while deleting'));
  }
}
