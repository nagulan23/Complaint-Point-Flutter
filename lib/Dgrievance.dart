import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'fullfeed.dart';
import 'global.dart' as g;
import 'dart:io';
import 'dart:convert';

class Dgrievance extends StatefulWidget {
  @override
  DgrievanceState createState() => DgrievanceState();
}

class DgrievanceState extends State<Dgrievance>{
  List<TextEditingController> control = List<TextEditingController>(8);
  final FocusNode myFocusNode = FocusNode();
  List dat;
  List profile_img=['https://cdn.business2community.com/wp-content/uploads/2014/04/profile-picture-300x300.jpg','https://www.attractivepartners.co.uk/wp-content/uploads/2017/06/profile.jpg','https://organicthemes.com/demo/profile/files/2018/05/profile-pic.jpg','https://www.irreverentgent.com/wp-content/uploads/2018/03/Awesome-Profile-Pictures-for-Guys-look-away2.jpg','https://view.factsmgt.com/ch-me/staff186_2.jpg'];


  Future<String> getdata() async {
    print("fetching.......");
    var url=g.preurl+"dGrievance/";
    final response = await http.post(url,body: {"aadhaar_number":g.pid});
    setState(() {
      dat = json.decode(response.body);
    });
    return "Success!";
  }

  @override
    void initState() {
      getdata();
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
        title: Text("Downvoted Grievance", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.grey[800],
        ),
        body: new Container(
          child: (dat!=null && dat.isEmpty)?
          Container(
            alignment: Alignment.center,
            child: Image.asset("assets/no_results_found.png"),
          )
          :ListView.builder(
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
                }
              ),
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
                    },
                  ),
                ],
              ))
        ],
      ),
    );
  }


}