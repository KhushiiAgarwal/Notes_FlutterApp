import 'package:flutter/material.dart';
import 'package:flutter_app/Screen/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/Screen/register.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  // This widget is the root of your application.

  //formkey
  final formkey = GlobalKey<FormState>();
  // editing controller
  final emailx = TextEditingController();
  final pass = TextEditingController();

  final auth = FirebaseAuth.instance; //firebase connection

  String? errorMessage; // string for displaying the error Message

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        controller: emailx,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-z0A-Z-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailx.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
        floatingLabelBehavior:FloatingLabelBehavior.auto ,
          prefixIcon: Icon(Icons.mail),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
         
        );

    final passwordField = TextFormField(
        //password field
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
          pass.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          floatingLabelBehavior:FloatingLabelBehavior.auto,
          prefixIcon: Icon(Icons.password),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ));

    final loginbutton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.blueAccent,
      child: MaterialButton(
          onPressed: () {
            signIn(emailx.text, pass.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome User 🙂"),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Form(
                key: formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.face, size: 60, color: Colors.grey),
                    SizedBox(height: 35),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 25),
                    loginbutton,
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationScreen())
                                          );
                                          
                            },
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// login function
  void signIn(String email, String password) async {
    if (formkey.currentState!.validate()) {
      try {
        await auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => HomeS())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Text(error.code);
      }
    }
  }
}
