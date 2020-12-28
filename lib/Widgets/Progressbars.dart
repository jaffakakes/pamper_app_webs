import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
circularProgress(){

  return Container(
      color: Colors.white,
      alignment:  Alignment.center,

      child: Padding(
        padding: EdgeInsets.only(top: 250.0),
        child: Column(
          children:[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("PAMPER",
                style: GoogleFonts.roboto(textStyle: TextStyle(color: Color.fromRGBO(212, 194, 252,10), fontSize: 35)),),
            ),
            CircularProgressIndicator( valueColor:  AlwaysStoppedAnimation(Colors.lightBlue),)
          ] ,
        ),
      )

  );

}
linearProgress() {
  return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top:12.0),
      child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation(Color.fromRGBO(212, 194, 252, 100)),)
  );
}