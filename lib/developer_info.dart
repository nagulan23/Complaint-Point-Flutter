import 'package:flutter/material.dart';
import 'global.dart' as g;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';

class DeveloperInfo extends StatefulWidget {
  @override
  _DeveloperInfoState createState() => _DeveloperInfoState();
}

class _DeveloperInfoState extends State<DeveloperInfo> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        width: double.infinity,
        child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.grey[700],
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  alignment: Alignment.center,
                  child: Text("Developers",style: TextStyle(fontSize: 25,color: Colors.grey[800],fontWeight: FontWeight.w500),)
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Image.asset("assets/p1.jpg",height: 100,),
                            )
                          ),
                          Text("@nagulan",style: TextStyle(fontSize: 18,color: Colors.grey[900]))
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              child: Image.asset("assets/p2.jpg",height: 100,),
                            )
                          ),
                          Text("@srinivasa",style: TextStyle(fontSize: 18,color: Colors.grey[900]))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/p3.jpg",height: 80,),
                            )
                          ),
                          Text("@hari",style: TextStyle(fontSize: 18,color: Colors.grey[900]))
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/p4.jpg",height: 80,),
                            )
                          ),
                          Text("@prathish",style: TextStyle(fontSize: 18,color: Colors.grey[900]))
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Image.asset("assets/p5.png",height: 80,),
                            )
                          ),
                          Text("@saidev",style: TextStyle(fontSize: 18,color: Colors.grey[900]))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  alignment: Alignment.center,
                  child: Text("From",style: TextStyle(fontSize: 20,color: Colors.grey[800],fontWeight: FontWeight.w500),)
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.center,
                  child: Text("Amrita Vishwa Vidyapeetham",style: TextStyle(fontSize: 25,color: Colors.red[900],fontWeight: FontWeight.w500),)
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  alignment: Alignment.center,
                  child: Text("Coimbatore",style: TextStyle(fontSize: 20,color: Colors.red[900],fontWeight: FontWeight.w500),)
                ),
              ]
            )
      )
    );
  }
}