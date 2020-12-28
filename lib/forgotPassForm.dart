import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class forgotPassForm extends StatefulWidget {
  @override
  _forgotPassFormState createState() => _forgotPassFormState();
}

class _forgotPassFormState extends State<forgotPassForm> {
  TextEditingController _emailController = TextEditingController();
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void>resetPassword(String email) async {
    try{
      await _auth.sendPasswordResetEmail(email: email);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Email has been sent to $email'),
          duration: Duration(seconds: 5),
        ),
      );
    }catch (e){
      print(e);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Email has not been found. Sign up today'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
  @override

  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white ,
      body: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[

              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (val) {
                  return RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(val) ? null : "Please provide a valid email address";
                },
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email),
                  hintText: "Email",
                ),
              ),

              SizedBox(
                height: 20.0,
              ),
              loading?CircularProgressIndicator():RaisedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Text(
                    "Reset password",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: () {
                  if(formKey.currentState.validate()) {
                    resetPassword(_emailController.text.trim());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
