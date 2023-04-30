import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riderapp/shared/constant.dart';
import 'package:http/http.dart' as http;
import '../shared/cached_helper.dart';
import 'homelayout.dart';
import 'orders_details.dart';

class Summry extends StatefulWidget {
  final order_ref;
  final distance;
  final delivery_time;
  final delivery_price;
  final name;
  final address;
  final destination;
  final AudioPlayer advancedPlayer;
  const Summry({Key key, this.distance, this.delivery_price, this.name, this.address, this.destination, this.order_ref, this.advancedPlayer, this.delivery_time}) : super(key: key);
  @override
  State<Summry> createState() => _SummryState();
}

class _SummryState extends State<Summry> {
  String token = Cachehelper.getData(key: "token");
  bool isloading = false;
  bool isrefuse = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String audioasset = "assets/iphone.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  Uint8List audiobytes;

  static const maxSeconds = 30;
  int seconds = maxSeconds;
  Timer timer;
  void playAudio() async{
    int timesPlayed = 0;
    const timestoPlay = 30;
    await audioPlayer.playBytes(audiobytes).then((player) {
      audioPlayer.onPlayerCompletion.listen((event) {
        timesPlayed++;
        if (timesPlayed >= timestoPlay) {
          timesPlayed = 0;
          audioPlayer.stop();
        } else {
          audioPlayer.resume();
        }
      });
    });

  }

  void stopAudio() async{
    int result = await audioPlayer.stop();
    if(result == 1){ //play success
      print("audio is stoping");
    }else{
      print("Error while stop audio.");
    }
  }

  Future Reject(order_ref)async {
    isloading = false;
    setState(() {

    });
    final response = await http.post(
        Uri.parse('${url}/orders/refuse/${order_ref}'),
        headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${token}',}
    ).then((value){
      var data = json.decode(value.body);
      print(value.body);
      setState(() {

      });
    }).onError((error, stackTrace){
      print(error);
      setState(() {

      });
    });
  }

