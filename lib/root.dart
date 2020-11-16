import 'dart:convert';
import 'package:complaint_point/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'home_page.dart';
import 'global.dart' as g;
import 'package:shared_preferences/shared_preferences.dart';

class RootPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  SharedPreferences prefs;
  String _userId = "";
  bool servererror=false;
  
  @override
  void initState()  {
    determine();
  }

  void determine() async{
    print("-----");
      prefs= await SharedPreferences.getInstance();
      print("========");
      setState(() {
        g.status = prefs.getBool('isLoggedIn') ?? false;
      });
      print("+++++++");
  }

  void logout() {
    setState(() {
    prefs?.clear() ;
    g.status=false;
    });
  }

  void login() {
    setState(() {
      prefs.setBool('isLoggedIn',true);
      prefs.setString('userid',g.uid);
      g.pid=g.uid.substring(1);
      g.did=g.uid.substring(1);
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("assets/logo.png"),height: 60,),
          Container(height:10),
          Text("HERODY",style: TextStyle(fontSize: 30,fontWeight:FontWeight.normal,color: Colors.white,shadows: <Shadow>[
            Shadow(
              offset: Offset(0, 0),
              blurRadius: 8.0,
              color: Colors.black,
            )]),),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
           child: CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.white)),
           //child:SpinKitWave(color: Colors.white,type: SpinKitWaveType.center,)
          ),
        ]
        )
      ),
      
      );
      
  }

  void getdata() async{
    /*String url=g.preurl+"user/details";
    g.uid= await prefs.getString("userid");
    Response response=await post(url,body: {"id":g.uid});
    try{
    setState(() {
      g.data=(json.decode(response.body)["response"]["user"]);
    });
    }
    catch(e){
      print(e);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    if(g.status==null)
    {
      return Scaffold();
    }
    else
    {
      if(g.status)
      {
        setState(() {
          g.uid= prefs.getString("userid");
          g.pid=g.uid.substring(1);
          g.did=g.uid.substring(1);
        });
        return new MyHomePage(logoutCallback: logout,);
      }
      else{
        return LoginPage(loginCallback: login,);
      }
    }
  }
}
