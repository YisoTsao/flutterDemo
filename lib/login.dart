import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userNameController = TextEditingController();

  TextEditingController _unameController = new TextEditingController();

  TextEditingController _pwdController = new TextEditingController();

  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("Log-in"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _formKey, //設置globalKey，用於後面護取FormState
          autovalidate: true, //開啟自動校驗
          child: Column(
            children: <Widget>[
              TextFormField(
                  autofocus: true,
                  controller: _unameController,
                  decoration: InputDecoration(
                      labelText: "用戶名",
                      hintText: "用戶名或信箱",
                      icon: Icon(Icons.person)
                  ),
                  // 校驗用戶名
                  validator: (v) {
                    return v.trim().length > 0 ? null : "用戶名不能為空";
                  }

              ),
              TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                      labelText: "密碼",
                      hintText: "您的登錄密碼",
                      icon: Icon(Icons.lock)
                  ),
                  obscureText: true,
                  //校驗密碼
                  validator: (v) {
                    return v.trim().length > 5 ? null : "密碼不能少於6位";
                  }
              ),
              // 登錄按钮
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("登錄"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          
                          if((_formKey.currentState as FormState).validate()){
                            final name = _unameController.text;
                            final passwd = _pwdController.text;

                            try {
                              Response response = await Dio().post("http://localhost:8080/Login?account=$name&password=$passwd");
                              final status = response.data['Status'];
                              print(status);

                              if(status == true){
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs?.setBool("isLoggedIn", true);
                                prefs?.setString("userInfo", response.data['name']);
                                prefs?.setString("userInfoId", response.data['userid']);
                                await Navigator.of(context).pushNamed("/");
                              }
                             
                            } catch (e) {
                              print(e);
                            }

                              print("validate Ok");
                          }else{
                            print("validate Fail");
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}