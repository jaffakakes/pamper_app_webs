
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:http/http.dart' as http;
import 'Modal/User.dart';
import 'Services/Authenicate.dart';
import 'Services/Database.dart';
import 'Widgets/Progressbars.dart';
import 'downloadApp.dart';

class StripePayment extends StatefulWidget {
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
  StripePayment(this.Time, this.price, this.services,this.Date,this.timeField,this.TimeId,this.shopProfileName, this.category,this.shopProfileId,this.StripeID,this.shopProfilePic, this.email);


  @override
  _StripePaymentState createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  bool depoist = false;
  final String postCreateIntentURL = 'https://us-central1-pamper-cfe32.cloudfunctions.net/StripePI';
  String text = 'Click the button to start the payment';

  double service_charge = 2.50;
  bool deposits = false;

  // double tax = 0.0;
  // double taxPercent = 0.2;
  double amount = 0;
  int fee = 500;
  bool showSpinner = false;
  dynamic Promo;
  dynamic Promos;
  String stripeId;
  TextEditingController promoText = TextEditingController();
  TextEditingController NoteTextEditingController = TextEditingController();
  DatabaseMethods database = DatabaseMethods();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();

  final Stripe stripe = Stripe(
    //"pk_live_51HMcnmGe403MkZxfdgroRomDtQsTnvDP8ylS5xtOpruuIuBnDxem3nEESCi6946jTWROMXF9KHzUiYfj1BTmokYJ00XWTnHajn",
    "pk_test_51HMcnmGe403MkZxfVpNlH57DfT4kX2OGFHwA9zto9ywrn1ajwgd9galMlV6n5RQsNW4UvppzRNYC6xT4rxmBddg100yrRVKBBI",
    //Your Publishable Key

    //Merchant Connected Account ID. It is the same ID set on server-side.
    returnUrlForSca: "https://us-central1-pamper-cfe32.cloudfunctions.net/StripePI", //Return URL for SCA
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PromoPoints();
    fivePoints();

  }

  PromoPoints() async {
    await Firestore.instance.collection('Users').document(currentUser.id)
        .get()
        .then((val) {
      if (val.data['promo'] != null) {
        Promo = val.data["promo"].toString();
      }
      else {
        Promo = '0';
      }
    });
  }

  fivePoints() async {
    await Firestore.instance.collection('Users').document(currentUser.id).get()
        .then((val) {
      if (val.data['promos'] != null) {
        Promos = val.data["promos"].toString();
      }
      else {
        Promos = '0';
      }
    });
  }


