import 'package:flutter/material.dart';
import 'global.dart' as g;
import 'dart:convert';
import 'package:http/http.dart' as http;

class FullFeed extends StatefulWidget {
  FullFeed({Key key, this.data}) : super(key: key);

  final List<String> data;

  @override
  _FullFeedState createState() => _FullFeedState(data: data);
}

class _FullFeedState extends State<FullFeed> {
  final List<String> data;
  _FullFeedState({this.data});
  bool _alertopen = false, tick = false;
  String url = g.preurl + "gProofs/";
  List dat;

  Future<String> getproof() async {
    final response = await http.post(url, body: {"grievance_id": data[0]});

    setState(() {
      dat = json.decode(response.body);
      print(dat);
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
    getproof();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          AbsorbPointer(
            absorbing: _alertopen,
            child: new Column(
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
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      new Expanded(
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
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      backgroundImage: NetworkImage(
                                          "https://www.thescentedskunk.com/wp-content/uploads/2017/05/Profile-pic-circle-transparent-background-1-e1503671090517.png"),
                                    ),
                                    new Text(
                                      data[5],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.017,
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
                                      size: MediaQuery.of(context).size.width *
                                          0.024),
                                  new Text(
                                    data[6] + " , " + data[7],
                                    style: TextStyle(
                                        color: Colors.green[500],
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.017,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                              alignment: Alignment.topLeft,
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 8,
                              decoration: BoxDecoration(
                                  color: Colors.grey[600],
                                  borderRadius: BorderRadius.horizontal(
                                      right: Radius.circular(20))),
                            ),
                            new Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: new RichText(
                                text: TextSpan(
                                  text: data[1],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            new Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  new Text(
                                    data[2],
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            new Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: new RichText(
                                text: TextSpan(
                                  text: "Proofs",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            new Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: dat == null ? 0 : dat.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return new Container(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        new Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          decoration: new BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  dat[index]["proofs"]),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      ],
                                    ));
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
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
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 12),
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
                              style: TextStyle(
                                  color: Colors.grey[800], fontSize: 12),
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
                  ),
                )
              ],
            ),
          ),
          if (g.alert == 1) confirm()
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
}