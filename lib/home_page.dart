import 'package:complaint_point/feed.dart';
import 'package:complaint_point/post.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int state=1;


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
        body: new ListView(
          children: <Widget>[
            Feed(title: "Sewage Overflow",name: "Rohit",),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: double.infinity,
              height:1,
              decoration: BoxDecoration(
                color: Colors.grey[300]
              ),
            ),
            Feed(title: "Electicity Down",name: "Geller"),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: double.infinity,
              height:1,
              decoration: BoxDecoration(
                color: Colors.grey[300]
              ),
            ),
            Feed(title: "Corrupted Police Station", name:"Clarke"),
            Container(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: double.infinity,
              height:1,
              decoration: BoxDecoration(
                color: Colors.grey[300]
              ),
            ),
            Feed(title: "Damaged Subway", name:"Bob"),
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
}