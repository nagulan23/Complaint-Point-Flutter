import 'package:flutter/material.dart';
import 'global.dart' as g;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';

class DFullFeed extends StatefulWidget {
  DFullFeed({Key key, this.data}) : super(key: key);

  final List<String> data;

  @override
  _DFullFeedState createState() => _DFullFeedState(data: data);
}

class _DFullFeedState extends State<DFullFeed> {
  final List<String> data;
  _DFullFeedState({this.data});
  bool _alertopen = false, tick = false,_isLoading=false;
  String url = g.preurl + "gProofs/";
  List dat = [];

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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                              children: [
                                new Container(
                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  alignment: Alignment.topLeft,
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: 8,
                                  decoration: BoxDecoration(
                                      color: (data[5]=='posted')?Colors.greenAccent[700]:Colors.orangeAccent[700],
                                      borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(20))),
                                ),
                                new Container(
                                  margin: EdgeInsets.fromLTRB(10,0 , 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: Text("status:  "),
                                ),
                                new Container(
                                  margin: EdgeInsets.fromLTRB(0,0 , 0, 0),
                                  alignment: Alignment.topLeft,
                                  child: Text((data[5]=='posted')?'Posted':'Resolved', style:TextStyle(color: (data[5]=='posted')?Colors.greenAccent[700]:Colors.orangeAccent[700])),
                                ),
                              ],
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
                                      MediaQuery.of(context).size.height * 0.03,
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
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
                            child: new RichText(
                              text: TextSpan(
                                text: "Proofs",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          if(dat.isNotEmpty)Container(
                              height: 200,
                              width: double.infinity,
                              child:new Swiper(
                                itemBuilder: (BuildContext context,int index){
                                  return new Image.network(dat[index]["proofs"],fit: BoxFit.fill,filterQuality: FilterQuality.low,);
                                },
                                itemCount: dat.length,
                                pagination: new SwiperPagination(),
                                control: new SwiperControl(),
                              ),
                            ),
                          /*new Container(
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
                            ),*/
                        ],
                      ),
                    ],
                  ),
                ),
                if((data[5]=='posted'))Container(
                  child: RaisedButton(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    color: Colors.grey[700],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Container(alignment: Alignment.center,width: 150,height: 15,child:(_isLoading)?Container(width:15,child:CircularProgressIndicator()):Text("Issue Resolved",style: TextStyle(color: Colors.white),)),
                    onPressed: () async {
                      setState(() {
                        _isLoading=true;
                      });
                      var url=g.preurl+"updateStatus/";
                      final response = await http.post(url, body: {"grievance_id": data[0]});
                      setState(() {
                        data[5]='resolved';
                        _isLoading=true;
                      });
                    },
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
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
