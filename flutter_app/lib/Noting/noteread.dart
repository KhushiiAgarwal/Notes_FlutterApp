import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NoteReadScreen extends StatefulWidget {
  NoteReadScreen(this.doc, {Key? key}) : super(key: key);
  QueryDocumentSnapshot doc;

  @override
  State<NoteReadScreen> createState() => _NoteReadScreenState();
}

class _NoteReadScreenState extends State<NoteReadScreen> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
         body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["note_title"],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              widget.doc["creation_date"],
              
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              widget.doc["note_content"],
              
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
     );
}
}