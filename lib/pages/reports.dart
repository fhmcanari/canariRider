import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../shared/cached_helper.dart';
import '../shared/constant.dart';

class Reports extends StatefulWidget {
  const Reports({Key key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  final _key = UniqueKey();
  bool isLoading=true;
  @override
  Widget build(BuildContext context) {
    String token = Cachehelper.getData(key: "token");
    return Scaffold(
      backgroundColor: Color(0xfff3f4f6),
      appBar: AppBar(
        backgroundColor: Colors.white,
         elevation: 0,
        title: Text('التقارير',style: TextStyle(
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
                initialUrl:'${url}/earns?token=${token}',
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
        ),
    );
  }
}
