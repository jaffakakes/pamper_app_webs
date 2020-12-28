import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'Modal/shop.dart';
import 'Widgets/Progressbars.dart';
import 'categoryPage.dart';


class shopPolicy extends StatefulWidget {
  final String shopProfileId;



  shopPolicy( this.shopProfileId,);
  static const routeName = '/Policy';
  @override
  _shopPolicyState createState() => _shopPolicyState();
}

class _shopPolicyState extends State<shopPolicy> {

  createTermsPage(){
    return FutureBuilder(
        future: Firestore.instance.collection("shopkeepers").document(widget.shopProfileId).get(),
        builder: (context,dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress();
          }

          Shop shop = Shop.fromDocument(dataSnapshot.data);
          return Padding(
              padding: EdgeInsets.only(top: 30),
              child: Column(
                  children: <Widget>[
                    Text('Pamper Policy: '),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Our policy states that:\n 1. The customer will be eligible for a full refund if they cancel their booking 24+ hours prior.\n 2. Customers will be eligible for only half of their refund if they cancel their booking within 24 hours of booking date and time.\n 3. Customers will not be eligible for a refund if they don\'t show up to booking.', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Text('Shop Policy: '),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(shop.policy),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:25.0),

                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.push(context, MaterialPageRoute(
                      //         builder: (context) => BookingScreen(widget.shopProfileId, shop.username, shop.stripeId, shop.url, shop.email)
                      //     ));
                      //   },
                        child: Container(
                          child: Container(
                            alignment: Alignment.center,
                            width: 150,
                            height: 30,

                            decoration: BoxDecoration(
                              color: Color.fromRGBO(212, 194, 252, 100),
                            ),
                            child: Text(
                                "I Agree and Continue",
                                style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold ))),
                          ),
                        ),
                      ),

                  ]
              )
          );
        }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Terms and Conditions',style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)),),
          backgroundColor: Color.fromRGBO(212, 194, 252, 10),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
                child: Column(
                  children: <Widget>[
                    createTermsPage()
                  ],
                )
            )
          ],

        )

    );


  }
}