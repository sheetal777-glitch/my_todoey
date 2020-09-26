import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateTodo extends StatefulWidget {
  final String documentId, title, content;
  const UpdateTodo({this.documentId, this.title, this.content});

  @override
  _UpdateTodoState createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  TextEditingController title = TextEditingController();

  @override
  void dispose() {
    title.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      title.text = widget.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Update Todo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 30, color: Theme.of(context).primaryColor),
                ),
                TextField(
                  autofocus: true,
                  controller: title,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).primaryColor))),
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 15),
                RaisedButton(
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Update Todo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('todo')
                          .doc(widget.documentId)
                          .update({
                        'createdAt': Timestamp.now(),
                        'title': title.text.trim(),
                      }).then((value) => Navigator.of(context).pop());
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
