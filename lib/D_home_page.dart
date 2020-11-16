import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'D_fullfeed.dart';
import 'D_profile.dart';
import 'developer_info.dart';
import 'global.dart' as g;

class DHomePage extends StatefulWidget {
  DHomePage({Key key, this.logoutCallback}) : super(key: key);
  final VoidCallback logoutCallback;

  @override
  _DHomePageState createState() =>
      _DHomePageState(logoutCallback: logoutCallback);
}

class _DHomePageState extends State<DHomePage> {
  _DHomePageState({this.logoutCallback});
  int state = 1;
  bool tick = false, _alertopen = false,_showInfo=false;
  final VoidCallback logoutCallback;
  GlobalKey<ScaffoldState> home = new GlobalKey<ScaffoldState>();
  String url = g.preurl + "departmentFeed/";
  var dat;

  Future<String> getfeed() async {
    print(g.did);
    final response = await http.post(url, body: {"department_id": g.did});
    setState(() {
      dat = json.decode(response.body);
    });
    return "Success!";
  }

  @override
  void initState() {
    setState(() {
      _alertopen = false;
      tick = false;
      g.alert = 0;
      g.loc_alert = 0;
      g.vote_alert = 0;
    });
    print(g.pid);
    this.getfeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: home,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text("Complaint Point", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: new Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            home.currentState.openDrawer();
          },
        ),
        
        actions: <Widget>[
          InkWell(
          child:Container(
            height: 10,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration( borderRadius:BorderRadius.circular(5),),
            child: Image.asset("assets/logo.jpg")
          ),
          onTap: () {
            setState(() {
              _showInfo=true;
            });
          },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  color:  Colors.grey[800],
                ),
                padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                alignment: Alignment.center,
                child:Text(
                'Action Centre',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DProfilePage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text('Report a Bug'),
              onTap: () async {
                final Email email = Email(
                  body: '',
                  subject: 'Bug in Complaint Point',
                  recipients: ['nagulan1645@gmail.com','srinivasananthu24@gmail.com'],
                );
                await FlutterEmailSender.send(email);
              },
            ),
            ListTile(
              leading: Icon(Icons.developer_mode),
              title: Text('Developers'),
              onTap: ()  {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeveloperInfo(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sign out'),
              onTap: () {
                try {
                  widget.logoutCallback();
                } catch (e) {
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _alertopen,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: dat == null ? 0 : dat.length,
                itemBuilder: (BuildContext context, int index) {
                  List<String> data = [
                    dat[index]["grievance_id"].toString(),
                    dat[index]["subject"],
                    dat[index]["grievance"],
                    dat[index]["upvote"].toString(),
                    dat[index]["downvote"].toString(),
                    dat[index]["current_status"],
                    dat[index]["arg_id"].toString(),
                    dat[index]["pg_id"].toString()
                  ];
                  print(data);
                  return new Container(
                    child: Column(
                      children: <Widget>[
                        feed(data),
                      ],
                    ),
                  );
                }),
          ),
          if(_showInfo)appInfo()
        ],
      ),
    );
  }

  Widget appInfo() {
    return AlertDialog(
      backgroundColor: Colors.grey[700],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Image.asset("assets/logo.png",height: 80,),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Text("Complaint Point acts as a bridge to connect People and the Government. Government is an operational body by the people, of the people and for the people. So we need you to keep the wheel running. Thanks for your support!",style: TextStyle(color: Colors.white),),
          ),
          RaisedButton(
            color: Colors.white,
            child: Text("wow!",style: TextStyle(color: Colors.grey[700],fontSize: 25)),
            onPressed: () {
              setState(() {
                _showInfo=false;
              });
            },
          )
        ],
      )
    );
  }

  Widget feed(List<String> data) {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            //width: MediaQuery.of(context).size.width * 0.05,
            width: 5,
            height: 150,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (data[5]=='posted')?Colors.greenAccent[700]:Colors.orangeAccent[700],
            ),
          ),
          new Expanded(
            child: InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (data[5]=='posted')?Colors.greenAccent[700]:Colors.orangeAccent[700],
                    ),
                    child: Text((data[5]=='posted')?"Need to be resolved":"Resolved",style: TextStyle(color: Colors.white),),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: new RichText(
                      text: TextSpan(
                        text: data[1],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.height * 0.025,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          data[2],
                          softWrap: true,
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.015,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DFullFeed(
                        data: data,
                      ),
                    )
                  );
                getfeed();
              },
            ),
          ),
          cancel(context, data[3], data[4])
        ],
      ),
    );
  }

  Widget cancel(context, String upvote, String downvote) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.transparent),
        height: 200,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new Column(
                children: [
                  new Icon(
                    Icons.thumb_up_outlined,
                    color: Colors.blue,
                    size: MediaQuery.of(context).size.height * 0.04,
                  ),
                  new Text(
                    upvote,
                    style: TextStyle(color: Colors.grey[800], fontSize: 12),
                  )
                ],
              ),
              new Column(
                children: [
                  new Icon(
                    Icons.thumb_down_outlined,
                    color: Colors.blue,
                    size: MediaQuery.of(context).size.height * 0.04,
                  ),
                  new Text(
                    downvote,
                    style: TextStyle(color: Colors.grey[800], fontSize: 12),
                  )
                ],
              )
            ]));
  }
}
