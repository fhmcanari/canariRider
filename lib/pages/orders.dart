import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:riderapp/pages/orders_details.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main.dart';
import '../shared/cached_helper.dart';
import '../shared/constant.dart';
import 'homelayout.dart';

class Orders extends StatefulWidget {


   Orders({Key key,}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {

  final _key = UniqueKey();
  bool isLoading=true;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String token = Cachehelper.getData(key: "token");
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xfff3f4f6),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('الطلبات',style: TextStyle(
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
                initialUrl:'${url}/orders?token=${token}',
                zoomEnabled: false,
                javascriptMode: JavascriptMode.unrestricted,
                javascriptChannels:<JavascriptChannel>{
                  JavascriptChannel(
                    name: 'messageHandler',
                    onMessageReceived: (JavascriptMessage message) {
                       Map<String, dynamic> data = jsonDecode(message.message);
                      if(data['action'] =="PREVIEW_SHIFTS_PAGE"){
                        setState(() {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeLayout(Index: 2,)), (route) => false);
                        });
                      }else{
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetails(
                            order_ref: data['order_ref'],
                          )));
                        });
                      }

                    },)},
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
      ),
    );
  }
}
