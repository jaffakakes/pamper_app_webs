import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import 'Widgets/Progressbars.dart';
import 'datePage.dart';



class pickService extends StatefulWidget {
  final String category, shopProfileId, shopProfileName,StripeID, shopProfilePic, email;
  pickService(this.category, this.shopProfileId, this.shopProfileName,this.StripeID,this.shopProfilePic, this.email);

  @override
  _pickServiceState createState() => _pickServiceState();
}

class _pickServiceState extends State<pickService> {


  Future getservices(String category)async{
    return  Firestore.instance.collection("Services")
        .document(widget.shopProfileId)
        .collection("Category")
        .document(widget.category)
        .collection("service")
        .snapshots();
  }

  Stream servicesStream;
  Widget ChatMessageList(){
    print(widget.StripeID);
    return StreamBuilder(
      stream: servicesStream,
      builder: (context, snapshot){
        if (snapshot.data == null) return circularProgress();
        if(snapshot.data.documents.length==0) return displayNoSearchResultScreen();

        return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){

              return  ListTile(
                title:  GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                      builder: (context) => timeAndDate(
                          snapshot.data.documents[index].data["Time"],
                          snapshot.data.documents[index].data["price"],
                          snapshot.data.documents[index].data["services"],
                          widget.shopProfileName,
                          widget.category,
                          widget.shopProfileId,
                          widget.StripeID,
                          widget.shopProfilePic,
                          widget.email

                      )
                  )),
                  child: Container(

                          child: Column(
                              children: [


                                Container(
                                    width: 350,
                                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(212, 194, 252,99),
                                          offset: const Offset(1.0, 1.0),
                                          blurRadius: 1.0,
                                          spreadRadius: 1.0,
                                        ),
                                      ],
                                      color: Color.fromRGBO(212, 194, 252, 100),
                                    ),
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children:<Widget>[
                                          Column(

                                            children: <Widget>[


                                              Padding(
                                                padding: const EdgeInsets.only(left:10.0),
                                                child: Container(
                                                    width: 330,

                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children:[

                                                          Text("Duration:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize:20)),),

                                                          Text(snapshot.data.documents[index].data["Time"], style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)), ),
                                                        ]
                                                    )
                                                ),
                                              ),

                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(left:10.0),
                                                child: Container(
                                                    width: 330,

                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children:[


                                                          Text("Cost:",textAlign: TextAlign.center, style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 20)),),


                                                          Text('£ ${snapshot.data.documents[index].data["price"]}', textAlign: TextAlign.center, style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)), ),
                                                        ]
                                                    )
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Padding(
                                                padding: const EdgeInsets.only(left:10.0),
                                                child: Container(
                                                    width: 330,
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children:[

                                                          Text("Service:", style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 20)),),

                                                          Text(snapshot.data.documents[index].data["services"], style: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 20)), )
                                                        ]
                                                    )
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Text(snapshot.data.documents[index].data["description"],style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white,fontSize: 15)),),
                                                ),
                                              ),


                                            ],
                                          ),

                                        ]
                                    )

                                ),



                              ]

                          ),
                        ),
                ),
              );


              //   ServicesTile(snapshot.data.documents[index].data["Time"],
              //     snapshot.data.documents[index].data["price"],
              //     snapshot.data.documents[index].data["services"],
              //     snapshot.data.documents[index].data["description"],
              //     widget.shopProfileName,
              //     widget.category,
              //     widget.shopProfileId,
              //     widget.StripeID,
              //     widget.shopProfilePic,
              //     widget.email
              //
              //
              // );
            });
      },
    );

  }
  displayNoSearchResultScreen(){
    return Container(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              Icon(Icons.sticky_note_2_rounded, color: Color.fromRGBO(212, 194, 252,10), size: 200.0),
              Text(
                "shop has not add a service yet", textAlign: TextAlign.center, style: GoogleFonts.roboto(textStyle: TextStyle(color: Color.fromRGBO(212, 194, 252,10))),
              )
            ],
          ),
        )
    );
  }

  void initState() {
    getservices(widget.category).then((value){
      setState(() {
        servicesStream = value;
      });

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:  Column(
              children: <Widget>[
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
                              "2/5",
                              style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white60, fontSize: 20)),
                            ),

                          ),
                        ),
                        Container(

                          alignment: Alignment.center,
                          child: Text(
                            "Choose service",
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),

                ChatMessageList(),
              ],
            ),

          );

  }
}
// class ServicesTile extends StatelessWidget {
//   final String Time;
//   final String price;
//   final String services;
//   final String description;
//   final String shopProfileName;
//   final String category;
//   final String shopProfileId;
//   final String StripeID;
//   final String shopProfilePic;
//   final String email;
//   ServicesTile(this.Time, this.price, this.services,this.description, this.shopProfileName, this.category, this.shopProfileId,this.StripeID,this.shopProfilePic, this.email);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
// }



