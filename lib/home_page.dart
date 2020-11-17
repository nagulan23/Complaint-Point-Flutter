import 'package:complaint_point/developer_info.dart';
import 'package:complaint_point/fullfeed.dart';
import 'package:complaint_point/post.dart';
import 'package:complaint_point/profile.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'Dgrievance.dart';
import 'Rgrievance.dart';
import 'Ugrievance.dart';
import 'global.dart' as g;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.logoutCallback}) : super(key: key);
  final VoidCallback logoutCallback;

  @override
  _MyHomePageState createState() =>
      _MyHomePageState(logoutCallback: logoutCallback);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({this.logoutCallback});
  int state = 1;
  bool tick = false, _alertopen = false,_isLoading=false,_showInfo=false;
  final VoidCallback logoutCallback;
  GlobalKey<ScaffoldState> home = new GlobalKey<ScaffoldState>();
  String url = g.preurl + "publicFeed/";
  List dat;
  List profile_img=['https://cdn.business2community.com/wp-content/uploads/2014/04/profile-picture-300x300.jpg','https://www.attractivepartners.co.uk/wp-content/uploads/2017/06/profile.jpg','https://organicthemes.com/demo/profile/files/2018/05/profile-pic.jpg','https://www.irreverentgent.com/wp-content/uploads/2018/03/Awesome-Profile-Pictures-for-Guys-look-away2.jpg','https://view.factsmgt.com/ch-me/staff186_2.jpg'];


  Future<String> getfeed() async {
    print("fetching.......");
    final response = await http.post(url,body: {"aadhaar_number":g.pid});
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
                  builder: (context) => ProfilePage(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.thumbs_up_down),
              title: Text('Reported Grievances'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Rgrievance(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Upvoted Grievances'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Ugrievance(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.thumb_down),
              title: Text('Downvoted Grievances'),
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dgrievance(),
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
            absorbing: _alertopen || _showInfo,
            child: (dat==null)?Container(alignment: Alignment.center,child:CircularProgressIndicator()):
            ListView.builder(
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
                    dat[index]["name"],
                    dat[index]["city"],
                    dat[index]["state"],
                    dat[index]["block"].toString(),
                    dat[index]["btype"].toString(),
                    dat[index]["current_status"].toString()
                  ];
                  return new Container(
                    child: Column(
                      children: <Widget>[
                        feed(data),
                      ],
                    ),
                  );
                }),
          ),
          if (g.alert == 1) confirm(),
          if(_showInfo)appInfo()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        currentIndex: state,
        iconSize: 30,
        selectedLabelStyle: TextStyle(fontSize: 15, color: Colors.white),
        unselectedLabelStyle: TextStyle(fontSize: 12, color: Colors.white),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        selectedIconTheme: IconThemeData(size: 30),
        onTap: (value) async {
          setState(() {
            state = value;
          });
          if (state == 0){
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(),
                ));
            this.getfeed();
            setState(() {
              state=1;
            });
          }
          if (state == 2){
            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ));
            this.getfeed();
            setState(() {
              state=1;
            });
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            label: "Post",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.thumbs_up_down, color: Colors.white),
            label: "Social",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.white),
            label: "Profile",
          ),
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


  Widget confirm() {
    return AlertDialog(
      title: Text(
        (g.vote_alert == 0) ? "Up Vote" : "Down Vote",
        textAlign: TextAlign.center,
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              (g.loc_alert == 0) ? "assets/verify.jpg" : "assets/error.png",
              height: 100,
            ),
            Container(
              child: Text(
                (g.loc_alert == 0)
                    ? "Your account has been verified"
                    : "There has been an error while verifying your account",
                textAlign: TextAlign.center,
              ),
            ),
            if (g.loc_alert == 0)
              new Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: CheckboxListTile(
                  title: Text(
                      (g.vote_alert==0)?"By ticking this, you confirm that this grievance is genuinely  true and you are responsible for any malicious activity":
                      "By ticking this, you confirm that this grievance is genuinely  spam and you are responsible for any malicious activity",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.w400)),
                  onChanged: (bool value) {
                    setState(() {
                      tick = value;
                    });
                  },
                  value: tick,
                  activeColor: Colors.green,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (g.loc_alert == 0)
                  (_isLoading)?Container(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(),
                  ):
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green, width: 2),
                    ),
                    child: Text(
                      "Proceed",
                      style: TextStyle(color: Colors.green),
                    ),
                    color: Colors.white,
                    onPressed: () async {
                      setState(() {
                        _isLoading=true;
                      });
                      var url=g.preurl+"vote/";
                      if(g.vote_alert==0){
                        final response = await http.post(url,body: {"g_aadhaar_number":g.pid,'a_grievance_id':g.vote_gid,'type':'upvote'});
                        
                        Flushbar(
                                title:  "UpVote successfully submitted",
                                message:  "Thank you",
                                duration:  Duration(seconds: 3),              
                              )..show(context);
                      }
                      else{
                        final response = await http.post(url,body: {"g_aadhaar_number":g.pid,'a_grievance_id':g.vote_gid,'type':'downvote'});
                        
                        Flushbar(
                                title:  "UpVote successfully submitted",
                                message:  "Thank you",
                                duration:  Duration(seconds: 3),              
                              )..show(context);
                      }
                      await getfeed();
                      setState(() {
                        g.alert = 0;
                        _alertopen = false;
                        _isLoading=false;
                      });
                    },
                  ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue, width: 2),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.blue),
                  ),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      g.alert = 0;
                      _alertopen = false;
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
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
            height: 170,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: (data[10]=='posted')?Colors.greenAccent[700]:Colors.orangeAccent[700],
            ),
          ),
          new Expanded(
            child: InkWell(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      alignment: Alignment.centerLeft,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.05,
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(profile_img[int.parse(data[0])%5]),
                          ),
                          new Text(
                            "  "+data[5],
                            style: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.017,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )),
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    padding: EdgeInsets.fromLTRB(10, 2, 0, 5),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Icon(Icons.location_on,
                            color: Colors.green[700],
                            size: MediaQuery.of(context).size.width * 0.024),
                        new Text(
                          data[6] + " , " + data[7],
                          style: TextStyle(
                              color: Colors.green[500],
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.017,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullFeed(
                        data: data,
                      ),
                    ));
              },
            ),
          ),
          if (data[8] == 'false')
            vote(context, data[3], data[4],data[0])
          else
            cancel(context, data[3], data[4],data[9])
        ],
      ),
    );
  }

  Widget vote(context, String upvote, String downvote,String gid) {
    return new Container(
        decoration: new BoxDecoration(color: Colors.transparent),
        height: 200,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new InkWell(
              child: Column(
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
              onTap: () {
                setState(() {
                  g.vote_gid=gid;
                  g.alert = 1;
                  g.loc_alert = 0;
                  g.vote_alert = 0;
                  _alertopen = true;
                });
              },
            ),
            new InkWell(
              child: Column(
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
              ),
              onTap: () {
                setState(() {
                  g.vote_gid=gid;
                  g.alert = 1;
                  g.loc_alert = 0;
                  g.vote_alert = 1;
                  _alertopen = true;
                });
              },
            ),
          ],
        ));
  }

  Widget cancel(context, String upvote, String downvote,String type) {
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
                    color: (type=='1')?Colors.blue[700]:Colors.grey[800],
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
                    color: (type=='2')?Colors.blue[700]:Colors.grey[800],
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