  freebooking() {
    print('working');
    setState(() {
      showSpinner = true;
    });
    if (int.parse(Promo) >= 10) {
      print('working2');

      payback() {
        if (double.parse(widget.price) <= 10) {
          return double.parse(widget.price) - 2.50;
        } else if (double.parse(widget.price) > 10) {
          return 10;
        }
      }
      Map<String, dynamic> promomap = {
        "payBack": payback(),
        "orignal_price": widget.price,
        "Email": widget.email,
        "services": widget.services,
        "shopProfileName": widget.shopProfileName,
        "shopId": widget.shopProfileId,
        "UserId": currentUser.id,
        "ShopStripeId": widget.StripeID,
        "shopPic": widget.shopProfilePic,
      };
      DatabaseMethods().promoBuys(promomap);
      int.parse(Promo) >= 10
          ? DatabaseMethods().deleteCardPromo(currentUser.id)
          : print('working');
      List<String> users = [widget.shopProfileId, currentUser.username];
      Map<String, dynamic> categoryMap = {
        "users": users,
        "Time": widget.Time,
        "Pre-Paid": 'Yes',
        'PrePaid': true,
        'Usersurl': currentUser.url,
        "price": double.parse(widget.price),
        "services": widget.services,
        "Date": widget.Date,
        "timeField": widget.timeField,
        "shopProfileName": widget.shopProfileName,
        "category": widget.category,
        "User": currentUser.username,
        "shopId": widget.shopProfileId,
        "UserId": currentUser.id,
        "ShopStripeId": widget.StripeID,
        "shopPic": widget.shopProfilePic,
        "time": DateTime
            .now()
            .millisecondsSinceEpoch,
        "checked": false,
        "Notes": NoteTextEditingController.text
      };
      DatabaseMethods().acceptedBooking(widget.shopProfileId, categoryMap);
      DatabaseMethods().shopNumberAdd(
          widget.shopProfileId, double.parse(widget.price));
      DatabaseMethods().shopBookingsAdd(widget.shopProfileId);
      DatabaseMethods().deleteTimeList(
          widget.TimeId, widget.shopProfileId, widget.Date, widget.category,
          widget.services);
      print(widget.TimeId);
    } else if (int.parse(Promos) >= 1) {
      requestBooking();
      payback() {
        if (double.parse(widget.price) <= 5) {
          return double.parse(widget.price) - 2.50;
        } else if (double.parse(widget.price) > 5) {
          return 5;
        }
      }
      Map<String, dynamic> promomap = {
        "payBack": payback(),
        "Email": widget.email,
        "services": widget.services,
        "orignal_price": widget.price,
        "shopProfileName": widget.shopProfileName,
        "shopId": widget.shopProfileId,
        "UserId": currentUser.id,
        "ShopStripeId": widget.StripeID,
        "shopPic": widget.shopProfilePic,
      };
      DatabaseMethods().promoBuys(promomap);
      int.parse(Promos) == 1
          ? DatabaseMethods().deletePromo(currentUser.id)
          : print('working');
      List<String> users = [widget.shopProfileId, currentUser.username];
      Map<String, dynamic> categoryMap = {
        "users": users,
        "Time": widget.Time,
        'Usersurl': currentUser.url,
        "Pre-Paid": 'Yes',
        'PrePaid': true,
        "price": double.parse(widget.price),
        "services": widget.services,
        "Date": widget.Date,
        "timeField": widget.timeField,
        "shopProfileName": widget.shopProfileName,
        "category": widget.category,
        "User": currentUser.username,
        "shopId": widget.shopProfileId,
        "UserId": currentUser.id,
        "ShopStripeId": widget.StripeID,
        "shopPic": widget.shopProfilePic,
        "time": DateTime
            .now()
            .millisecondsSinceEpoch,
        "checked": false,
        "Notes": NoteTextEditingController.text
      };
      DatabaseMethods().acceptedBooking(widget.shopProfileId, categoryMap);
      DatabaseMethods().shopNumberAdd(
          widget.shopProfileId, double.parse(widget.price));
      DatabaseMethods().shopBookingsAdd(widget.shopProfileId);
      DatabaseMethods().deleteTimeList(
          widget.TimeId, widget.shopProfileId, widget.Date, widget.category,
          widget.services);
      print(widget.TimeId);
    }
  }

  Future<String> cardPayment(BuildContext context) {
    double total = double.parse(widget.price) + 2.50;
    double discounted = double.parse(widget.price) - 10.0 + 2.50;
    double discounted_two = double.parse(widget.price) - 5.0 + 2.50;
    // ? '£'+  discounted_two.toStringAsFixed(2):'£'+total.toStringAsFixed(2)
    print(discounted);
    print(discounted_two);

    discount() {
      if (discounted_two <= 0 && int.parse(Promos) == 1) {
        return Text(
            '0', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)));
      }
      else if (int.parse(Promos) >= 1) {
        return Text('£' + discounted_two.toStringAsFixed(2),
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)));
      }
      else if (discounted <= 0 && int.parse(Promo) >= 10) {
        return Text(
            '0', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)));
      }
      else if (int.parse(Promo) >= 10) {
        return Text(discounted.toStringAsFixed(2),
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)));
      } else {
        return Text(total.toStringAsFixed(2),
            style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)));
      }
    }
    discounts() {
      if (int.parse(Promos) == 1) {
        return discounted_two;
      } else if (int.parse(Promo) >= 10) {
        return discounted;
      } else {
        return total;
      }
    }


    return showDialog(context: context, builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(20.0)),
              title: Text("Pre-pay Booking"),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Price:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  Text('£' + widget.price, style: GoogleFonts
                                      .roboto(
                                      textStyle: TextStyle(fontSize: 12)),),
                                ]
                            ),
                          )
                      ),
                      Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("service fee:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  Text('£2.50', style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontSize: 12)),),
                                ]
                            ),
                          )
                      ),
                      int.parse(Promo) >= 10 ? Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Discount:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  Text('£10', style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontSize: 12)),),
                                ]
                            ),
                          )
                      ) : Text(''),
                      int.parse(Promos) == 1 ? Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("New User discount:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  Text('£5', style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontSize: 12)),),
                                ]
                            ),
                          )
                      ) : Text(''),


                      Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Total:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  discount()
                                ]
                            ),
                          )
                      ),

                      Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Text("Pamper Points:",
                                      style: GoogleFonts.roboto(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12)),),
                                  ),
                                  Text(Promo, style: GoogleFonts.roboto(
                                      textStyle: TextStyle(fontSize: 12)),),
                                ]
                            ),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            if (discounts() <= 0.00) {
                              setState(() {
                                deposits = false;
                              });
                              freebooking();
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(
                                  builder: (context) =>
                                      downloadApp()
                              ));
                            } else {
                              setState(() {
                                deposits = false;
                              });
                              buy(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 150,
                            height: 30,

                            decoration: BoxDecoration(
                              color: Color.fromRGBO(212, 194, 252, 100),
                            ),

                            child: Text(
                                "Pre-pay Booking",
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 150,
                            height: 30,

                            decoration: BoxDecoration(
                              color: Color.fromRGBO(212, 194, 252, 100),
                            ),

                            child: Text(
                                "cancel",
                                style: GoogleFonts.roboto(textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold))),
                          ),
                        ),
                      )
                    ],

                  )
              ),

            );
          }
      );
  }



