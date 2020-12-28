import 'package:flutter/material.dart';


import 'package:google_fonts/google_fonts.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pamper_app_web/receiptPage.dart';

import 'Services/Database.dart';
import 'Signupcontinue.dart';
import 'Widgets/Progressbars.dart';



class timeAndDate extends StatefulWidget {
  final String Time;
  final String price;
  final String services;
  final String shopProfileName;
  final String category;
  final String shopProfileId;
  final String StripeID;
  final String shopProfilePic;
  final String email;
  timeAndDate(this.Time, this.price, this.services,this.shopProfileName, this.category, this.shopProfileId,this.StripeID, this.shopProfilePic, this.email);
  @override
  _timeAndDateState createState() => _timeAndDateState();
}

class _timeAndDateState extends State<timeAndDate> {
  TextEditingController DateFieldTextEditingController = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  Stream Times;
  bool _DateFieldvaild = false;
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  getTimes(shopProfileId,cat,services)async{
    return  Firestore.instance.collection('Times').document(shopProfileId).collection('category')
        .document(cat)
        .collection('services')
        .document(services)
        .collection('Dates').snapshots();
  }

  TimeList(){

    print(widget.StripeID);
    if(Times!=null){
      return StreamBuilder(
        stream: Times,
        builder: (context,snapshot) {
          if (snapshot.data == null) return circularProgress();
          if(snapshot.data.documents.length <= 0 )return Center(child: displayNoSearchResultScreen());
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, i) {

              print('this${DateTime.now().microsecondsSinceEpoch}');
              //  deleteTimeList(snapshot.data.documents[i].data['setsinorder'], String currentUser, Date,)
              return new DateTime.now().microsecondsSinceEpoch < snapshot.data.documents[i].data['setsinorder']? ListTile(
                  title: Container(
                      alignment: Alignment.center,
                      width: 150,


                      decoration: BoxDecoration(
                        color: Color.fromRGBO(212, 194, 252, 100),
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date:'),
                                Text(snapshot.data.documents[i].data['Date'],
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Time:'),
                                Text(snapshot.data.documents[i].data['Times'],
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)))

                              ],
                            )
                          ],
                        ),
                      )
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            SignUp(
                                widget.Time,
                                widget.price,
                                widget.services,
                                snapshot.data.documents[i].data['Date'],
                                snapshot.data.documents[i].data['Times'],
                                snapshot.data.documents[i].documentID,
                                widget.shopProfileName,
                                widget.category,
                                widget.shopProfileId,
                                widget.StripeID,
                                widget.shopProfilePic,
                                widget.email)
                    )
                    );
                  }
              ):Text('time unavailable', style: TextStyle(fontSize: 0.000000000000000000000000000000000000000000000000000000001),);
            }
            ,

          );
        },
      );
    }else{
      return circularProgress();
    }
  }
  deleteTimeList(docId, String currentUser, Date,) {
    Firestore.instance.collection('Times').document(currentUser).collection('category')
        .document(widget.category)
        .collection('services')
        .document(widget.services)
        .collection('Dates')
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    GetTimes();
    super.initState();
  }

  GetTimes(){
    getTimes(widget.shopProfileId,widget.category,widget.services).then((results){
      setState(() {
        Times = results;
      });
    });
  }
  Container displayNoSearchResultScreen(){

    return Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Icon(Icons.access_time, color: Color.fromRGBO(212, 194, 252,10), size: 150.0),
              Text(
                "No time available on ", textAlign: TextAlign.center, style: GoogleFonts.roboto(textStyle: TextStyle(color: Color.fromRGBO(212, 194, 252,10))),
              )
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return
      Scaffold(

        backgroundColor: Colors.white,
        key:_scaffoldGlobalKey ,
        body: Container(

          child: Column(

              children:[
                SizedBox(
                          height: 110,

                          child: Container(
                            color: Color.fromRGBO(212, 194, 252,10),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Container(

                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "3/5",
                                      style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white60, fontSize: 20)),
                                    ),

                                  ),
                                ),
                                Container(

                                  alignment: Alignment.center,
                          child: Text(
                            "Availability",
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),


                TimeList()
              ]
          ),
        ),
      );
  }
}