  void start(){
   timer = Timer.periodic(Duration(seconds:3), (_) {
     if(seconds>0){
       seconds--;
       setState(() {

       });
     }else if(seconds==0){
       timer.cancel();
       Reject(widget.order_ref);
       Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>HomeLayout(Index: 0,)), (route) => false);
     }
   });
  }
  void stop(){
    stopAudio();
    timer.cancel();
  }
  @override
  void initState() {
    start();
    Future.delayed(Duration.zero, () async {
      ByteData bytes = await rootBundle.load(audioasset);
      audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    }).then((value) {
      playAudio();
    });
    super.initState();
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 20,top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left:10,top: 10,),
                  child:TextButton(
                    child:isrefuse?CircularProgressIndicator(color: Colors.cyan): Text('رفض',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 17
                    ),),
                    onPressed: ()async{
                      stopAudio();
                      setState(() {
                        isrefuse = true;
                      });
                      final response = await http.post(
                          Uri.parse('https://api.canariapp.com/v1/partner/driver/orders/refuse/${widget.order_ref}'),
                          headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${token}',}
                      ).then((value){
                        var data = json.decode(value.body);
                        isrefuse = false;
                        print('==================================================');
                        print(data);
                        print('==================================================');
                        setState(() {

                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeLayout(
                           Index: 0,
                          )));
                        });
                      }).onError((error, stackTrace){
                        print(error);
                        setState(() {

                        });
                      });


                    },
                  )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
                child: SizedBox(
                  height: 50,
                  width: 50,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 1 - seconds / maxSeconds,
                        valueColor:seconds<10 ?AlwaysStoppedAnimation(Colors.red):AlwaysStoppedAnimation(Colors.greenAccent),
                        backgroundColor: Colors.grey[200],
                      ),
                      Center(
                        child: Text('${seconds}',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:seconds<10?Colors.red:Colors.teal,
                            fontSize: 18
                        ),),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25,right: 25,top: 10,bottom: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: 35,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('من',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red
                  )),
                  Text('${widget.name}',textDirection: TextDirection.rtl,style: TextStyle(
                    color: Color.fromARGB(255, 68, 71, 71),fontWeight: FontWeight.w600,fontSize: 14,
                  )),
                  Container(
                      width: 300,
                      child: Text('${widget.address}',style: TextStyle(color: Color.fromARGB(255, 68, 71, 71),fontWeight: FontWeight.w600,fontSize: 14,),maxLines: 1,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl)),
                  SizedBox(height: 5,),
                  Text(''),
                  SizedBox(height: 10,),
                  if(widget.destination!=null)
                  Text('الى',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red
                  )),
                  if(widget.destination!=null)
                  Container(
                      width: 270,
                      child: Text('${widget.destination}',style: TextStyle(color: Color.fromARGB(255, 68, 71, 71),fontWeight: FontWeight.w600,fontSize: 14,),maxLines: 1,overflow: TextOverflow.ellipsis,textDirection: TextDirection.rtl,)),
                ],
              ),

              Column(children: [
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 0,bottom: 2),
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 18,
                  ),
                ),

                Container(
                  height: 80,
                  width: 2,
                  color:widget.destination!=null?Colors.red: Colors.transparent,
                ),
                if(widget.destination!=null)
                Padding(
                  padding: const EdgeInsets.only(left: 0,top: 2),
                  child: Icon(
                    Icons.my_location_sharp,
                    color: Colors.red,
                    size: 18,
                  ),
                ),
              ],),
            ],
          ),
        ),
        Container(
          height: 0.5,
          width: double.infinity,
          color: Colors.black38,
        ),
        SizedBox(height: 50,),
        Column(
          children: [
            Text(' ${widget.delivery_price} درهم ',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize:30,
              color: Color(0xff00ab12),
            ),textDirection: TextDirection.rtl,),
            SizedBox(
              height: 10,
            ),
            if(widget.destination==null)
            OutlinedButton(
            onPressed: null,
            style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0), // set the border radius of the button
            ),
            side: BorderSide(width: 2.0, color:Colors.red), // set the width and color of the button border
            ),
            child: Text('AskRider',style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold
            )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                widget.delivery_time!=null? Row(
                  children: [
                    Icon(Icons.access_time,size: 20),
                    SizedBox(width: 5,),
                    Text('${widget.delivery_time}',style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600
                    ),),
                  ],
                ):SizedBox(height: 0),
                SizedBox(width: 10,),
                widget.distance!=null? Row(
                  children: [
                    Icon(Icons.social_distance,size: 20),
                    SizedBox(width: 5,),
                    Text('${widget.distance}',style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,

                    ),)
                  ],
                ):SizedBox(height: 0)
              ],
            ),
          ],
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,bottom: 25),
          child: GestureDetector(
            onTap: ()async{
              stopAudio();
              setState(() {
                isloading = true;
              });

              final response = await http.post(
                  Uri.parse(widget.distance!=null?'https://api.canariapp.com/v1/partner/driver/orders/accept/${widget.order_ref}':'https://api.canariapp.com/v1/partner/driver/store_dispatch/accept/${widget.order_ref}'),
                  headers:{'Content-Type':'application/json','Accept':'application/json','Authorization': 'Bearer ${token}',}
              ).then((value){
                var data = json.decode(value.body);
                print('==================================================');
                isloading = false;
                print(data);
                print('==================================================');
                setState(() {
                  timer.cancel();
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetails(
                   order_ref: data['order_ref'],

                 )));
                });
              }).onError((error, stackTrace){
                print(error);
                setState(() {

                });
              });


            },
            child: Container(
              height: 55,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xff00ab12),
              ),
              child: Center(
                child:isloading?CircleAvatar(
                    maxRadius: 12,
                    backgroundColor: Color(0xff00ab12),
                    child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3.3,)):Text('قبول',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


