import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';


import 'loginForm.dart';

class Login extends StatelessWidget {
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
  Login(this.Time, this.price, this.services,this.Date,this.timeField,this.TimeId,this.shopProfileName, this.category,this.shopProfileId,this.StripeID,this.shopProfilePic, this.email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(212, 194, 252, 10),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(

              children: <Widget>[
                SizedBox(height: 100,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(

                    alignment: Alignment.topLeft,
                    child: Text(
                      "4/5",
                      style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white60, fontSize: 20)),
                    ),

                  ),
                ),
                Container(

                  alignment: Alignment.center,
                  child: Text(
                    "Login to continue",
                    style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),
                  ),

                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: LoginForm(
                        Time,
                        price,
                        services,
                        Date,
                        timeField,
                        TimeId,
                        shopProfileName,
                        category,
                        shopProfileId,
                        StripeID,
                        shopProfilePic,
                        email
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}