import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:complaint_point/selection.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:direct_select/direct_select.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
  int state = 0;
  final department = [
    "Long press to select Department",
    "Education",
    "Transport",
  ];
  final derptment_id=[-1,124563257812,233245568899];
  final government = [
    "Long press to select Government",
    "Central Government",
    "TN Government",
    "UP Government",
    "AD Government",
    "KR Government",
  ];
  int selectedDep = 0, selectedGov = 0;
  bool tick = false;
  String subject="",body="",reforms_type="",person_c="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              if (state == 0) Navigator.pop(context);
              setState(() {
                state = 0;
              });
            },
          ),
          title: Text("Report Grievance",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400)),
        ),
        body: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(
              children: <Widget>[
                _showForm(),
              ],
            )));
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            //gradient: LinearGradient(colors: [Colors.blue[50],Colors.white,Colors.blue[100]],)
            //color: Colors.blue[50]
            ),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            children: <Widget>[
              if (state == 0) _showSelection(),
              if (state == 1 || state == 2) _header(),
              if (state == 1) _selectGov(),
              if (state == 1) _selectPerson(),
              if (state == 1 || state == 2) _selectDepartment(),
              if (state == 2) _showStateInput(),
              if (state == 2) _showCityInput(),
              if (state == 2) _showPeriodInput(),
              if (state == 2) _showzipcode(),
              if (state == 1 || state == 2) _showSubjectInput(),
              if (state == 1 || state == 2) _showTextInput(),
              if (state == 1 || state == 2) _showProof1Input(),
              if (state == 1 || state == 2) _showProof2Input(),
              if (state == 1 || state == 2) _showProof3Input(),
              if (state == 1 || state == 2) _tandc(),
              if (state == 1 || state == 2) _showSubmitbutton(),
            ],
          ),
        ));
  }

  Widget _showSelection() {
    return new Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height / 10, 0, 10),
            child: Text("Welcome User!",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 25,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text("Select the type of Grievance you wish to report",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w400)),
          ),
          InkWell(
            child: Container(
              child: Image.asset(
                "assets/admin.png",
                width: MediaQuery.of(context).size.width / 3,
              ),
            ),
            onTap: () {
              setState(() {
                state = 1;
              });
            },
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text("Administrative reforms Grievance",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              width: double.infinity,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.elliptical(100, 5)),
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.deepPurple])),
                  ),
                  Text("  or  ",
                      style: TextStyle(
                          color: Colors.deepPurple[600],
                          fontSize: 20,
                          fontWeight: FontWeight.w400)),
                  Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.elliptical(100, 5)),
                        gradient: LinearGradient(
                            colors: [Colors.deepPurple, Colors.white])),
                  ),
                ],
              )),
          InkWell(
            child: Container(
              child: Image.asset(
                "assets/public.png",
                width: MediaQuery.of(context).size.width / 2,
              ),
            ),
            onTap: () {
              setState(() {
                state = 2;
              });
            },
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text("Public Grievance",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 15,
                    fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return new Container(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
        child: Text("Please fill in all the below details for the Grievance",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 15, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _selectGov() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Government concerned",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          DirectSelect(
            itemExtent: 50,
            selectedIndex: 0,
            backgroundColor: Colors.grey,
            child: MySelectionItem(
              isForList: false,
              title: government[selectedGov],
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedGov = index;
              });
            },
            items: government
                .map((val) => MySelectionItem(
                      title: val,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _showzipcode() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Zipcode",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: namekey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: "",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              onSaved: (newValue) {

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectDepartment() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Department concerned",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          DirectSelect(
            itemExtent: 50,
            selectedIndex: 0,
            backgroundColor: Colors.grey,
            child: MySelectionItem(
              isForList: false,
              title: department[selectedDep],
            ),
            onSelectedItemChanged: (index) {
              setState(() {
                selectedDep = index;
              });
            },
            items: department
                .map((val) => MySelectionItem(
                      title: val,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _showStateInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Location (State)",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: namekey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: "",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectPerson() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Person-Concerned",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: namekey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: "null(default)",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showCityInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Location (City) - optional",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: namekey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: "",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showPeriodInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Period",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: namekey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.perm_identity,
                  color: Colors.white,
                ),
                hintText: "number-days/months/years(ex:3-days)",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.text,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showSubjectInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Subject",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showTextInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Your Grievance",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                hintText: "Type here...",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              minLines: 5,
              maxLines: 10,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.multiline,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showProof1Input() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Link of proof 1",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.url,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showProof2Input() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Link of proof 2",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.url,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _showProof3Input() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Link of proof 3",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              maxLines: 1,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.url,
              onTap: () {},
              validator: (value) {},
              onSaved: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _tandc() {
    return new Container(
      margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
      child: CheckboxListTile(
        title: Text(
            "By ticking this, you verify that all the details you have submitted are true and you are responsible for any malicious activity",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red, fontSize: 13, fontWeight: FontWeight.w400)),
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
    );
  }

  Widget _showSubmitbutton() {
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 4, 40,
          MediaQuery.of(context).size.width / 4, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.blue,
        child: (_isLoading)
            ? SizedBox(
                width: 15,
                height: 15,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ))
            : Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
        onPressed: () async {},
      ),
    );
  }
}
