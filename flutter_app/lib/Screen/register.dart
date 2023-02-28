import 'package:flutter/material.dart';
import 'package:flutter_app/Screen/home.dart';
import 'package:flutter_app/Screen/login.dart';
import 'db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String? errorMessage; // string for displaying the error Message

  // our form key
  final _formKey = GlobalKey<FormState>();
  // editing Controller
  final fName = TextEditingController();
  final contactno = TextEditingController();
  final emailx = TextEditingController();
  final pass = TextEditingController();
  final conPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Full name field
    final firstNameField = TextFormField(
        autofocus: true,
        controller: fName,
        keyboardType: TextInputType.name,
        style: TextStyle(color: Colors.greenAccent),
        validator: (value) {
          RegExp regex = RegExp(r'^.{5,}$');
          if (value!.isEmpty) {
            return ("Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 5 Character)");
          }
          return null;
        },
        onSaved: (value) {
          fName.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(Icons.person),
          hintText: "Full Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final ContactNoField = TextFormField(
        controller: contactno,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Contact details cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          contactno.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(Icons.phone_android),
          hintText: "Contact Number",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        controller: emailx,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          fName.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(Icons.mail),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        controller: pass,
        obscureText: true,
        validator: (value) {
          RegExp regex = RegExp(r'^.{8,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 8 Character)");
          }
        },
        onSaved: (value) {
          fName.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          prefixIcon: Icon(Icons.enhanced_encryption),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        controller: conPass,
        obscureText: true,
        validator: (value) {
          if (conPass.text != pass.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          conPass.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.enhanced_encryption),
          hintText: "Confirm Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green,
      child: MaterialButton(
          onPressed: () {
            signUp(emailx.text, pass.text);
          },
          child: Text(
            "SignUp",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("New User"),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // passing this to our root
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.verified_user,
                        size: 60, color: Colors.lightGreenAccent),
                    SizedBox(height: 35),
                    firstNameField,
                    SizedBox(height: 20),
                    ContactNoField,
                    SizedBox(height: 20),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 20),
                    confirmPasswordField,
                    SizedBox(height: 20),
                    signUpButton,
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Text(e!.message);
        });
      } on FirebaseAuthException catch (error) {}
      (errorMessage);
    }
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.fullname = fName.text;
    userModel.contact = contactno.text;

    await firebaseFirestore
        .collection("Users")
        .doc(user.uid)
        .set(userModel.toMap()).then(
          (value) => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
            }
            );
  
  
  Text("Account created successfully");
  
  }
}
