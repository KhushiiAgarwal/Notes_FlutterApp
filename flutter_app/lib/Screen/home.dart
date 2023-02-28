import 'package:flutter_app/Noting/notecreate.dart';
import 'package:flutter_app/Noting/noteread.dart';

import 'db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Noting/notedit.dart';
import 'package:flutter_app/Screen/login.dart';

class HomeS extends StatefulWidget {
  const HomeS({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  // ignore: library_private_types_in_public_api
}

class _HomeScreenState extends State<HomeS> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final fName = TextEditingController();
  final contactno = TextEditingController();
  final emailx = TextEditingController();

  //const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to Keynotes"),
        //gradient: LinearGradient(colors: [Colors.blue, Colors.purple, Colors.red]),

        centerTitle: true,
        elevation: 50.0,
      ),

      //               _onPressed();
      //               signout();

      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
              ),
              title: const Text('Page 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your recent Notes"),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      children: snapshot.data!.docs
                          .map((note) => noteCard(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NoteReadScreen(note),
                                    ));
                              }, note))
                          .toList(),
                    );
                  }
                  return Text(
                    "there's no Notes",
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Notes()));
        },
        icon: const Icon(Icons.add),
        backgroundColor: Colors.cyan,
        label: Text("Add new note"),
      ),
    );
  }
}

void signout() async {
  await FirebaseAuth.instance.signOut();
}

Future _onPressed() async {
  final String uid;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  return FutureBuilder<DocumentSnapshot>(
    // future: users.doc(uid).get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.hasData && !snapshot.data!.exists) {
        return Text("Document does not exist");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Text("Full Name: ${data['full_name']} ${data['last_name']}");
      }

      return Text("loading");
    },
  );
}
