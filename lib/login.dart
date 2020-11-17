import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:complaint_point/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'global.dart' as g;

class LoginPage extends StatefulWidget {
  LoginPage({Key key,this.loginCallback}) : super(key: key);
  final VoidCallback loginCallback;
  @override
  _LoginPageState createState() => _LoginPageState(loginCallback:loginCallback);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({Key key,this.loginCallback});
  final VoidCallback loginCallback;
  final _formKey = new GlobalKey<FormState>();
  /*TextEditingController namekey = new TextEditingController(text: "");
  TextEditingController numkey = new TextEditingController(text: "");
  TextEditingController passkey = new TextEditingController(text: "");
  TextEditingController emailkey = new TextEditingController(text: "");
  TextEditingController genderkey = new TextEditingController(text: "");
  TextEditingController key = new TextEditingController(text: "");*/
  bool _isLoading = false;
  bool validemail;
  bool validpass;
  bool validfname;
  bool validlname;
  bool validano;
  bool validdob;
  bool validjob;
  bool validDoorno,validStreet,validCity,validState;
  bool validzipcode;
  bool validsalary;
  bool validgender;
  bool validnum, aadhaar_page = false;
  bool pagenexter = false;
  String email = "",
      password = "",
      firstname = "",
      lastname = "",
      number = "",
      gender = "",
      dob = "",
      job = "",
      ano="",
      aDoorno = "",
      aStreet = "",
      aState = "",
      aCity = "",
      zipcode = "",
      salary = "",
      error_msg="";
  int state = 1;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<int> checkmail() async {
    var url = g.preurl+"checkMail/";
    var response = await http.post(url, body: {'email_id': email});
    var data=json.decode(response.body);
    if(data["status"]=="success")
    {
      setState(() {
        state = 2;
        validemail = null;
        validpass = null;
        validfname=true;
        validlname=null;
        validnum=null;
         validdob=null;
         validjob=null;
         validDoorno=null;
         validStreet=null;
         validCity=null;
         validState=null;
         validzipcode=null;
       validsalary=null;
       validano=null;
        password = "";
        firstname = "";
        lastname = "";
        number = "";
        error_msg="";
        aadhaar_page = false;
        if (state == 2) _formKey.currentState.reset();
      });
    }
    else
    {
      setState(() {
        validemail=null;
        validpass=null;
        validfname=null;
        validlname=null;
        validnum=null;
         validdob=null;
         validjob=null;
         validDoorno=null;
         validStreet=null;
         validCity=null;
         validState=null;
         validzipcode=null;
       validsalary=null;
       validano=null;
        password="";
        firstname = "";
        lastname = "";
        number="";
        error_msg="";
        aadhaar_page=false;
        state=3;
      });
    }
    return (1);
  }

  Future<int> login() async {
    var url = g.preurl+"login/";
    var response = await http.post(url, body: {'email_id': email,'password':password});
    var data=json.decode(response.body);
    if(data["status"]=="success")
    {
      setState(() {
        g.uid=data["msg"];
        g.status=true;
        if(g.uid.startsWith("a")){
          g.pid=g.uid.substring(1);
          g.did="";
        }
        else{
            g.did=g.uid.substring(1);
            g.pid="";
        }
      });
      _formKey.currentState.reset();
      try {
        widget.loginCallback();
      } catch (e) {
        print(e);
      }
    }
    else
    {
      setState(() {
        error_msg=data["msg"];
        password="";
      });
    }
    return (1);
  }