Future<String> Notes(BuildContext context){
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20.0)),
          title: Text("Add Note "),
          content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: NoteTextEditingController,
                    maxLines: 5,
                    decoration: InputDecoration(

                      hintText: "Add note here...",

                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(212, 194, 252,10)),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pop(context);

                      },
                      child: Container(


                        alignment: Alignment.center,
                        width: 150,
                        height: 30,

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(212, 194, 252, 100),
                        ),
                        child: GestureDetector(

                          child: Text(
                              "Done",
                              style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15 ))),
                        ),

                      ),
                    ),
                  )
                ],

              )
          ),

        );
      }
  );
}


Future<String> cashPayment(BuildContext context){
  double deposit = double.parse(widget.price)*0.35;
  double Total = deposit + 2.50;



  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20.0)),
          title: Text("Deposit Booking"),
          content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Paying by deposit means paying the rest on booking dates, deposit are protected with refunds no shows means you lose out on deposit '),
                  Container(


                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Padding(
                                padding: const EdgeInsets.only(right:20.0),
                                child: Text("Price:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontSize: 12)),),
                              ),
                              Text('£'+ deposit.toStringAsFixed(2), style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)), ),
                            ]
                        ),
                      )
                  ),
                  Container(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Padding(
                                padding: const EdgeInsets.only(right:20.0),
                                child: Text("Service:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontSize: 12)),),
                              ),
                              Text('£2.50', style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)), ),
                            ]
                        ),
                      )
                  ),

                  Container(

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children:[
                              Padding(
                                padding: const EdgeInsets.only(right:20.0),
                                child: Text("Total:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.black,fontSize: 12)),),
                              ),
                              Text('£'+ Total.toStringAsFixed(2), style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 12)), ),
                            ]
                        ),
                      )
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          deposits = true;
                        });
                        buy(context);
                        Navigator.pop(context);

                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 30,

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(212, 194, 252, 100),
                        ),

                        child: Text(
                            "Pay Deposit",
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: ()async{
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 150,
                        height: 30,

                        decoration: BoxDecoration(
                          color: Color.fromRGBO(212, 194, 252, 100),
                        ),

                        child: Text(
                            "cancel",
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold))),
                      ),
                    ),
                  )
                ],

              )
          ),

        );
      }
  );
}



