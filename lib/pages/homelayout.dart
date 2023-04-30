import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapp/pages/reports.dart';
import 'package:riderapp/pages/shifts.dart';
import 'package:riderapp/pages/summry.dart';
import '../main.dart';
import 'deliveries.dart';
import 'orders.dart';
import 'package:audioplayers/audioplayers.dart';
Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message)async{
  if (message.notification!=null) {
      print('firebaseMessagingBackgroundHandler');
      // showLocalNotification('Yay you did it!','Congrats on your first local notification');
  }
}

class HomeLayout extends StatefulWidget {
  int Index;
   HomeLayout({Key key, this.Index}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}
class _HomeLayoutState extends State<HomeLayout> {
  int SelectedIndex;
  double lat;
  double lag;

  Future getPostion()async{
    bool services;
    services = await Geolocator.isLocationServiceEnabled();
    print(services);
  }



  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      return false;
    }
    return true;
  }

  var fbm = FirebaseMessaging.instance;











  @override
  void initState() {
    SelectedIndex = widget.Index;
    getPostion();
    _handleLocationPermission();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((message){

      if (message.notification.body!=null){

        Map<String, dynamic> jsonMap = jsonDecode(message.notification.body);
        print(jsonMap);

        final order_ref = jsonMap['order_ref'];
        final distance = jsonMap['distance'];
        final delivery_time = jsonMap['duration'];
        final delivery_price = jsonMap['delivery_price'];
        final name = jsonMap['store']['name'];
        final address = jsonMap['store']['address'];
        final destination =jsonMap['destination']!=null? jsonMap['destination']['label']:null;

        showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context, builder: (context){
          return Summry(
            order_ref: order_ref,
            name: name,
            distance: distance,
            delivery_price: delivery_price,
            delivery_time: delivery_time,
            address: address,
            destination: destination,
          );
        });
      }
    },);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification.body!=null){
        Map<String, dynamic> jsonMap = jsonDecode(message.notification.body);
        print(jsonMap);

        final order_ref = jsonMap['order_ref'];
        final distance = jsonMap['distance'];
        final delivery_time = jsonMap['duration'];
        final delivery_price = jsonMap['delivery_price'];
        final name = jsonMap['store']['name'];
        final address = jsonMap['store']['address'];
        final destination =jsonMap['destination']!=null? jsonMap['destination']['label']:null;

        // {notification_type:NEW_ORDER,order_ref: A-2987,delivery_price: 10.00,
        //  store:{name: Valhalla,address: 5Q2X+52V، العيون 70000},destination:null}

        showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context, builder: (context){
          return Summry(
            order_ref: order_ref,
            name: name,
            distance: distance,
            delivery_price: delivery_price,
            delivery_time: delivery_time,
            address: address,
            destination: destination,
          );
        });
      }
    });

    fbm.getToken();
    super.initState();
  }

  List<Widget>screens=[
    Orders(),
    Deliveries(),
    Shifts(),
    Reports(),
  ];

  @override
  Widget build(BuildContext context){

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Color(0xfff3f4f6),
          bottomNavigationBar:
          BottomNavigationBar(
              showSelectedLabels: true,
              selectedItemColor:Colors.red,
              type: BottomNavigationBarType.fixed,
              onTap: (index){
                setState(() {
                  SelectedIndex = index;
                  _handleLocationPermission();
                  // getCurrentPosition();
                });
              },
              currentIndex: SelectedIndex,
              items: [
                BottomNavigationBarItem(icon:Icon(Icons.sticky_note_2_outlined), label: 'الطلبات'),
                BottomNavigationBarItem(icon:Icon(Icons.delivery_dining_outlined), label: 'تسليمات'),
                BottomNavigationBarItem(icon:Icon(Icons.timer_outlined),label: 'ساعات'),
                BottomNavigationBarItem(icon:Icon(Icons.report_gmailerrorred),label: 'التقارير'),

              ]),
        // appBar: AppBar(backgroundColor: Colors.white,elevation: 0,),
        body:screens[SelectedIndex]
      ),
    );
  }

}