  Future<int> createAccount() async {
    print("creating..........");
    var url = g.preurl+"aCheck/";
    var response = await http.post(url, body: {'aadhaar_number': ano});
    var data=json.decode(response.body);
    if(data["status"]=="success")
    {
      print({'first_name': firstname,'last_name':lastname,'date_of_birth':dob,'gender':gender,'salary_pa':salary,'job':job,'door_no':aDoorno,'street':aStreet,'zip_code':zipcode,'email_id':email,'password':password,'aadhaar_number':ano,'department_id':null,'city':aCity,'state':aState});
      url = g.preurl+"pSignup/";
      response = await http.post(url, body: {'first_name': firstname,'last_name':lastname,'date_of_birth':dob,'gender':gender,'mobile_number':number,'salary_pa':salary,'job':job,'door_no':aDoorno,'street':aStreet,'zip_code':zipcode,'email_id':email,'password':password,'aadhaar_number':ano,'department_id':'','city':aCity,'state':aState});
      data=json.decode(response.body);
      print(data);
      setState(() {
        g.uid='a'+ano;
        g.status=true;
        if(g.uid.startsWith("a")){
          g.pid=g.uid.substring(1);
          g.did="";
        }
        else{
            g.did=g.uid.substring(1);
            g.pid="";
        }
      });
      try {
        widget.loginCallback();
      } catch (e) {
        print(e);
      }
    }
    else
    {
      setState(() {
        error_msg="Aadhaar number already exists";
      });
    }
    return (1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child:new SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _showheader(),
              if (state != 2 && !aadhaar_page) _showEmailInput(),
              if (state == 3 && !aadhaar_page) _showFirstNameInput(),
              if (state == 3 && !aadhaar_page) _showLastNameInput(),
              if (state == 3 && !aadhaar_page) _showNumberInput(),
              if (state != 1 && !aadhaar_page) _showPasswordInput(),
              if (state == 3 && !aadhaar_page) _showGenderInput(),
              if (state == 3 && !aadhaar_page) _showDOBInput(),
              if (state == 3 && !aadhaar_page) _showSalarypa(),
              if (state == 3 && !aadhaar_page) _showjob(),
              if (state == 3 && !aadhaar_page) 
              Row(
                children: [
                  _showDoorNo(),
                  _showStreet(),
                ],
              ),
              if (state == 3 && !aadhaar_page) 
              Row(
                children: [
                  _showCity(),
                  _showState(),
                ],
              ),
              if (state == 3 && !aadhaar_page) _showzipcode(),
              if (state == 3 && aadhaar_page) _showAadhaarInput(),
              if(state==2||(state==3&&aadhaar_page))operation(),
              _showbutton(),
              if (state != 1) _showbackbutton(),
              Container(
                height: 50,
              )
            ],
            )
          )),
        ));
  }

  Widget _showCircularProgress() {
    return (_isLoading)
        ? new Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.indigo[700]),
            ),
          )
        : Container();
  }

  Widget _showheader() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/gov.png",
            width: MediaQuery.of(context).size.height * 0.07,
          ),
          Image.asset(
            "assets/logo.png",
            width: MediaQuery.of(context).size.width * 0.7,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text(
              "Of the people   .   By the people   .   For the people",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.indigo[800],
                  fontSize: MediaQuery.of(context).size.width / 35,
                  fontWeight: FontWeight.w600,
                  shadows: [Shadow(color: Colors.blue[200], blurRadius: 5)]),
            ),
          ),
          Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amber[800],
                    ),
                    child: Text(
                      (state == 1)
                          ? "Sign-in    Sign-up"
                          : (state == 2)
                              ? "Sign-in"
                              : "Sign-up",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  if (state == 1)
                    Text(
                      "/",
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    )
                ],
              )),
        ],
      ),
    );
  }

  Widget _showEmailInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Mail-ID",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: (state==3)?null:emailkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.mail_outline,
                  color: Colors.white,
                ),
                hintText: "ex: nagulan1645@gmail.com",
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    gapPadding: 20,
                    borderSide: BorderSide(color: Colors.indigo[800])),
              ),
              autofocus: false,
              readOnly: (state == 3) ? true : false,
              initialValue: (state == 3) ? email : null,
              style: TextStyle(
                  color: Colors.white, decoration: TextDecoration.none),
              cursorColor: Colors.white,
              cursorRadius: Radius.circular(10),
              keyboardType: TextInputType.emailAddress,
              onTap: () {
                setState(() {
                  validemail = null;
                });
              },
              validator: (value) {
                if (value.toString().contains("@") &&
                    value.toString().contains(".")) {
                  setState(() {
                    validemail = true;
                  });
                } else {
                  setState(() {
                    validemail = false;
                  });return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  email = newValue.toString();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validemail != null)
                ? Row(
                    children: [
                      if (validemail && state == 1)
                        Icon(
                          Icons.cloud_download,
                          color: Colors.green,
                          size: 15,
                        ),
                      if (validemail && state == 1)
                        Text(
                          "  Fetching Information...",
                          style: TextStyle(color: Colors.green),
                        ),
                      if (!validemail)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validemail)
                        Text(
                          "  Invalid Mail-ID",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validemail) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showPasswordInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, (state == 3) ? 0 : 30, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Password",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: passkey,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  color: Colors.white,
                ),
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
              obscureText: true,
              validator: (value) {
                setState(() {
                  if (value.toString().trim().isNotEmpty){
                    validpass = true;
                }
                  else{
                    validpass = false;
                    return("");
                  }
                });
              },
              onSaved: (newValue) {
                setState(() {
                  password = newValue.trim();
                });
              },
              onTap: () {
                setState(() {
                  validpass = null;
                });
              },
            ),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validpass!=null)?Row(
                    children: [
                      if (!validpass)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validpass)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validpass) Text(" ")
                    ],
                  ):Text(" "),
          ),
        ],
      ),
    );
  }

  Widget _showFirstNameInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Firstname",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
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
              onTap: () {
                setState(() {
                  validfname = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validfname = true;
                  });
                } else {
                  setState(() {
                    validfname = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  firstname = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validfname!=null)?Row(
                    children: [
                      if (!validfname)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validfname)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validfname) Text(" ")
                    ],
                  ):Text(" ")
          ),
        ],
      ),
    );
  }

  Widget _showLastNameInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Lastname",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
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
              onTap: () {
                setState(() {
                  validlname = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validlname = true;
                  });
                } else {
                  setState(() {
                    validlname = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  lastname = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validlname != null)
                ? Row(
                    children: [
                      if (!validlname)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validlname)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validlname) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showNumberInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Mobile Number",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.phone_iphone,
                        color: Colors.white,
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                          child: Text(
                            "+91  ",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ))
                    ]),
                hintText: "1234567890",
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
              keyboardType: TextInputType.number,
              onTap: () {
                setState(() {
                  validnum = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validnum = true;
                  });
                } else {
                  setState(() {
                    validnum = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  number = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validnum != null)
                ? Row(
                    children: [
                      if (!validnum)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validnum)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validnum) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showGenderInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Gender",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.wc,
                        color: Colors.white,
                      ),
                    ]),
                hintText: "ex: Male",
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
              onTap: () {
                setState(() {
                  validgender = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validgender = true;
                  });
                } else {
                  setState(() {
                    validgender = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  gender = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validgender != null)
                ? Row(
                    children: [
                      if (!validgender)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validgender)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validgender) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showDOBInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Date Of Birth",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.event,
                        color: Colors.white,
                      ),
                    ]),
                hintText: "YYYY-MM-DD",
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
              keyboardType: TextInputType.number,
              onTap: () {
                setState(() {
                  validdob = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validdob = true;
                  });
                } else {
                  setState(() {
                    validdob = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  dob = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validdob != null)
                ? Row(
                    children: [
                      if (!validdob)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validdob)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validdob) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showSalarypa() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Salary",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                      ),
                    ]),
                hintText:
                    "In rupees without , or space",
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
              keyboardType: TextInputType.number,
              onTap: () {
                setState(() {
                  validsalary= null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validsalary = true;
                  });
                  
                } else {
                  setState(() {
                    validsalary = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  salary = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validsalary != null)
                ? Row(
                    children: [
                      if (!validsalary)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validsalary)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validsalary) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showjob() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Job",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                    ]),
                hintText: "ex: Doctor",
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
              onTap: () {
                setState(() {
                  validjob = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validjob = true;
                  });
                } else {
                  setState(() {
                    validjob = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  job = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validjob != null)
                ? Row(
                    children: [
                      if (!validjob)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validjob)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validjob) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showDoorNo() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Door no",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: MediaQuery.of(context).size.width/3-20,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
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
              keyboardType: TextInputType.number,
              onTap: () {
                setState(() {
                  validDoorno = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validDoorno = true;
                  });
                } else {
                  setState(() {
                    validDoorno = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  aDoorno = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validjob != null)
                ? Row(
                    children: [
                      if (!validDoorno)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validDoorno)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validDoorno) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showStreet() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            alignment: Alignment.centerLeft,
            child: Text("Street",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: MediaQuery.of(context).size.width*2/3-20,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
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
              onTap: () {
                setState(() {
                  validStreet = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validStreet = true;
                  });
                } else {
                  setState(() {
                    validStreet = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  aStreet = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validjob != null)
                ? Row(
                    children: [
                      if (!validStreet)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validStreet)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validStreet) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showState() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text("State",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2-20,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
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
              onTap: () {
                setState(() {
                  validState = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validState = true;
                  });
                } else {
                  setState(() {
                    validState = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  aState = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validjob != null)
                ? Row(
                    children: [
                      if (!validState)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validState)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validState) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showCity() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Text("City",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: MediaQuery.of(context).size.width/2-20,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
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
              onTap: () {
                setState(() {
                  validCity = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validCity = true;
                  });
                } else {
                  setState(() {
                    validCity = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  aCity = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validjob != null)
                ? Row(
                    children: [
                      if (!validCity)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validCity)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validCity) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showzipcode() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.blue]),
                borderRadius: BorderRadius.circular(10)),
            child: TextFormField(
              //controller: numkey,
              decoration: InputDecoration(
                errorStyle: TextStyle(height: 0),
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10), gapPadding: 10),
                prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                    ]),
                hintText: "ex: 607801",
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
              keyboardType: TextInputType.number,
              onTap: () {
                setState(() {
                  validzipcode = null;
                });
              },
              validator: (value) {
                if (value.toString().trim().isNotEmpty) {
                  setState(() {
                    validzipcode = true;
                  });
                } else {
                  setState(() {
                    validzipcode = false;
                  });
                  return("");
                }
              },
              onSaved: (newValue) {
                setState(() {
                  zipcode = newValue.toString().trim();
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validzipcode != null)
                ? Row(
                    children: [
                      if (!validzipcode)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validzipcode)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validzipcode) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }

  Widget _showAadhaarInput() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0,20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 20, 0, 5),
            alignment: Alignment.center,
            child: Text("To verify your Indian citizenship, enter your",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
            alignment: Alignment.center,
            child: Text("12-digit Aadhar number",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 17,
                    fontWeight: FontWeight.w400)),
          ),
          PinInputTextFormField(
            pinLength: 12,
            keyboardType: TextInputType.number,
            decoration: UnderlineDecoration(colorBuilder: FixedColorBuilder(Colors.red)),
            onChanged: (newValue) {
              setState(() {
                ano=newValue.toString();
              });
            },
            onSaved: (newValue) {
              setState(() {
                ano=newValue.toString();
              });
            },
            validator: (newValue) {
            },
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: (validano != null)
                ? Row(
                    children: [
                      if (!validano)
                        Icon(Icons.cancel, color: Colors.red, size: 15),
                      if (!validano)
                        Text(
                          "  Empty",
                          style: TextStyle(color: Colors.red),
                        ),
                      if (validano) Text(" ")
                    ],
                  )
                : Text(" "),
          )
        ],
      ),
    );
  }
  Widget operation(){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
    child:Row(
      children: [
        if(_isLoading&&error_msg=="")Icon(Icons.verified_user,color: Colors.green, size: 15),
        if(_isLoading&&error_msg=="")Text((state == 2)? "  Verifying...": "  Creating Account...",style: TextStyle(color: Colors.green),),
        if(error_msg!="")Icon(Icons.cancel,color: Colors.red, size: 15),
        if(error_msg!="")Text(error_msg,style: TextStyle(color: Colors.red),),
      ]
    )
    );
  }

  Widget _showbutton() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 40,10, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(50, 10, 50, 10),
        color: Colors.blue,
        child: (_isLoading)
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ))
            : Text(
                (state == 1)
                    ? "Continue"
                    : (state == 2)
                        ? "Login"
                        : (aadhaar_page)
                            ? "Create Account"
                            : "Next",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          if (validateAndSave() && ((state == 1) || (state == 2 ) || (state == 3 ))) {
            setState(() {
              _isLoading = true;
              error_msg="";
            });
            Timer(Duration(seconds: 0), ()  async{
              if(state == 1) await checkmail();
              else if(state == 2) await login();
              else if(aadhaar_page) await createAccount();
              else setState(() {
                aadhaar_page=true;
              });
              setState(() {
                _isLoading = false;
              });
            });
          }
        },
      ),
    );
  }

  Widget _showbackbutton() {
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 3, 0,
          MediaQuery.of(context).size.width / 3, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.indigo,
        child: Text(
          "Back",
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          _formKey.currentState.reset();
          FocusManager.instance.primaryFocus.unfocus();
          setState(() {
            state = 1;
            validemail = null;
            aadhaar_page = false;
            email = "";
          });
        },
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}