import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher.dart';


class downloadApp extends StatefulWidget {
  @override
  _downloadAppState createState() => _downloadAppState();
}

class _downloadAppState extends State<downloadApp> {
  _mailto() async {
    const url = 'https://play.google.com/store/apps/details?id=com.japhet.pampershop';
    print("test url1");
    if (await canLaunch(url)) {
      print("test url2");
      await launch(url);
    } else {
      print("test url3");
      throw 'Could not launch $url';
    }
  }
  _mailtoios() async {
    const url = 'https://apps.apple.com/gb/app/pamper-business/id1540289691';
    print("test url1");
    if (await canLaunch(url)) {
      print("test url2");
      await launch(url);
    } else {
      print("test url3");
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        elevation: 0.0,
        title: Text("Join Pamper business"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(212, 194, 252,10),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top:75.0),
                child: Image.asset('Graphics/Webp.net-resizeimage.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: Text('Join Pamper the new way for',style: GoogleFonts.roboto(textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.only(top:2.0),
              child: Text('customers to find your business',style: GoogleFonts.roboto(textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold))),
            ),
            Padding(
              padding: const EdgeInsets.only(top:
              20.0, left: 20, right: 20, bottom: 8.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 194, 252,100),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0, top: 10, bottom: 10),
                  child: Text('${ '\u2022' } Customers discounts without the cost.',style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold
                  )), textAlign: TextAlign.end, ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:
              8.0, horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 194, 252,100),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0, top: 10, bottom: 10),
                  child: Text('${ '\u2022' } Business supplies paid for.',style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )), textAlign: TextAlign.end, ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:
              8.0, horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 194, 252,100),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0, top: 10, bottom: 10),
                  child: Text('${ '\u2022' } Control your availability 24/7.',style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )), textAlign: TextAlign.end, ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:
              8.0, horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 194, 252,100),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0, top: 10, bottom: 10),
                  child: Text('${ '\u2022' } No-Show protection.',style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  )), textAlign: TextAlign.end, ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical:
              8.0, horizontal: 20),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(212, 194, 252,100),
                ),
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left:10.0, top: 10, bottom: 10),
                  child: Text('${ '\u2022' } Many more...',style: GoogleFonts.roboto(textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                  )),  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(left:10.0, top: 10),
                child: Text('Best part it\'s all for Free!!',style: GoogleFonts.roboto(textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                )), textAlign: TextAlign.end, ),
              ),
            ),
            UniversalPlatform.isAndroid?Padding(
              padding: const EdgeInsets.only(left:100.0,right: 100,bottom: 20, top: 20),
              child: GestureDetector(
                  onTap: (){
                    _mailto();
                  },
                  child:Container(
                      height: 50,

                      decoration: BoxDecoration(
                        color: Color.fromRGBO(212, 194, 252,99),
                      ),
                      child: Center(child: Text(
                        "Join Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),)
                  )
              ),
            ):Padding(
              padding: const EdgeInsets.only(left:100.0,right: 100,bottom: 20, top: 20),
              child: GestureDetector(
                  onTap: (){
                    _mailtoios();
                  },
                  child:Container(
                      height: 50,

                      decoration: BoxDecoration(
                        color: Color.fromRGBO(212, 194, 252,99),
                      ),
                      child: Center(child: Text(
                        "Join Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),)
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
