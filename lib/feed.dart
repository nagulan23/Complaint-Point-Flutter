import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  Feed({Key key, this.title,this.color,this.name}) : super(key: key);

  final String color,name,title;

  @override
  _FeedState createState() => _FeedState(title: title,color: color,name: name);
}


class _FeedState extends State<Feed> {
  final String color,name,title;
  _FeedState({this.title,this.color,this.name});
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.23,
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width * 0.05,
            height: MediaQuery.of(context).size.height * 0.23,
            decoration: new BoxDecoration(
              color: Colors.greenAccent[700],
            ),
          ),
          new Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.23,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Container(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width * 0.5,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: new RichText(
                        text: TextSpan(
                          text: title,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.height * 0.03,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    new Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.24,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.05,
                              backgroundImage: NetworkImage("https://www.thescentedskunk.com/wp-content/uploads/2017/05/Profile-pic-circle-transparent-background-1-e1503671090517.png"),
                            ),
                            new RichText(
                              text: TextSpan(
                                  text: name+"\n",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                      fontWeight: FontWeight.w400),
                                  children: <TextSpan>[
                                    new TextSpan(
                                      text: "Noida",
                                      style: TextStyle(
                                          color: Colors.indigo,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.010,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ]),
                            ),
                          ],
                        )),
                  ],
                ),
                new Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.03,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.13,
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
          ),
          new Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: new BoxDecoration(color: Colors.grey[300]),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        new Icon(
                          Icons.thumb_up_outlined,
                          color: Colors.green[700],
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        new Text("12k",style: TextStyle(color: Colors.grey[800],fontSize: 12),)
                      ],
                    )
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                         new Icon(
                          Icons.thumb_down_outlined,
                          color: Colors.orange,
                          size: MediaQuery.of(context).size.height * 0.04,
                        ),
                        new Text("156",style: TextStyle(color: Colors.grey[800],fontSize: 12),)
                      ],
                    )
                  ),
                ],
              ))
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}