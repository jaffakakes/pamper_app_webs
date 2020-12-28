import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pamper_app_web/servicePage.dart';
import 'Modal/shop.dart';
import 'Widgets/Progressbars.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final String shopProfileId;

  BookingScreen(this.shopProfileId,);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final dateFormat = DateFormat("EEEE, MMMM d, yyyy 'at' h:mma");
  final timeFormat = DateFormat("h:mm a");
  DateTime date;
  TimeOfDay time;

  Future getCategory() async {
    QuerySnapshot qn = await Firestore.instance.collection("Services")
        .document(widget.shopProfileId)
        .collection("Category")
        .getDocuments();
    return qn.documents;
  }
  // Widget searchTile({String Category, String Description,}){
  //   return SingleChildScrollView(
  //     child:     GestureDetector(
  //       onTap: () => Navigator.push(context, MaterialPageRoute(
  //           builder: (context) => pickService(Category, widget.shopProfileId, widget.shopProfileName,widget.StripeID,widget.shopProfilePic, widget.email)
  //       )),
  //       child: Container(
  //
  //         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
  //         child: Container(
  //           // height: 70,
  //           //
  //           // width: 120,
  //           color: Color.fromRGBO(212, 194, 252, 10),
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //
  //               children: [
  //                 Column(
  //                   children:[
  //                     Container(
  //                       child: Padding(
  //                         padding: EdgeInsets.only(top: 20),
  //                         child: Text(Category, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25,  fontWeight: FontWeight.bold,)
  //                         ),
  //                       ),
  //                     ),
  //                     Text(Category, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10,))
  //                   ],
  //                 ),
  //                 Icon(Icons.arrow_forward, color: Colors.white,)
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget searchList(shopProfileId, shopProfileName,StripeID,shopProfilePic,email) {
    return FutureBuilder(
        future: getCategory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return circularProgress();
          return ListView.builder(
            shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return  ListTile(
                  title:  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => pickService(snapshot.data[index].data["Category"], shopProfileId, shopProfileName,StripeID,shopProfilePic,email)
                    )),
                    child: Container(
                      // height: 70,

                      // width: 120,
                      color: Color.fromRGBO(212, 194, 252, 10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            Column(
                              children:[
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(snapshot.data[index].data["Category"], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 25,  fontWeight: FontWeight.bold,)
                                    ),
                                  ),
                                ),
                                Text(snapshot.data[index].data["Description"], textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10,))
                              ],
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
    );
  }
  noCategoryDisplay(){
    return Container(
      child: Center(
          child: ListView(
              shrinkWrap: true,
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
                              "1/5",
                              style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white60, fontSize: 20)),
                            ),

                          ),
                        ),
                        Container(

                          alignment: Alignment.center,
                          child: Text(
                            "Choose category",
                            style: GoogleFonts.roboto(textStyle: TextStyle(color: Colors.white, fontSize: 35)),
                          ),

                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.list, color: Color.fromRGBO(212, 194, 252,10), size: 200.0),
                Text(
                  "No Category Shop have no services added", textAlign: TextAlign.center, style: GoogleFonts.roboto(textStyle: TextStyle(color: Color.fromRGBO(212, 194, 252,10))),
                ),


              ]
          )

      ),
    );


  }




  @override

  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance.collection("shopkeepers").document(widget.shopProfileId).get(),
    builder: (context,dataSnapshot) {
      if (!dataSnapshot.hasData) {
        return circularProgress();
      }

      Shop shop = Shop.fromDocument(dataSnapshot.data);
      return Scaffold(
        backgroundColor: Colors.white,

        body: getCategory() == null ? noCategoryDisplay() : Column(
            children: [
              SizedBox(
                height: 110,

                child: Container(
                  color: Color.fromRGBO(212, 194, 252, 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(

                          alignment: Alignment.topLeft,
                          child: Text(
                            "1/5",
                            style: GoogleFonts.roboto(textStyle: TextStyle(
                                color: Colors.white60, fontSize: 20)),
                          ),

                        ),
                      ),
                      Container(

                        alignment: Alignment.center,
                        child: Text(
                          "Choose category",
                          style: GoogleFonts.roboto(textStyle: TextStyle(
                              color: Colors.white, fontSize: 35)),
                        ),

                      ),
                    ],
                  ),
                ),
              ),
              searchList(shop.id, shop.username,shop.stripeId,shop.url, shop.email)]),


      );
    }
    );

  }
}