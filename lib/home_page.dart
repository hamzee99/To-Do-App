import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todo/add_task.dart';
import 'package:todo/delete_task.dart';
import 'package:todo/update_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  String name = '';
  String desc = '';
  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("To-Do List"),
          backgroundColor: Color.fromARGB(255, 228, 34, 20),
          centerTitle: true,
        ),
        body: Column(children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('Task').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                } else {
                  final docs = snapshot.data!.docs;
                  return Expanded(
                    child: GroupedListView(
                      elements: docs,
                      groupBy: (doc) => doc['category'],
                      groupSeparatorBuilder: ((value) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.05,
                            color: Colors.black,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                value,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                          )),
                      itemBuilder: (context, element) => Card(
                          child: ListTile(
                        title: Text(
                          element['taskName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(element['taskDesc']),
                        isThreeLine: true,
                        trailing: Wrap(spacing: 10, children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 100, 98, 98),
                            ),
                            iconSize: 25,
                            onPressed: () {
                              String taskId = element['id'];
                              String taskName = element['taskName'];
                              String taskDesc = element['taskDesc'];
                              String category = element['category'];
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateTask(
                                        taskId: taskId,
                                        taskName: taskName,
                                        taskDesc: taskDesc,
                                        category: category);
                                  });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Color.fromARGB(255, 228, 34, 20),
                            ),
                            iconSize: 25,
                            onPressed: () {
                              String taskId = (element['id']);
                              Future.delayed(
                                const Duration(seconds: 0),
                                () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteTask(taskId: taskId);
                                  },
                                ),
                              );
                            },
                          )
                        ]),
                      )),
                    ),
                  );
                }
              })
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 228, 34, 20),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AddTask();
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
