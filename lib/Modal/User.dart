import 'package:cloud_firestore/cloud_firestore.dart';



class User {
  final String id;
  final String username;
  final String url;
  final String email;
  final String location;
  final int Points;
  final int NewPoints;


  User({
    this.id,
    this.username,
    this.url,
    this.email,
    this.location,
    this.Points,
    this.NewPoints
  });

  factory User.fromDocument(DocumentSnapshot doc){
    return User(
        id: doc.documentID,
        email: doc['email'],
        username: doc['username'],
        url: doc['url'],
        location: doc['location'],
        Points: doc['promo'],
        NewPoints: doc['promos']

    );
  }
}