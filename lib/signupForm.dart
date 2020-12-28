import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pamper_app_web/receiptPage.dart';

import 'Login.dart';
import 'Services/Authenicate.dart';



class SignUpForm extends StatefulWidget {
  final String Time;
  String price;
  final String services;
  final String Date;
  final String timeField;
  final String TimeId;
  final String shopProfileName;
  final String category;
  final String shopProfileId;
  final String StripeID;
  final String shopProfilePic;
  final String email;
  SignUpForm(this.Time, this.price, this.services,this.Date,this.timeField,this.TimeId,this.shopProfileName, this.category,this.shopProfileId,this.StripeID,this.shopProfilePic, this.email);


  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool loading = false;
  final formKey = GlobalKey<FormState>();
  Timer _timer;

  void _signUpUser(String email, String password, BuildContext context, String fullName) async {

    try {
      setState(() {
        loading = true;
      });
      String _returnString = await signinUser().signUpUser(email, password, fullName);
      if (_returnString == "success") {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => StripePayment(
                widget.Time,
                widget.price,
                widget.services,
                widget.Date,
                widget.timeField,
                widget.TimeId,
                widget.shopProfileName,
                widget.category,
                widget.shopProfileId,
                widget.StripeID,
                widget.shopProfilePic,
                widget.email
            )
        ));
        setState(() {
          loading = false;
        });

      }
    } catch (e) {
      print(e);
    }
  }
  @override
  void dispose(){
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white ,
      body: Container(
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: "Full Name",
                ),
              ),
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
              TextFormField(

                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Password",
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_open),
                  hintText: "Confirm Password",
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              loading?CircularProgressIndicator():RaisedButton(
                 color: Color.fromRGBO(212, 194, 252, 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                onPressed: () {
                  if(formKey.currentState.validate()) {
                    if (_passwordController.text == _confirmPasswordController.text) {
                      _signUpUser(
                          _emailController.text, _passwordController.text,
                          context,
                          _fullNameController.text);
                    } else {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Passwords do not match"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }
                },
              ),
              FlatButton(
                child: Text("already have an account? Login here"),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Login(       widget.Time,
                          widget.price,
                          widget.services,
                          widget.Date,
                          widget.timeField,
                          widget.TimeId,
                          widget.shopProfileName,
                          widget.category,
                          widget.shopProfileId,
                          widget.StripeID,
                          widget.shopProfilePic,
                          widget.email),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
