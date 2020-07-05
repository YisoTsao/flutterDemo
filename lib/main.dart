import 'package:flutter/material.dart';
import 'package:flutterDemo/nav-drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterDemo/login.dart';
import 'package:flutterDemo/test.dart';
import 'package:flutterDemo/signup2.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        primaryColor: Colors.pink,
        accentColor: Colors.green,
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.purple)),
        // primarySwatch: Colors.pink,
       
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo'),
      routes:{
        "member_info":(context) => MemberInfo(text: "Gary",),
        "login":(context) => LoginPage(title: "GaryLogin",),
        "/":(context) => MyHomePage(title: 'Flutter 首頁'),
        "test":(context) => ScrollControllerTestRoute(),
        } ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  int _selectedIndex = 1;
  SharedPreferences logindata;
  String username;
  String userid;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
    initialUser();
  }
  void checkIfAlreadyLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool islogin = prefs?.getBool('isLoggedIn' ?? true);
    print('init: $islogin');
  }
  
  void initialUser() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('userInfo');
      userid = logindata.getString('userInfoId');
      print('setState_name: $username');
      print('setState_id: $userid');
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      home: Scaffold(
        drawer: NavDrawer(),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(icon: Icon(Icons.business), title: Text('Business')),
            BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('School')),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blue,
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          title: Text("Demo1"),
          // leading: GestureDetector(
          //   onTap: () { },
          //   child: Icon(
          //   Icons.menu,
          //   ),
          // ),
          actions: <Widget>[
            // FlatButton(
            //   textColor: Colors.white,
            //    onPressed: () async {
            //     await Navigator.pushNamed( context,  "login");
            //   },
            //   child: Text("username"),
            //   shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
            // ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              )
            ),
            loginStatus(username),
          ],
          backgroundColor: Colors.red,
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 8.0,
          children: <Widget>[
            // Image.network("https://placeimg.com/500/500/any"),
            Icon(
              Icons.ac_unit,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.airport_shuttle,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.all_inclusive,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.beach_access,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.cake,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.access_alarms,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.account_balance_wallet,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.add_shopping_cart,
               size: 48.0,
               color: Colors.blueGrey,
            ),
            Icon(
              Icons.airline_seat_flat,
               size: 48.0,
               color: Colors.blueGrey,
            ),
          ],
        )),
      ),
    );
  }

  loginStatus(username){
    if(username == null){
      final ls1 = PopupMenuButton<int>(
        itemBuilder: (context) =>
          [
            PopupMenuItem(
              value: 1,
              child: Text(username ?? "登入"),
            ),
            PopupMenuItem(
              value: 3,
              child: Text("說明"),
            ),
          ],
        
        onSelected: (value) {
          if (value == 1) {
            Navigator.pushNamed(context, "login");
          }
        }
      );
      return ls1 ;
    }else{
      final ls2 = PopupMenuButton<int>(
        itemBuilder: (context) =>
          [
            PopupMenuItem(
              value: 0,
              child: Text(username),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("登出"),
            ),
            PopupMenuItem(
              value: 3,
              child: Text("test"),
            ),
          ],
        
        onSelected: (value) async {
          if (value == 0) {
            await Navigator.of(context).pushNamed("member_info", arguments: {'name': username, 'id': userid});
            // Navigator.pushNamed(context, "member_info");
          }
          if (value == 2) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('isLoggedIn');
            prefs.remove('userInfo');
            Navigator.pushNamed( context,  "/");
          }
          if (value == 3) {
            await Navigator.of(context).pushNamed("test");
            // Navigator.pushNamed(context, "member_info");
          }
        }
      );
      return ls2 ;
    }
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  // TabController tabController;
  // @override
  // Widget build(BuildContext context) {
  //   tabController = new TabController(length: 2, vsync: this);

  //   var tabBarItem = new TabBar(
  //     tabs: [
  //       new Tab(
  //         icon: new Icon(Icons.list),
  //       ),
  //       new Tab(
  //         icon: new Icon(Icons.grid_on),
  //       ),
  //     ],
  //     controller: tabController,
  //     indicatorColor: Colors.white,
  //   );

  //   var listItem = new ListView.builder(
  //     itemCount: 20,
  //     itemBuilder: (BuildContext context, int index) {
  //       return new ListTile(
  //         title: new Card(
  //           elevation: 5.0,
  //           child: new Container(
  //             alignment: Alignment.center,
  //             margin: new EdgeInsets.only(top: 10.0, bottom: 10.0),
  //             child: new Text("ListItem $index"),
  //           ),
  //         ),
  //         onTap: () {
  //           showDialog(
  //               barrierDismissible: false,
  //               context: context,
  //               child: new CupertinoAlertDialog(
  //                 title: new Column(
  //                   children: <Widget>[
  //                     new Text("ListView"),
  //                     new Icon(
  //                       Icons.favorite,
  //                       color: Colors.red,
  //                     ),
  //                   ],
  //                 ),
  //                 content: new Text("Selected Item $index"),
  //                 actions: <Widget>[
  //                   new FlatButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: new Text("OK"))
  //                 ],
  //               ));
  //         },
  //       );
  //     },
  //   );

  //   var gridView = new GridView.builder(
  //       itemCount: 20,
  //       gridDelegate:
  //           new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
  //       itemBuilder: (BuildContext context, int index) {
  //         return new GestureDetector(
  //           child: new Card(
  //             elevation: 5.0,
  //             child: new Container(
  //               alignment: Alignment.center,
  //               child: new Text('Item $index'),
  //             ),
  //           ),
  //           onTap: () {
  //             showDialog(
  //               barrierDismissible: false,
  //               context: context,
  //               child: new CupertinoAlertDialog(
  //                 title: new Column(
  //                   children: <Widget>[
  //                     new Text("GridView"),
  //                     new Icon(
  //                       Icons.favorite,
  //                       color: Colors.green,
  //                     ),
  //                   ],
  //                 ),
  //                 content: new Text("Selected Item $index"),
  //                 actions: <Widget>[
  //                   new FlatButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       child: new Text("OK"))
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       });

  //   return new DefaultTabController(
  //     length: 2,
  //     child: new Scaffold(
  //       appBar: new AppBar(
  //         title: new Text("Flutter TabBar"),
  //         bottom: tabBarItem,
  //       ),
  //       body: new TabBarView(
  //         controller: tabController,
  //         children: [
  //           listItem,
  //           gridView,
  //         ],
  //       ),
  //     ),
  //   );
  // }
}

class MemberInfo extends StatelessWidget {
  String name;
  String id;
  MemberInfo({
    Key key,
    @required this.text,  // 接收text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    // 獲取路由參數  
    dynamic obj = ModalRoute.of(context).settings.arguments;
    name = obj["name"];
    id = obj["id"];
    return Scaffold(
      appBar: AppBar(
        title: Text("會員資訊"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(            
            children: <Widget>[
              Text(name),
              Text(id),
              RaisedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text("返回"),
              ),
               RaisedButton(
                onPressed: () {
                  confirmDialog(context);
                },
                child: Text("測試modal"),
              ), 
              SnackBarPage(),
            ],
          ),
        ),
      ),
    );
  }
}


//顯示 SnackBar 訊息與自定義按鈕
class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('顯示訊息'),
            action: SnackBarAction(
              label: '復原',
              onPressed: () {
                
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}


enum ConfirmAction { ACCEPT, CANCEL }

Future<ConfirmAction> confirmDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, //控制點擊對話框以外的區域是否隱藏對話框
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('確認取消對話視窗'),
        content: const Text('內容訊息'),
        actions: <Widget>[
          FlatButton(
            child: const Text('確認'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          ),
          FlatButton(
            child: const Text('取消'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          )
        ],
      );
    },
  );
}