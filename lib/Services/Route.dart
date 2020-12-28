import 'package:fluro/fluro.dart';

import '../Policy page.dart';
import '../categoryPage.dart';

class Fluro {
  static FluroRouter router = FluroRouter();
  //Define  your routers here
  static void setupRouter() {
    router.define('/:userId', handler: _userHandler);
  }
  //Add your handlers here

  static Handler _userHandler = Handler(handlerFunc: (context, Map<String, dynamic> params) => BookingScreen(params['userId'].first));
}