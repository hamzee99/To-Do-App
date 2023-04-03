import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();
TextEditingController descController = TextEditingController();

class UpdateTask extends StatefulWidget {
  final String taskId;
  final String taskName;
  final String taskDesc;
  final String category;
  const UpdateTask(
      {Key? key,
      required this.taskId,
      required this.taskName,
      required this.taskDesc,
      required this.category});

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final List<String?> categories = ['Home', 'Office', 'shop'];

  String selectedValue = "";
  @override
  Widget build(BuildContext context) {
    nameController.text = widget.taskName;
    descController.text = widget.taskDesc;

    return AlertDialog(
      scrollable: true,
      title: Text(
        "Edit Task",
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        child: Column(children: [
          Form(
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Task Name",
                  icon: Icon(Icons.list)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Form(
            child: TextFormField(
              controller: descController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: "Description",
                  icon: Icon(Icons.description)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField(
                  isExpanded: true,
                  value: widget.category,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: "Select a Category"),
                  dropdownColor: Color.fromARGB(255, 201, 192, 192),
                  items: categories
                      .map((item) => DropdownMenuItem<String>(
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
            final String taskName = nameController.text;
            final String taskDesc = descController.text;
            print(widget.taskId);
            var category = '';
            selectedValue == ''
                ? category = widget.category
                : category = selectedValue;
            updateTask(taskName, taskDesc, category);
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          child: Text("Update"),
        )
      ],
    );
  }

  Future updateTask(String taskName, String taskDesc, String category) async {
    print(category);
    await FirebaseFirestore.instance
        .collection('Task')
        .doc(widget.taskId)
        .update(
            {'taskName': taskName, 'taskDesc': taskDesc, 'category': category});
  }
}
