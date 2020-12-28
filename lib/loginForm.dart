import 'package:flutter/material.dart';
import 'package:pamper_app_web/Signupcontinue.dart';
import 'package:pamper_app_web/receiptPage.dart';

import 'Forgotpass.dart';
import 'Services/Authenicate.dart';

enum LoginType {
  email,
  google,
}

class LoginForm extends StatefulWidget {
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
  LoginForm(this.Time, this.price, this.services,this.Date,this.timeField,this.TimeId,this.shopProfileName, this.category,this.shopProfileId,this.StripeID,this.shopProfilePic, this.email);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool loading = false;
  bool forgot = false;

  void _loginUser({
    @required LoginType type,
    String email,
    String password,
    BuildContext context,
  }) async {
    try {
      setState(() {
        loading = true;
      });
      String _returnString;
      _returnString = await signinUser().loginUserWithEmail(email, password);
      if (_returnString == "error") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => StripePayment(
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
        )));

      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          loading = false;
          forgot = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
              child: Text(
                "Log In",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
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
            loading?CircularProgressIndicator():
            GestureDetector(
                onTap: (){
                  _loginUser(
                      type: LoginType.email,
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context);
                },
                child:Container(
                    height: 35,
                    width: 200,
                    decoration: BoxDecoration(

                      color: Color.fromRGBO(212, 194, 252,99),



                    ),

                    child: Center(child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),)

                )


            ),
            forgot? GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpass()));
              },

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    child: Center(

                      child:Text('Forgot password ? Reset here ', style: TextStyle(fontWeight: FontWeight.bold),),

                    )
                ),
              ),

            ):Text(''),
        FlatButton(
        child: Text("already have an account? Login here"),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) =>
                SignUp(
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
        ),
      );
    }
    )

          ],
        ),
      ),
    );
  }
}