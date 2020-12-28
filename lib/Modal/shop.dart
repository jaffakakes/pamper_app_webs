import 'package:cloud_firestore/cloud_firestore.dart';



class Shop {
  final String id;
  final String username;
  final String url;
  final String email;
  final String bio;
  final String location;
  final String stripeId;
  final String policy;
  final String category;

  Shop({
    this.id,
    this.username,
    this.url,
    this.email,
    this.bio,
    this.location,
    this.stripeId,
    this.policy,
    this.category
  });

  factory Shop.fromDocument(DocumentSnapshot doc){
    return Shop(
        id: doc.documentID,
        email: doc['email'],
        username: doc['username'],
        url: doc['url'],
        bio: doc['bio'],
        location: doc['location'],
        stripeId: doc['stripeId'],
        policy: doc['policy'],
        category: doc['Category']


    );
  }
}