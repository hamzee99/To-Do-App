import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/add_task.dart';
import 'package:todo/delete_task.dart';
import 'package:todo/update_task.dart';

List filteredList = [];
List dataFilter = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? selectedCategory = 'All';
  TextEditingController nameController = TextEditingController();
  String name = '';
  String desc = '';
  TextEditingController descController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("To-Do List"),
          backgroundColor: Colors.black,
          centerTitle: true,
          actions: [
            DropdownButton<String>(
              icon: Icon(
                Icons.filter_list,
                color: Colors.white,
              ),
              dropdownColor: Color.fromARGB(255, 104, 103, 103),
              value: selectedCategory,
              style: TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {
                  selectedCategory = value;
                });
              },
              items: [
                DropdownMenuItem<String>(
                  value: "All",
                  child: Text(
                    "All",
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Home",
                  child: Text("Home"),
                ),
                DropdownMenuItem<String>(
                  value: "Office",
                  child: Text("Office"),
                ),
                DropdownMenuItem<String>(
                  value: "shop",
                  child: Text("shop"),
                ),
              ],
            ),
          ]),
      body: Column(children: [
        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('Task').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("There is no data to display");
            } else if (selectedCategory == "All") {
              final docs = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    /*  if (docs.elementAt(index).data()['category'] ==
                        selectedCategory) {
                      data = docs.elementAt(index).data();
                    }*/

                    final data = docs.elementAt(index).data();
                    return ListTile(
                      title: Text(
                        data['taskName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(data['taskDesc']),
                      isThreeLine: true,
                      trailing: Wrap(spacing: 10, children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 100, 98, 98),
                          ),
                          iconSize: 25,
                          onPressed: () {
                            String taskId = data['id'];
                            String taskName = data['taskName'];
                            String taskDesc = data['taskDesc'];
                            String category = data['category'];
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
                            String taskId = (data['id']);
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
                    );
                  },
                ),
              );
            } else {
              final docs = snapshot.data!.docs
                  .where((element) => element['category'] == selectedCategory);
              print(docs.length);
              return Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data;
                    if (docs.elementAt(index).data()['category'] ==
                        selectedCategory) {
                      data = docs.elementAt(index).data();
                      return ListTile(
                        title: Text(
                          data['taskName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data['taskDesc']),
                        isThreeLine: true,
                        trailing: Wrap(spacing: 10, children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Color.fromARGB(255, 100, 98, 98),
                            ),
                            iconSize: 25,
                            onPressed: () {
                              String taskId = data['id'];
                              String taskName = data['taskName'];
                              String taskDesc = data['taskDesc'];
                              String category = data['category'];
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
                              String taskId = (data['id']);
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
                      );
                    } else {
                      return Text("Empty");
                    }
                  },
                ),
              );
            }
          },
        ),
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
    );
  }

  getFilteredList(String? category) {
    filteredList =
        dataFilter.where((element) => element['category'] == category).toList();
  }
}
