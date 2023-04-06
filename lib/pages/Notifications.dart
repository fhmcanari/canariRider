import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('إشعارات',style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.separated(
              physics: BouncingScrollPhysics(),
               shrinkWrap: true,
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.asset('assets/logo.jpg',fit: BoxFit.cover,)),
                            ),
                            SizedBox(width:10,),
                            Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('تعرف على التأمين الذي تحافظ عليه كناري',style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500
                                    ),),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('قبل 12 ساعة',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),),
                                        Text('جديد',style: TextStyle(
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.bold
                                        ),)
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context,index){
                  return Container(
                    height: 0.3,
                    width: double.infinity,
                    color: Colors.grey[400],
                  );
                },
                itemCount: 8,
            )
          ],
        ),
      ),
    );
  }
}
