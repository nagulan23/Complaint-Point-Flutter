import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:complaint_point/home_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController namekey=new TextEditingController(text: "");
  TextEditingController numkey=new TextEditingController(text: "");
  TextEditingController passkey=new TextEditingController(text: "");
  TextEditingController emailkey=new TextEditingController(text: "");
  bool _isLoading=false;
  bool validemail;
  bool validpass,crtpass;
  bool validname;
  bool validnum,aadhaar_page=false;
  String email="",password="",name="",number="";
  int state=1;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<int> checkmail() async {
    /*var url = g.api+"userMailInfo/";
    var response = await http.post(url, body: {'email': email});
    var data=json.decode(response.body);
    if(data["status"]=="Login")
    {
      setState(() {
        state=2;
        crtpass=null;
        validpass=null;
        validnum=null;
        validname=null;
        password="";
        aadhaar_page=false;
        _formKey.currentState.reset();
      });
    }
    else
    {
      setState(() {
        state=3;
        validemail=null;
        validpass=null;
        crtpass=null;
        password="";
        name="";
        number="";
        aadhaar_page=false;
      });
    }*/
    setState(() {
      state=2;
        validemail=null;
        validpass=null;
        crtpass=null;
        password="";
        name="";
        number="";
        aadhaar_page=false;
        if(state==2)
        _formKey.currentState.reset();
    });
    return(1);
  }

  Future<int> login() async {
    /*var url = g.api+"userlogin/";
    var response = await http.post(url, body: {'email': email,'password':password});
    var data=json.decode(response.body);
    if(data["status"]=="SUCCESS")
    {
      setState(() {
        crtpass=true;
      });
      _formKey.currentState.reset();
    }
    else
    {
      setState(() {
        crtpass=false;
        password="";
      });
    }*/
    setState(() {
        crtpass=true;
      });
      _formKey.currentState.reset();
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Complaint Point",)));
    return(1);
  }

  Future<int> createAccount() async {
    /*var url = g.api+"userpush/";
    var response = await http.post(url, body: {'email': email,'password':password,'name':name,'mobile_number':number});
    var data=json.decode(response.body);
    if(data["status"]=="SUCCESS")
    {
      setState(() {
        crtpass=true;
      });
    }
    else
    {
      setState(() {
        crtpass=false;

      });
    }*/
    setState(() {
        crtpass=true;
        aadhaar_page=true;
      });
    return(1);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AbsorbPointer(
          absorbing: _isLoading,
        child:Stack(
          children: <Widget>[
            _showForm(),
          ],
        )
      )
    );
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
              _showheader(),
              if(state!=2 && !aadhaar_page)_showEmailInput(),
              if(state==3 && !aadhaar_page)_showNameInput(),
              if(state==3 && !aadhaar_page)_showNumberInput(),
              if(state!=1 && !aadhaar_page)_showPasswordInput(),
              if(aadhaar_page)_showAadhaarInput(),
              _showbutton(),
              if(state!=1)_showbackbutton(),
              Container(
                height: 50,
              )
            ],
          ),
        ));
  }

  Widget _showCircularProgress(){
    return (_isLoading)?new Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.indigo[700]),
      ),
    ):
    Container();
  }

  Widget _showheader(){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/gov.png",width: MediaQuery.of(context).size.height*0.07,),
          Image.asset("assets/logo.png",width: MediaQuery.of(context).size.width*0.7,),
          Container(
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Text("Of the people   .   By the people   .   For the people",textAlign: TextAlign.center,style: TextStyle(color: Colors.indigo[800],fontSize: MediaQuery.of(context).size.width/35,fontWeight:FontWeight.w600,shadows: [Shadow(color:  Colors.blue[200],blurRadius: 5)]),),
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
                  child: Text((state==1)?"Sign-in    Sign-up":(state==2)?"Sign-in":"Sign-up",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight:FontWeight.w500),),
                ),
                if(state==1)Text("/",style: TextStyle(fontSize: 50,color: Colors.white,),)
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _showEmailInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text("Mail-ID",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo,Colors.blue]),
                borderRadius: BorderRadius.circular(10)
              ),
              child:TextFormField(
                //controller: (state==3)?null:emailkey,
                decoration: InputDecoration(
                  errorStyle: TextStyle(height: 0),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 10),
                  prefixIcon: Icon(Icons.mail_outline,color: Colors.white,),
                  hintText: "ex: nagulan1645@gmail.com",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 20,borderSide: BorderSide(color: Colors.indigo[800])),
                ),
                autofocus: false,
                readOnly: (state==3)?true:false,
                initialValue: (state==3)?email:null,
                style: TextStyle(color:Colors.white,decoration: TextDecoration.none),
                cursorColor: Colors.white,
                cursorRadius: Radius.circular(10),
                keyboardType: TextInputType.emailAddress,
                onTap: () {
                  setState(() {
                    validemail=null;
                  });
                },
                validator: (value){
                    if(value.toString().contains("@") && value.toString().contains(".")){
                      setState(() {
                        validemail=true;
                      });
                    }
                    else{
                      setState(() {
                        validemail=false;
                      });
                    }
                },
                onSaved: (newValue) {
                  setState(() {
                    email=newValue.toString();
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validemail!=null)?Row(
                children: [
                  if(validemail && state==1)Icon(Icons.cloud_download,color: Colors.green,size: 15,),
                  if(validemail && state==1)Text("  Fetching Information...",style: TextStyle(color: Colors.green),),
                  if(!validemail)Icon(Icons.cancel,color: Colors.red,size: 15),
                  if(!validemail)Text("  Invalid Mail-ID",style: TextStyle(color: Colors.red),),
                  if(validemail)Text(" ")
                ],
              ):Text(" "),
            )
          ],
        ),
      );
  }

  Widget _showPasswordInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, (state==3)?0:30, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text("Password",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo,Colors.blue]),
                borderRadius: BorderRadius.circular(10)
              ),
              child:TextFormField(
                //controller: passkey,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 10),
                  prefixIcon: Icon(Icons.lock_outline,color: Colors.white,),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 20,borderSide: BorderSide(color: Colors.indigo[800])),
                ),
                autofocus: false,
                style: TextStyle(color:Colors.white,decoration: TextDecoration.none),
                cursorColor: Colors.white,
                cursorRadius: Radius.circular(10),
                obscureText: true,
                validator: (value){
                  setState(() {
                    if(value.toString().trim().isNotEmpty)
                      validpass=true;
                    else
                      validpass=false;
                  });
                },
                onSaved: (newValue) {
                  setState(() {
                    password=newValue.trim();
                  });
                },
                onTap: () {
                  setState(() {
                    validpass=null;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validpass!=null)?Row(
                children: [
                  if(validpass && crtpass==null )Icon(Icons.verified_user,color: Colors.green,size: 15),
                  if(validpass && crtpass==null )Text((state==2)?"  Verifying...":"  Creating Account...",style: TextStyle(color: Colors.green),),
                  if((!validpass && crtpass==null) || (crtpass!=null && !crtpass))Icon(Icons.cancel,color: Colors.red,size: 15,),
                  if(!validpass && crtpass==null)Text("  Empty",style: TextStyle(color: Colors.red),),
                  if(crtpass!=null && !crtpass)Text((state==2)?"  Incorrect":"  Account already exists",style: TextStyle(color: Colors.red),),
                  if(validpass)Text(" ")
                ],
              ):Text(" ")
            )
          ],
        ),
      );
  }

  Widget _showNameInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text("Name",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo,Colors.blue]),
                borderRadius: BorderRadius.circular(10)
              ),
              child:TextFormField(
                //controller: namekey,
                decoration: InputDecoration(
                  errorStyle: TextStyle(height: 0),
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 10),
                  prefixIcon: Icon(Icons.perm_identity,color: Colors.white,),
                  hintText: "Firstname Lastname",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 20,borderSide: BorderSide(color: Colors.indigo[800])),
                ),
                autofocus: false,
                style: TextStyle(color:Colors.white,decoration: TextDecoration.none),
                cursorColor: Colors.white,
                cursorRadius: Radius.circular(10),
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {
                    validname=null;
                  });
                },
                validator: (value){
                    if(value.toString().trim().isNotEmpty){
                      setState(() {
                        validname=true;
                      });
                    }
                    else{
                      setState(() {
                        validname=false;
                      });
                    }
                },
                onSaved: (newValue) {
                  setState(() {
                    name=newValue.toString();
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validname!=null)?Row(
                children: [
                  if(!validname)Icon(Icons.cancel,color: Colors.red,size: 15),
                  if(!validname)Text("  Empty",style: TextStyle(color: Colors.red),),
                  if(validname)Text(" ")
                ],
              ):Text(" "),
            )
          ],
        ),
      );
  }

  Widget _showNumberInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text("Mobile Number",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo,Colors.blue]),
                borderRadius: BorderRadius.circular(10)
              ),
              child:TextFormField(
                //controller: numkey,
                decoration: InputDecoration(
                  errorStyle: TextStyle(height: 0),
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 10),
                  prefixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      Container(width: 10,),
                      Icon(Icons.phone_iphone,color: Colors.white,),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child:Text("+91  ",style: TextStyle(color:Colors.white,fontSize: 17),)
                      )
                    ]
                  ),
                  hintText: "1234567890",
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),gapPadding: 20,borderSide: BorderSide(color: Colors.indigo[800])),
                ),
                autofocus: false,
                style: TextStyle(color:Colors.white,decoration: TextDecoration.none),
                cursorColor: Colors.white,
                cursorRadius: Radius.circular(10),
                keyboardType: TextInputType.text,
                onTap: () {
                  setState(() {
                    validnum=null;
                  });
                },
                validator: (value){
                    if(value.toString().trim().isNotEmpty){
                      setState(() {
                        validnum=true;
                      });
                    }
                    else{
                      setState(() {
                        validnum=false;
                      });
                    }
                },
                onSaved: (newValue) {
                  setState(() {
                    number=newValue.toString();
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validnum!=null)?Row(
                children: [
                  if(!validnum)Icon(Icons.cancel,color: Colors.red,size: 15),
                  if(!validnum)Text("  Empty",style: TextStyle(color: Colors.red),),
                  if(validnum)Text(" ")
                ],
              ):Text(" "),
            )
          ],
        ),
      );
  }

  Widget _showGenderInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.centerLeft,
              child: Text("Gender",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validname!=null)?Row(
                children: [
                  if(!validname)Icon(Icons.cancel,color: Colors.red,size: 15),
                  if(!validname)Text("  Empty",style: TextStyle(color: Colors.red),),
                  if(validname)Text(" ")
                ],
              ):Text(" "),
            )
          ],
        ),
      );
  }

  Widget _showAadhaarInput(){
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,20, 0, 5),
              alignment: Alignment.center,
              child: Text("To verify your Indian citizenship, enter your",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(10,0, 0, 10),
              alignment: Alignment.center,
              child: Text("12-digit Aadhar number",style:TextStyle(color: Colors.deepPurple[800],fontSize: 17,fontWeight: FontWeight.w400)),
            ),
            PinFieldAutoFill(
              codeLength: 12,
              keyboardType: TextInputType.number,

            ),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: (validname!=null)?Row(
                children: [
                  if(!validname)Icon(Icons.cancel,color: Colors.red,size: 15),
                  if(!validname)Text("  Empty",style: TextStyle(color: Colors.red),),
                  if(validname)Text(" ")
                ],
              ):Text(" "),
            )
          ],
        ),
      );
  }

  Widget _showbutton(){
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/4, 40, MediaQuery.of(context).size.width/4, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        color: Colors.blue,
        child: (_isLoading)?SizedBox( 
          width: 15,
          height: 15,
          child:CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ):
        Text((state==1)?"Continue":(state==2)?"Login":(aadhaar_page)?"Create Account":"Next",style: TextStyle(color: Colors.white,fontSize: 15),),
        onPressed: () async {
          FocusManager.instance.primaryFocus.unfocus();
          validateAndSave();
          if((state==1 && validemail)||(state==2&&validpass)||(state==3&&validemail&&validpass&&validname&&validnum))
          {
            setState(() {
              _isLoading=true;
            });
            Timer(Duration(seconds: 2),() async {
              (state==1)?await checkmail():(state==2)?await login():await createAccount();
              setState(() {
                _isLoading=false;
              });
            });
          }
        },
      ),
    );
  }

  Widget _showbackbutton(){
    return Container(
      margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/3, 0, MediaQuery.of(context).size.width/3, 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.indigo,
        child: Text("Back",style: TextStyle(color: Colors.white),),
        onPressed: () {
          _formKey.currentState.reset();
          FocusManager.instance.primaryFocus.unfocus();
          setState(() {
            state=1;
            validemail=null;
            aadhaar_page=false;
            email="";
          });
        },
      ),
    );
  }
}
