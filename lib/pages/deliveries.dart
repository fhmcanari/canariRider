import 'dart:async';
import 'package:location/location.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../shared/cached_helper.dart';
import '../shared/constant.dart';

class Deliveries extends StatefulWidget {
  const Deliveries({Key key}) : super(key: key);

  @override
  State<Deliveries> createState() => _DeliveriesState();
}

class _DeliveriesState extends State<Deliveries> {
  final _key = UniqueKey();
  bool isLoading=true;
  String token = Cachehelper.getData(key: "token");
  StreamSubscription<Position> ps;
  var location = Location();

  Future checkGps() async {
    bool ison = await location.serviceEnabled();
    if (!ison) { //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        print("GPS device is turned ON");
      }else{
        print("GPS Device is still OFF");
      }
    }
  }
  @override
  void initState() {

    // ps = Geolocator.getPositionStream().listen(
    //       (Position position) {
    //       print(position == null ? 'Unknown' : 'tracking ${position.latitude.toString()}, ${position.longitude.toString()}');
    //       print(position.latitude);
    //       print(position.longitude);
    //     });

    // Location location = new Location();
    // location.onLocationChanged().listen((event){
    //   //this function gets called every time the location changes
    //   //so you just have to insert it database/firestore here
    //   //effectively making it like the way you want
    //   //update your lat lang
    // });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xfff3f4f6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('تسليمات',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),
      ),
      body:SafeArea(
        child: Stack(
          children: <Widget>[
            WebView(
              key: _key,
              initialUrl:'${url}/deliveries?token=${token}',
              zoomEnabled: false,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish){
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading ?Center(child: CircularProgressIndicator(color: Colors.red,backgroundColor:Color(0xFFFFCDD2)))
                : Stack(),
          ],
        ),
      ),
    );
  }
}
