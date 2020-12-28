

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pamper_app_web/Modal/User.dart';


class DatabaseMethods{
  gettimes(shopProfileId,cat,services)async{
    return Firestore.instance.collection('Times').document(shopProfileId).collection('category')
        .document(cat)
        .collection('services')
        .document(services)
        .collection('Dates').snapshots();

  }
  getUserByUsername(String username)async{
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username).getDocuments();
  }
  getUserByUserEmail(String userEmail)async{
    return await Firestore.instance.collection('users')
        .where("email",isEqualTo: userEmail).getDocuments();
  }
  getUserByUrl()async{
    return await Firestore.instance.collection('users')
        .where("url").getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap);
  }
  getUserUserName(){
    return Firestore.instance.collection('users')
        .where("email").getDocuments();
  }
  getShopByUsername(String username,)async{
    //search user name by name not downloading all the database and then searching
    return await Firestore.instance.collection("shopkeepers")
        .where("username", isEqualTo: username).getDocuments();
  }
  getConversationMessages(String chatRoomId)async{
    return  Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: false)
        .snapshots();
  }
  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }
  addLatestmessage(String chatRoomId, Time){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .updateData(Time).catchError((e){print(e.toString());});
  }
  addRead(String chatRoomId, Time){
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .updateData(Time).catchError((e){print(e.toString());});
  }
  getChatRooms(String userName)async{
    return  Firestore.instance.collection("ChatRoom")
        .where("users", arrayContains: userName)
        .orderBy("time", descending: false)
        .snapshots();
  }
  createChatRoom(String charRoomId, chatRoomMap){
    Firestore.instance.collection("ChatRoom")
        .document(charRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }
  pendingBookings(String shopProfileId,bookingId,categoryMap){
    Firestore.instance.collection("Pending Bookings")
        .document(shopProfileId)
        .collection("users")
        .document(bookingId)
        .setData(categoryMap).catchError((e){
      print(e.toString());
    });
  }
  getPendingRefunds(usersName)async{
    return Firestore.instance.collection("Cancel Users")
        .where("User", isEqualTo: usersName)
        .snapshots();

  }

  deletePendingRefunds(docId){
    Firestore.instance.collection("Cancel Users").document(docId).delete();
  }

  addPastBookings(currentUuser,data){
    Firestore.instance.collection("PastBookings").document(currentUuser).collection('pastbookings').add(data);
  }

  getPastBookings(currentUser)async{
    return Firestore.instance.collection("PastBookings").document(currentUser).collection('pastbookings').snapshots();

  }

  getBooking(userName,)async{
    return  Firestore.instance.collection("Bookings").document('Books')
        .collection("bookings")
        .where("users", arrayContains: userName)
        .orderBy("time", descending: false)
        .snapshots();
  }

  getBookings(DocId)async{
    return await Firestore.instance.collection("Bookings")
        .document('Books')
        .collection("bookings").document(DocId).get();
  }
  getRequestedBooking(String userName, String shopKeeperId)async{
    return  Firestore.instance.collection("Pending Bookings")
        .document(shopKeeperId)
        .collection("users")
        .where("users", arrayContains: userName)
        .snapshots();

  }

  getCat(catName)async {
    return Firestore.instance.collection("shopkeepers")
        .where('Category', isEqualTo: catName ).getDocuments();

  }
  getLocation(locations)async {
    return  Firestore.instance.collection("shopkeepers")
        .where('location', isEqualTo: locations ).getDocuments();
  }
  getUser(Id) async{
    return Firestore.instance.collection("Users").where("id", isEqualTo: Id).snapshots();
  }

  deletecard(shopId, CardMap){
    return Firestore.instance.collection("Cancel")
        .document(shopId)
        .collection("cancels")
        .add(CardMap).catchError((e){print(e.toString());});

  }
  deletePrice(String shopId, price){
    Firestore.instance.collection("shopkeepers")
        .document(shopId).updateData({'earnings':FieldValue.increment(-price)}).catchError((e){
      print(e.toString());
    });
  }

  addcancels(String userId,){
    Firestore.instance.collection("Users")
        .document(userId).updateData({'cancels':FieldValue.increment(1)}).catchError((e){
      print(e.toString());
    });
  }

  addCancelBooking(CardMap){
    return Firestore.instance.collection("Cancel Users")
        .add(CardMap).catchError((e){print(e.toString());});
  }
  deleteBooking(DocId){
    Firestore.instance.collection("Bookings")
        .document('Books')
        .collection("bookings").document(DocId).delete();
  }

  shopNumberAdd(String shopId, price){
    Firestore.instance.collection("shopkeepers")
        .document(shopId).updateData({'earnings':FieldValue.increment(price)}).catchError((e){
      print(e.toString());
    });
  }
  shopBookingsAdd(String shopId){
    Firestore.instance.collection("shopkeepers")
        .document(shopId).updateData({'bookings':FieldValue.increment(1)}).catchError((e){
      print(e.toString());
    });
  }
  addCardPromo(Id){
    Firestore.instance.collection("Users")
        .document(Id).updateData({'promo':FieldValue.increment(1)}).catchError((e){
      print(e.toString());
    });
  }
  deleteCardPromo(Id){
    Firestore.instance.collection("Users")
        .document(Id).updateData({'promo':FieldValue.increment(-10)}).catchError((e){
      print(e.toString());
    });
  }
  deletePromo(Id){
    Firestore.instance.collection("Users")
        .document(Id).updateData({'promos':FieldValue.increment(-1)}).catchError((e){
      print(e.toString());
    });
  }
  deleteCardPromoone(Id){
    Firestore.instance.collection("Users")
        .document(Id).updateData({'promo':FieldValue.increment(-1)}).catchError((e){
      print(e.toString());
    });
  }

  getTimeList(String Date,currentUser){
    Firestore.instance.collection('Times').document(currentUser)
        .collection('Dates').document(Date).collection('Time').snapshots();
  }

  deleteTimeList(docId, String currentUser, date, category,service){
    Firestore.instance.collection('Times').document(currentUser)
        .collection('category').document(category).collection('services').document(service).collection('Dates').document(docId).delete().catchError((e){
      print(e);
    });
  }
  acceptedBooking(String bookingId,categoryMap){
    Firestore.instance.collection("Bookings")
        .document('Books')
        .collection("bookings")
        .add(categoryMap).catchError((e){
      print(e.toString());
    });
  }
  promoBuys(categoryMap){
    Firestore.instance.collection("Promo")
        .document('promo')
        .collection("shops")
        .add(categoryMap).catchError((e){
      print(e.toString());
    });
  }
  getPromo(code){
    return Firestore.instance.collection('Promo').document('Promocode').get();
  }

  Future<String> createUser(User user) async {
    String retVal = "error";

    try {
      await Firestore.instance.collection("shopkeepers").document(user.id).setData({
        "policy": 'Shop has not made a shop policy',
        "tier": 1,
        'bookings': 0,
        'email': user.email.trim(),
        'id': user.id,
        'bio':"",
        'earnings':0,
        'username': user.username.trim(),
        'promo': 0,
        'promos':1,
        'url':  'https://lh3.googleusercontent.com/ogw/ADGmqu-_qMTv43QzpYGWrLoAk8hxUqJBDdDXzlUt-CPX=s192-c-mo',
      });
      await Firestore.instance.collection("Users").document(user.id).setData({
        'location': '',
        'email': user.email.trim(),
        'id': user.id,
        'profileName':user.username.trim(),
        'promo': 0,
        'promos':1,
        'url':  'https://lh3.googleusercontent.com/ogw/ADGmqu-_qMTv43QzpYGWrLoAk8hxUqJBDdDXzlUt-CPX=s192-c-mo',
        'username': user.username.trim(),
      });
      retVal = "success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }


}