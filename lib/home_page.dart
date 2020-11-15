import 'package:complaint_point/fullfeed.dart';
import 'package:complaint_point/post.dart';
import 'package:complaint_point/profile.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  bool tick = false, _alertopen = false;
  final VoidCallback logoutCallback;
  GlobalKey<ScaffoldState> home = new GlobalKey<ScaffoldState>();
  String url = g.preurl + "publicFeed/";
  List dat;

  Future<String> getfeed() async {
    final response = await http.get(url);

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
    print(g.uid);
    print(g.pid);
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
          new IconButton(
            icon: new Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey[800],
              ),
              child: Text(
                'User Centre',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
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
                    dat[index]["name"],
                    dat[index]["city"],
                    dat[index]["state"]
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
          if (g.alert == 1) confirm()
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
                      "By ticking this, you confirm that this grievance is genuinely  true and you are responsible for any malicious activity",
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
                    onPressed: () {},
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
              color: Colors.greenAccent[700],
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
                            backgroundImage: NetworkImage(
                                "https://www.thescentedskunk.com/wp-content/uploads/2017/05/Profile-pic-circle-transparent-background-1-e1503671090517.png"),
                          ),
                          new Text(
                            data[5],
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
          new Container(
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
                          color: Colors.blue[700],
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        new Text(
                          data[3],
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 12),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
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
                          data[4],
                          style:
                              TextStyle(color: Colors.grey[800], fontSize: 12),
                        )
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        g.alert = 1;
                        g.loc_alert = 0;
                        g.vote_alert = 1;
                        _alertopen = true;
                      });
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }
}