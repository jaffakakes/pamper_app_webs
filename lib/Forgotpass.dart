import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'forgotPassForm.dart';


class Forgotpass extends StatefulWidget {
  @override
  _ForgotpassState createState() => _ForgotpassState();
}

class _ForgotpassState extends State<Forgotpass> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(212, 194, 252,10),
      appBar:  AppBar(
        centerTitle: true,
        backgroundColor: Color.fromRGBO(212, 194, 252,10),
        elevation: 0.0,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(

              children: <Widget>[
                SizedBox(height: 100,),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Forgot your password ?",
                    style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),
                  ),

                ),
                SizedBox(height: 150,),
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: forgotPassForm()
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
