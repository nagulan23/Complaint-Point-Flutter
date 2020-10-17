import 'package:complaint_point/feed.dart';
import 'package:complaint_point/fullfeed.dart';
import 'package:complaint_point/post.dart';
import 'package:flutter/material.dart';
import 'global.dart' as g;


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int state=1;
  bool tick=false,_alertopen=false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          title: Text(widget.title,style: TextStyle(color: Colors.white)),
          leading: IconButton(
            icon: new Icon(Icons.menu, color: Colors.white),
            onPressed: () {
            },
          ),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.search, color: Colors.white),
                onPressed: () {
                },),
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
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            AbsorbPointer(
            absorbing: _alertopen,
            child: ListView(
                children: <Widget>[
                  feed("Sewage Overflow","Rohit",),
                  feed("Electicity Down", "Geller"),
                  feed("Corrupted Police Station", "Clarke"),
                  feed( "Damaged Subway", "Bob"),
                ],
              ),
            ),
            if(g.alert==1)confirm()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey[800],
          currentIndex: state,
          iconSize: 30,
          selectedLabelStyle: TextStyle(fontSize: 15,color: Colors.white),
          unselectedLabelStyle: TextStyle(fontSize: 12,color: Colors.white),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey[500],
          selectedIconTheme: IconThemeData(size: 30),
          onTap: (value) {
            setState(() {
              state=value;
            });
            if(state==0)
            Navigator.push(context, MaterialPageRoute(builder: (context) => PostPage(),));
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

  Widget confirm(){
    return AlertDialog(
      title:Text((g.vote_alert==0)?"Up Vote":"Down Vote",textAlign: TextAlign.center,),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset((g.loc_alert==0)?"assets/verify.jpg":"assets/error.png",height: 100,),
            Container(
              child: Text((g.loc_alert==0)?"Your account has been verified":"There has been an error while verifying your account",textAlign: TextAlign.center,),
            ),
            if(g.loc_alert==0)new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: CheckboxListTile(
                title: Text(
                    "By ticking this, you confirm that this grievance is genuinely  true and you are responsible for any malicious activity",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.red, fontSize: 10, fontWeight: FontWeight.w400)),
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
                if(g.loc_alert==0)RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.green,width: 2),
                  ),
                  child: Text("Proceed",style: TextStyle(color: Colors.green),),
                  color: Colors.white,
                  onPressed: () {
                    
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.blue,width: 2),
                  ),
                  child: Text("Back",style: TextStyle(color: Colors.blue),),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      g.alert=0;
                      _alertopen=false;
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

  Widget feed(String title,String name) {
    return new Container(
      margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
      width: MediaQuery.of(context).size.width,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            //width: MediaQuery.of(context).size.width * 0.05,
            width:5,
            height: 200,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.greenAccent[700],
            ),
          ),
          new Expanded(
            child:InkWell(
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
                              backgroundImage: NetworkImage("https://www.thescentedskunk.com/wp-content/uploads/2017/05/Profile-pic-circle-transparent-background-1-e1503671090517.png"),
                            ),
                            new Text(
                                  name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: MediaQuery.of(context).size.height * 0.017,
                                      fontWeight: FontWeight.w400),
                            ),
                          ],
                        )
                      ),
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
                        'Wolfram street, M G colony ,Noida',
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
                          text: title,
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
                        "Research and assessment data on marine species are extremely scarce, the 2019 government report said,adding that a national strategy and action plans for the conservation of these species haven’t been developed.The Velondriake marine area on Madagascar’s southwest coast was created in 2006 with the help of Blue Ventures. It is Madagascar’s first locally managed marine area (LMMA) where consultations with the local communities and awareness-generating activities played a significant role.",
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => FullFeed(title: title,name: name,),));
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
                        new Text("12k",style: TextStyle(color: Colors.grey[800],fontSize: 12),)
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        g.alert=1;
                        g.loc_alert=0;
                        g.vote_alert=0;
                        _alertopen=true;
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
                        new Text("156",style: TextStyle(color: Colors.grey[800],fontSize: 12),)
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        g.alert=1;
                        g.loc_alert=0;
                        g.vote_alert=1;
                        _alertopen=true;
                      });
                    },
                  ),
                ],
              )
            )
        ],
      ),
    );
  }

}