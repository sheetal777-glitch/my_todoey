import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_todo/model/todo_model.dart';
import 'package:my_todo/pages/update_todo.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController titleController = TextEditingController();
  final imageUrl =
      'https://cdna.4imprint.co.uk/prod/extras/701514/70049/700/1.jpg';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('todo')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (_, snapshots) {
          if (!snapshots.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshots.data.docs.isEmpty) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.network(imageUrl),
                ),
                Text(
                  'No items added yet!!!!',
                  style: TextStyle(fontSize: 25),
                ),
              ],
            );
          } else {
            List<String> docIdList =
                snapshots.data.docs.map((doc) => doc.id).toList();
            List<Todo> items =
                snapshots.data.docs.map((doc) => Todo.fromDoc(doc)).toList();

            return ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(items[i].title),
                    trailing: FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                            color: Theme.of(context).primaryColor,
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showModalBottomSheet(
                                  isDismissible: true,
                                  context: context,
                                  builder: (context) {
                                    return UpdateTodo(
                                      title: items[i].title,
                                      documentId: docIdList[i],
                                    );
                                  });
                            },
                          ),
                          IconButton(
                            color: Colors.red,
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              FirebaseFirestore.instance
                                  .collection('todo')
                                  .doc(docIdList[i])
                                  .delete();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
              isDismissible: true,
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Add Todo",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                color: Theme.of(context).primaryColor),
                          ),
                          TextField(
                            controller: titleController,
                            autofocus: true,
                            showCursor: true,
                            cursorColor: Theme.of(context).primaryColor,
                          ),
                          SizedBox(height: 15),
                          RaisedButton(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('todo')
                                    .doc()
                                    .set({
                                  'title': titleController.text,
                                  'createdAt': Timestamp.now(),
                                }).then((value) => Navigator.of(context).pop());
                              },
                              child: Text(
                                'Add Todo',
                                style: TextStyle(color: Colors.white),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
