import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:riderapp/pages/orders.dart';
import 'package:riderapp/pages/reports.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../shared/cached_helper.dart';
import '../shared/constant.dart';

class Shifts extends StatefulWidget {
  const Shifts({Key key}) : super(key: key);

  @override
  State<Shifts> createState() => _ShiftsState();
}

class _ShiftsState extends State<Shifts> with SingleTickerProviderStateMixin{
  final _key = UniqueKey();
  bool isLoading=true;
  TabController tabcontroller;
  @override
  void initState() {
    tabcontroller  = TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String token = Cachehelper.getData(key: "token");
    return Scaffold(
      backgroundColor: Color(0xfff3f4f6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        bottom: TabBar(
          padding: EdgeInsets.only(left: 20,right: 10,top: 0,bottom: 5),
          unselectedLabelColor: Colors.grey,

          labelColor: Colors.white,
          indicator: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30)
          ),
         controller: tabcontroller,
          tabs: [
            Tab(
              child: Text('ساعات العمل',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            ),
            Tab(
              child: Text('ملخصات',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
            ),


          ],
        ),
        title: Text('ساعات العمل',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20
        ),),

      ),
      body:TabBarView(
          controller:tabcontroller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl:'${url}/shifts?token=${token}',
                  zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish){
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading ? LinearProgressIndicator(color: Colors.red,backgroundColor:Color(0xFFFFCDD2))
                    : Stack(),
              ],
            ),
            Stack(
              children: <Widget>[
                WebView(
                  key: _key,
                  initialUrl:'${url}/shifts/booked?token=${token}',
                  zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageFinished: (finish){
                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
                isLoading ?LinearProgressIndicator(color: Colors.red,backgroundColor:Color(0xFFFFCDD2))
                    : Stack(),
              ],
            ),

          ]
      ),
    );
  }
}
