import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key key}) : super(key: key);

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('تحويلات',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
        ),),
      ),
      body: Column(
        children: [

        ],
      ),
    );
  }
}
