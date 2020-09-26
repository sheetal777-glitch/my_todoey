import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String title;
  final Timestamp createdAt;
  Todo({this.title, this.createdAt});

  factory Todo.fromDoc(DocumentSnapshot doc) {
    return Todo(title: doc.data()['title'], createdAt: doc.data()['createdAt']);
  }
}