requestBooking(){
  List<String> users = [widget.shopProfileId,currentUser.username ];
  Map<String, dynamic> categoryMap = {
    "users": users,
    "Time" : widget.Time,
    'Usersurl': currentUser.url,
    "Pre-Paid": 'Yes',
    'PrePaid' : true,
    "price" : double.parse(widget.price),
    "services" : widget.services,
    "Date" : widget.Date,
    "timeField" : widget.timeField,
    "shopProfileName" :widget.shopProfileName,
    "category" : widget.category,
    "User" : currentUser.username,
    "shopId" : widget.shopProfileId,
    "UserId": currentUser.id,
    "ShopStripeId": widget.StripeID,
    "shopPic": widget.shopProfilePic,
    "time": DateTime.now().millisecondsSinceEpoch,
    "checked": false,
    "Notes": NoteTextEditingController.text
  };
  DatabaseMethods().acceptedBooking(widget.shopProfileId , categoryMap);
  DatabaseMethods().shopNumberAdd(widget.shopProfileId,double.parse(widget.price));
  DatabaseMethods().shopBookingsAdd(widget.shopProfileId);
  DatabaseMethods().deleteTimeList(widget.TimeId, widget.shopProfileId, widget.Date,widget.category,widget.services);
  print(widget.TimeId);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      downloadApp()
  ));

}

