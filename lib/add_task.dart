import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final List<String?> categories = ['Home', 'Office', 'shop'];
  late String selectedValue = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
        "Add New Task",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        child: Form(
          child: Column(children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Task Name",
                  icon: Icon(Icons.list)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: descController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Description",
                  icon: Icon(Icons.description)),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: "Select a Category"),
                    dropdownColor: Color.fromARGB(255, 201, 192, 192),
                    items: categories
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item!),
                            ))
                        .toList(),
                    onChanged: (String? value) => setState(() {
                      if (value != null) {
                        selectedValue = value;
                      }
                    }),
                  ),
                )
              ],
            ),
          ]),
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
            final taskName = nameController.text;
            final taskDesc = descController.text;
            final category = selectedValue;
            addTask(taskName: taskName, taskDesc: taskDesc, category: category);
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text("ADD"),
        )
      ],
    );
  }
}

Future addTask(
    {required String taskName,
    required String taskDesc,
    required String category}) async {
  DocumentReference documentReference =
      await FirebaseFirestore.instance.collection('Task').add({
    'taskName': taskName,
    'taskDesc': taskDesc,
    'category': category,
  });
  final taskId = documentReference.id;
  await FirebaseFirestore.instance
      .collection('Task')
      .doc(taskId)
      .update({'id': taskId});
}
