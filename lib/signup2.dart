import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class MemberSignUpPage extends StatefulWidget {
  MemberSignUpPage({Key key}) : super(key: key);

  @override
  _MemberSignUpPageState createState() => _MemberSignUpPageState();
}

class _MemberSignUpPageState extends State<MemberSignUpPage> {
  GlobalKey _formKey = new GlobalKey<FormState>();
  
  TextEditingController _unameController = new TextEditingController();
  TextEditingController _idController = new TextEditingController();
  TextEditingController _pwdController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  bool _epaperSelected = true;
  bool _smsSelected = true;

  String _date = "";
  final formatdate = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("註冊會員"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        margin: EdgeInsets.only(top: 10.0),
        child: Form(
          key: _formKey,
          autovalidate: false,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "姓名",
                    hintText: "請輸入姓名",
                    icon: Icon(Icons.person)
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "姓名不能為空白";
                  }
                ),
              ),
              
              Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  autofocus: true,
                  controller: _idController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "身分證",
                    hintText: "請輸入身分證號碼",
                    icon: Icon(Icons.portrait)
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "身分證不能為空白";
                  }
                ),
              ),
              
              Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "密碼",
                    hintText: "您的登錄密碼",
                    icon: Icon(Icons.lock)
                  ),
                  obscureText: true,
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密碼不能少於6位";
                  }
                )
              ),

              Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "E-mail",
                    hintText: "請輸入E-mail",
                    icon: Icon(Icons.email)
                  ),
                  validator: (v) {
                    print(validateEmail(v));
                    if(v.isEmpty){
                      return "E-mail不可空白";
                    }else{
                      return validateEmail(v) ? null : "E-mail格式有誤";
                    }
                  }
                )
              ),
              
              Container(
                margin: EdgeInsets.all(4.0),
                padding: EdgeInsets.only(bottom: 8),
                child: TextFormField(
                  autofocus: true,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "電話",
                    hintText: "請輸入電話號碼",
                    icon: Icon(Icons.phone)
                  ),
                  validator: (v) {
                    if(v.isEmpty){
                      return "電話不能為空白";
                    }
                    return v.trim().length < 10 ? "手機號碼長度錯誤" : null ;
                  }
                )
              ),          
              
             Container(
               margin: EdgeInsets.all(4.0),
               child: DateTimeField(
                format: formatdate,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '日期',
                  icon: Icon(Icons.date_range)
                ),
                onChanged: (value) {
                  setState(() {
                    print('lala: $value');
                    print(value.toString());
                    
                    _date = value.toString();
                  });
                  return null;
                },
                onShowPicker: (context, currentValue) async{
                  return await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));                  
                },
              ),
             ),
              
              SwitchListTile(
                title: Text('訂閱電子報'),
                value: _epaperSelected,
                onChanged:(value){
                  setState(() {
                    _epaperSelected = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('接收最新消息'),
                value: _smsSelected,
                onChanged:(value){
                  setState(() {
                    _smsSelected = value;
                  });
                },
              ),
                
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("註冊"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      
                      onPressed: () {                        
                        if((_formKey.currentState as FormState).validate()){
                          var currentDate = _date == "null" ? "" : _date ;
                          var name = _unameController.text;
                          var passwd = _pwdController.text;
                          var id = _idController.text;
                          var email = _emailController.text;
                          var phone = _phoneController.text ?? "";
                          var epaper = _epaperSelected == true ? "Y" : "N";
                          var sms = _smsSelected == true ? "Y" : "N";

                          print('currentDate: $currentDate');
                          Map userparams = { 
                            "Data": {
                              "AcctName": name,
                              "LoginID": id,
                              "Birth": currentDate,
                              "Email": email,
                              "Psw": passwd,
                              "MainCell": phone,
                              "EpaperSts": epaper,
                              "SMSSts": sms
                            },
                            "Source_id": 4
                          };
                          _signUpFunc(userparams);
                        }     
                      }
                    ),
                  ),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  Future<bool> showSignUpConfirmDialog(BuildContext context, code, message) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          // title: Text("提示"),
          content: code == 0 ? Text("新增會員成功") : Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("確定"),
              onPressed: () {
                if(code == 0){
                  Navigator.of(context).pushNamed("/");
                }else{
                  Navigator.of(context).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  _signUpFunc(params) async {
    HttpClient client = new HttpClient();
    client.badCertificateCallback = ((X509Certificate cert, String host, int port) => true);

      String url ='https://10.2.108.136:3366/carplus/member/registration';

      HttpClientRequest request = await client.postUrl(Uri.parse(url));
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(params)));
      HttpClientResponse response = await request.close();
      String reply = await response.transform(utf8.decoder).join();

      var parsedReply = json.decode(reply);
      print(parsedReply);
      var code = parsedReply["ReturnCode"];
      var message = parsedReply["ReturnMessage"];
      // print(parsedReply["Status"]);
      if(code == 0){
        print(0);
      }else{
        print(message);
      }
      showSignUpConfirmDialog(context, code, message);
  }
    
  bool validateEmail(String value) {
    return RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value) ? true : false;
  }

}


