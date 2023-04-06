import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapp/pages/homelayout.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/cached_helper.dart';

class OrderDetails extends StatefulWidget {
  final order_ref;
  final lat;
  final lag;
  const OrderDetails({Key key, this.order_ref, this.lat,this.lag}) : super(key: key);
  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}
class _OrderDetailsState extends State<OrderDetails>{
  final _key = UniqueKey();
   double lat;
   double lag;
   bool locationCollected = false;
  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low).then((value) {
      lat = value.latitude;
      lag = value.longitude;
      locationCollected = true;
      setState(() {});
      return value;
    });

    return position;
  }


  bool isLoading=true;
  String token = Cachehelper.getData(key: "token");

  void initState() {
    getLocation();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message){
      print('notification ${message.data}');
      if (message.data!=null){
        Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);
        if(jsonMap['status'] == 'ready'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetails(
            order_ref: widget.order_ref,)));
        }
      }
    },);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      // showLocalNotification('Yay you did it!','Congrats on your first local notification');
      if (message.data!=null){
        Map<String, dynamic> jsonMap = jsonDecode(message.data['payload']);

        if(jsonMap['status'] == 'ready'){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetails(
            order_ref: widget.order_ref,
          )));
        }


      }
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: ()async{
          await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeLayout(Index: 0,)), (route) => false);
          return true;
        },
        child: Scaffold(
          backgroundColor: Color(0xfff3f4f6),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('استلام الطلب',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20
            ),),
            leading: InkWell(
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeLayout(Index: 0,)), (route) => false);
              },
              child: Icon(Icons.arrow_back,color: Colors.black),
            ),
          ),
          body:
          SafeArea(
            child: Stack(
              children: <Widget>[
                 locationCollected?WebView(
                  key: _key,
                  initialUrl:"https://driverapp.canariapp.com/orders/${widget.order_ref}?token=${token}&lat=${lat}&lng=${lag}",
                  zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  javascriptChannels:<JavascriptChannel>{
                    JavascriptChannel(
                      name: 'messageHandler',
                      onMessageReceived: (JavascriptMessage message) {
                        Map<String, dynamic> data = jsonDecode(message.message);
                        print(data);
                        if(data['action'] == "NAVIGATE_MAP"){
                          launch("https://www.google.com/maps/search/?api=1&query=${data['payload']['lat']},${data['payload']['lng']}");
                        }else if(data['action'] =="CALL_PHONE"){
                          launch("tel://${data['payload']}");
                        }else if(data['action'] =="ORDER_COMPLETE"){
                          print('---------------------------------------------');
                          print(data['action']);
                          print('---------------------------------------------');
                          setState(() {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeLayout(Index: 0,)), (route) => false);
                          });
                          }
                      },)},
                  onPageFinished: (finish){
                    setState(() {
                      isLoading = false;
                    });
                  },
                ):Stack(),
                isLoading?Center(child: CircularProgressIndicator(color: Colors.red,backgroundColor:Color(0xFFFFCDD2)))
                    : Stack(),

              ],
            ),
          ),
        ),
      ),
    );
  }
  void printFullText(String text) {
    final pattern = RegExp('.{1,800}');
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}


// AudioPlayer player = new AudioPlayer();
// String mp3Uri = "";
//
// void _playSound() {
//   player.play(mp3Uri);
// }
//
// void _stopSound() {
//   player.stop();
// }