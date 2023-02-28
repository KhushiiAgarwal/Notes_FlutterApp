import 'package:flutter/material.dart';
import 'package:flutter_app/Screen/home.dart';
import 'package:flutter_app/Screen/Register.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Screen/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Notes> {
  TextEditingController title = TextEditingController();
  TextEditingController mainbody = TextEditingController();
  String date = DateTime.now().toString();
User? user = FirebaseAuth.instance.currentUser;

    UserModel userModel = UserModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Keynotes"),
        centerTitle: true,
        elevation: 10,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeS()));
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'Note Title;'),
            ),
            SizedBox(
              height: 10,
            ),
            Text(date),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: mainbody,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Content',
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Notes").add({
            "Notes_Title": title.text,
            "Date of Creation": date,
            "Content": mainbody.text,
          }).then((value) {
            print(value.id);
            Navigator.pop(context);
          }).catchError(
              (error) => print("Failed to add new Note due to $error"));
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