PayByCash(){
  List<String> users = [widget.shopProfileId,currentUser.username ];
  Map<String, dynamic> categoryMapcash = {
    "users": users,
    "Time" : widget.Time,
    "deposit": 'Yes',
    'Usersurl': currentUser.url,
    'PrePaid': false,
    "price" : double.parse(widget.price),
    "services" : widget.services,
    "Date" : widget.Date,
    "timeField" : widget.timeField,
    "shopProfileName" :widget.shopProfileName,
    "category" : widget.category,
    "User" : currentUser.username,
    "shopId" : widget.shopProfileId,
    "UserId": currentUser.id,
    "ShopStripeId": widget.StripeID,
    "shopPic": widget.shopProfilePic,
    "time": DateTime.now().millisecondsSinceEpoch,
    "checked": false,
    "Notes": NoteTextEditingController.text
  };
  DatabaseMethods().acceptedBooking(widget.shopProfileId , categoryMapcash);
  DatabaseMethods().shopNumberAdd(widget.shopProfileId,double.parse(widget.price));
  DatabaseMethods().shopBookingsAdd(widget.shopProfileId);
  DatabaseMethods().deleteTimeList(widget.TimeId, widget.shopProfileId, widget.Date,widget.category,widget.services);
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
      downloadApp()
  ));

}
PromoMap() {

  payback() {
    if(fee == 0){
      return 0;
    }else if (double.parse(widget.price) <= 10) {
      return double.parse(widget.price) - 2.50;
    } else if (double.parse(widget.price) > 10) {
      return 10;
    }
  }
  Map<String, dynamic> promomap = {


    "payBack": payback(),
    "Email": widget.email,
    "orignal_price": widget.price,
    "services": widget.services,
    "shopProfileName": widget.shopProfileName,
    "shopId": widget.shopProfileId,
    "UserId": currentUser.id,
    "ShopStripeId": widget.StripeID,
    "shopPic": widget.shopProfilePic,
  };
  DatabaseMethods().promoBuys(promomap);
}
PromoMaps(){
  payback() {
    if(fee == 0){
      return 0;
    }else if (double.parse(widget.price) <= 5) {
      return double.parse(widget.price) - 2.50;
    } else if (double.parse(widget.price) > 5) {
      return 5;
    }
  }
  Map<String, dynamic> promomap = {
    "payBack" : payback(),
    "Email": widget.email,
    "orignal_price": widget.price,
    "services" : widget.services,
    "shopProfileName" :widget.shopProfileName,
    "shopId" : widget.shopProfileId,
    "UserId": currentUser.id,
    "ShopStripeId": widget.StripeID,
    "shopPic": widget.shopProfilePic,
  };
  DatabaseMethods().promoBuys(promomap);
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(212, 194, 252, 10),
      ),
      body:
      showSpinner?circularProgress():SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(212, 194, 252,99),
                          offset: const Offset(1.0, 1.0),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                      color: Color.fromRGBO(212, 194, 252,10),
                    ),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Notes(context);
                          },
                          child: Container(

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children:[
                                      Padding(
                                        padding: const EdgeInsets.only(right:10.0),
                                        child: Text("Press add note", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 25)),),
                                      ),
                                      Icon(
                                        Icons.sticky_note_2_rounded, color: Colors.white, size: 35,
                                      )
                                    ]
                                ),
                              )
                          ),
                        ),
                        Container(
                          height: 5,
                          color: Colors.white,
                        ),
                        Container(


                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Shop:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text(widget.shopProfileName, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),
                        Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Service:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text(widget.services, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),
                        Container(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Duration:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text(widget.Time, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),
                        Container(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Date:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text(widget.Date, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),
                        Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Time:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text(widget.timeField, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),

                        Container(

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(right:20.0),
                                      child: Text("Price:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 30)),),
                                    ),
                                    Text('£'+ widget.price, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 30)), ),
                                  ]
                              ),
                            )
                        ),

                      ],
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(

                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(212, 194, 252,99),
                        offset: const Offset(1.0, 1.0),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    color: Color.fromRGBO(212, 194, 252,10),
                  ),
                  child:Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Discounts Applied:',
                      style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.bold)),),),
                ),
                SizedBox(

                    child: FutureBuilder(
                        future: Firestore.instance.collection('Users').document(currentUser.id).get(),
                        builder: (context, dataSnapshot) {
                          if (!dataSnapshot.hasData) {
                            return circularProgress();
                          }
                          User user = User.fromDocument(dataSnapshot.data);
                          return Column(
                            children: [
                              user.Points >= 10 ? Container(

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:20.0, vertical: 5),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15.0),
                                            child: Text("Pamper Discount:", style: GoogleFonts.roboto(
                                                textStyle: TextStyle(
                                                    color: Colors.black, fontSize: 15)),),
                                          ),
                                          Text('£10', style: GoogleFonts.roboto(
                                              textStyle: TextStyle(fontSize: 15)),),
                                        ]
                                    ),
                                  )
                              ) : Text(''),
                              user.NewPoints == 1 ? Container(

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(right: 15.0),
                                            child: Text("New User Discount:",
                                              style: GoogleFonts.roboto(textStyle: TextStyle(
                                                  color: Colors.black, fontSize: 15)),),
                                          ),
                                          Text('£5', style: GoogleFonts.roboto(
                                              textStyle: TextStyle(fontSize: 15)),),
                                        ]
                                    ),
                                  )
                              ) : Text(''),


                            ],
                          );
                        }
                    )

                ),
          CardForm(
                          formKey: formKey,
                          card: card
                      ),
                      Container(
                        child: RaisedButton(
                            color: Color.fromRGBO(212, 194, 252, 10),
                            textColor: Colors.white,
                            child: const Text('Pre-pay', style: TextStyle(fontSize: 20)),
                            onPressed: () {
                              formKey.currentState.validate();
                              formKey.currentState.save();
                              cardPayment(context);
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:10.0),
                        child: Container(
                          child: RaisedButton(
                              color: Color.fromRGBO(212, 194, 252, 10),
                              textColor: Colors.white,
                              child: const Text('Deposit', style: TextStyle(fontSize: 20)),
                              onPressed: () {
                                setState(() {
                                  depoist = true;
                                });
                                formKey.currentState.validate();
                                formKey.currentState.save();
                                cashPayment(context);
                              }
                          ),
                        ),
                      ),




                //
                // Padding(
                //   padding: EdgeInsets.only(top: 25),
                //   child: GestureDetector(
                //     onTap:(){
                //       cardPayment(context);
                //
                //
                //
                //     },
                //     child: Container(
                //       alignment: Alignment.center,
                //       width: 250,
                //       height: 70,
                //
                //       decoration: BoxDecoration(
                //         color: Color.fromRGBO(212, 194, 252, 100),
                //       ),
                //       child: Text(
                //           "Pre-Pay Booking",
                //           style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold ))),
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.only(top: 25),
                //   child: GestureDetector(
                //     onTap:(){
                //       cashPayment(context);
                //
                //     },
                //     child: Container(
                //       alignment: Alignment.center,
                //       width: 250,
                //       height: 70,
                //
                //       decoration: BoxDecoration(
                //         color: Color.fromRGBO(212, 194, 252, 100),
                //       ),
                //       child: Text(
                //           "Deposit",
                //           style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold ))),
                //     ),
                //   ),
                // ),
              ],

            ),
          ),
        ),
      ),
    );
      // new SingleChildScrollView(
      //   child: new GestureDetector(
      //     onTap: () {
      //       FocusScope.of(context).requestFocus(new FocusNode());
      //     },
      //     child: SafeArea(
      //       child: Column(
      //         children: [
      //           CardForm(
      //               formKey: formKey,
      //               card: card
      //           ),
      //           Container(
      //             child: RaisedButton(
      //                 color: Color.fromRGBO(212, 194, 252, 10),
      //                 textColor: Colors.white,
      //                 child: const Text('Pre-pay', style: TextStyle(fontSize: 20)),
      //                 onPressed: () {
      //                   formKey.currentState.validate();
      //                   formKey.currentState.save();
      //                   cardPayment(context);
      //                 }
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(top:10.0),
      //             child: Container(
      //               child: RaisedButton(
      //                   color: Color.fromRGBO(212, 194, 252, 10),
      //                   textColor: Colors.white,
      //                   child: const Text('Deposit', style: TextStyle(fontSize: 20)),
      //                   onPressed: () {
      //                     setState(() {
      //                       depoist = true;
      //                     });
      //                     formKey.currentState.validate();
      //                     formKey.currentState.save();
      //                     cashPayment(context);
      //                   }
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

  }

  buy(context) async{
    dynamic totalCost;
    totalCost = double.parse(widget.price);
    amount = ((totalCost + service_charge) * 100).toInt();

    print(deposits);

    if(deposits) {
      totalCost = double.parse(widget.price) * 0.35;
      print(totalCost);
      amount = ((totalCost + service_charge) * 100).toInt();
      print(amount);
    }
    if(!deposits&&int.parse(Promos) >= 1){
      totalCost = double.parse(widget.price) - 5.00;
      amount = ((totalCost + service_charge) * 100).toInt();
    }
    if(!deposits&&int.parse(Promo) >= 10){
      totalCost = double.parse(widget.price) - 10.00;
      amount = ((totalCost + service_charge) * 100).toInt();
    }
    if(deposits && amount < 500){
      setState(() {
        fee = 500;
      });
    }

    if(amount < 0){
      return amount = 0.0;
    }

    if(!deposits && amount < 500){
      setState(() {
        fee = 0;
      });
    }
    final StripeCard stripeCard = card;
    //final String customerEmail = getCustomerEmail();

    if(!stripeCard.validateCVC()){showAlertDialog(context, "Error", "CVC not valid."); return;}
    if(!stripeCard.validateDate()){showAlertDialog(context, "Errore", "Date not valid."); return;}
    if(!stripeCard.validateNumber()){showAlertDialog(context, "Error", "Number not valid."); return;}

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard);
    String clientSecret = paymentIntentRes['paymentIntent']['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['paymentIntent']['status'];

    if(status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes = await confirmPayment3DSecure(clientSecret, paymentMethodId);

    if(paymentIntentRes['status'] != 'succeeded'){
      showAlertDialog(context, "Warning", "Canceled Transaction.");
      return;
    }

    if(paymentIntentRes['status'] == 'succeeded'){
      showAlertDialog(context, "Success", "Thanks for buying!");
      return;
    }
    showAlertDialog(context, "Warning", "Transaction rejected.\nSomething went wrong");
  }

  Future<Map<String, dynamic>> createPaymentIntent(StripeCard stripeCard) async{
    String clientSecret;
    Map<String, dynamic> paymentIntentRes, paymentMethod;
    try{
      paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
      print('working');
      clientSecret = await postCreatePaymentIntent(paymentMethod['id']);
      print('working');
      paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
      print('working');
    }catch(e){
      print("ERROR_CreatePaymentIntentAndSubmit: $e");
      print('error here');
      showAlertDialog(context, "Error", "Something went wrong.");
    }
    return paymentIntentRes;
  }

  Future<String> postCreatePaymentIntent(String paymentMethodId) async{
    String clientSecret;
    print(paymentMethodId);
    final http.Response response = await http.post(
      '$postCreateIntentURL?amount=$amount&currency=GBP&paym=${paymentMethodId}&StripId=${widget.StripeID}&fee=$fee&email=${currentUser.email}',
    );
    print(json.decode(response.body) != null);
    clientSecret = json.decode(response.body);
    return clientSecret;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId) async{
    Map<String, dynamic> paymentIntentRes_3dSecure;
    try{
      await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
    }catch(e){
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.");
    }
    return paymentIntentRes_3dSecure;
  }


  String getCustomerEmail(){
    String customerEmail;
    //Define how to get this info.
    // -Ask to the customer through a textfield.
    // -Get it from firebase Account.
    customerEmail = "jaffakakes28@gmail.com";
    return customerEmail;
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(), // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}
