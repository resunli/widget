import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show debugPaintSizeEnabled;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter_qq/flutter_qq.dart';
import 'package:fluwx/fluwx.dart';
//import 'package:fluwx/fluwx.dart' as fluwx;
//fluwx.register(appId:"wxd930ea5d5a258f4f");



//https://www.jianshu.com/p/95c0dd5c09a2
//var _scaffoldkey = new GlobalKey<ScaffoldState>();
//@override
//Widget build(BuildContext context) {
//  return Scaffold(
//      key: _scaffoldkey,）
//  }
//void showSnackBar(String message) {
//  var snackBar = SnackBar(content: Text(message));
//  _scaffoldkey.currentState.showSnackBar(snackBar);
//}
//snackbar的使用，showSnackBar
//Scaffold.of() called with a context that does not contain a Scaffold.
//在下面return materialAPP里面加一个 key: _scaffoldkey,
var _scaffoldkey = new GlobalKey<ScaffoldState>();
void showSnackBar(String message) {
  var snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.grey,
    duration: Duration(seconds: 1),
  );
  _scaffoldkey.currentState.showSnackBar(snackBar);
}

//void main() => runApp(MyApp());
void main() {
  debugPaintSizeEnabled = false; // Set to true for visual layout
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false, //去掉屏蔽右上角的debug
      title: 'Flutter Demo Layout',
      home: new MyHomePage(),
      theme: new ThemeData(primaryColor: Colors.blue),
    );
  }

}



class FavoriteWidget extends StatefulWidget {
  @override
  _FavoriteWidgetState createState() => new _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorite = true;
  int _favoriteCount = 41;
  void _toggleFavorite() {
    setState(() {
      if (_isFavorite) {
        _favoriteCount -= 1;
      } else {
        _favoriteCount += 1;
      }
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        //一个图标
        new Container(
          padding: new EdgeInsets.all(0.0),
          child: new IconButton(
              icon: _isFavorite ? Icon(Icons.star) : Icon(Icons.star_border),
              color: Colors.red,
              onPressed: _toggleFavorite),
        ),
        //一个计数
        new SizedBox(
          width: 18.0,
          child: new Container(
            child: new Text('$_favoriteCount'),
          ),
        )
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Widget titleSection = new Container(
      padding: EdgeInsets.only(left: 12, top: 22.0, right: 12, bottom: 22),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Expanded(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: new Text(
                  'Oeschinen Lake Campground',
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ),
              new Text(
                'Kandersteg,Switzerland',
                style: new TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16.0,
                ),
              ),
            ],
          )),
          /*3*/
          new FavoriteWidget(),
//        new Expanded(
//          child: new Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              new FavoriteWidget(),
//            ],
//          ),
//        ),

//          Icon(
//            Icons.star,
//            color: Colors.red[500],
//          ),
//          Text('41'),
        ],
      ),
    );

    //url_launcher调用
    void _openHttpUrl(url) async {
      // Android
      //const url = 'vnd.youtube://';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        //  Ios
        //const url = 'youtube://';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    }

    Future<Null> _handleShareToQQ() async {
      ShareQQContent shareContent = new ShareQQContent(
        title: "测试title",
        targetUrl: "https://www.baidu.com",
        summary: "测试summary",
        imageUrl: "http://inews.gtimg.com/newsapp_bt/0/876781763/1000",
      );
      try {
        var qqResult = await FlutterQq.shareToQQ(shareContent);
        var output;
        if (qqResult.code == 0) {
          output = "分享成功";
        } else if (qqResult.code == 1) {
          output = "分享失败" + qqResult.message;
        } else {
          output = "用户取消";
        }
        setState(() {
          //_output = output;
          showSnackBar(output);
        });
      } catch (error) {
        print("flutter_plugin_qq_example:" + error.toString());
      }
    }
//按钮事件
    void btnTap(int index) {
      showSnackBar('按钮' + index.toString());
    }

    void _onBtn1Press() {
      btnTap(1);
      final url = 'tel:18936950288';
      _openHttpUrl(url);
    }

    void _onBtn2Press() {
      //launch('weixin://');
      //Fluwx.registerApp(RegisterModel(appId: "your app id", doOnAndroid: true, doOnIOS: true));
      //final IWXAPI api = WXAPIFactory.createWXAPI(context, null);
      //api.registerApp(Constants.APP_ID);
    }

    void _onBtn3Press() {
      //_handleShareToQQ();//不知道为什么不能用，直接崩溃
      launch('mqq://');

    }



    //按钮行
    //colum
    Column buildButtonColum(IconData icon, String label, btnPress) {
      Color color = Theme.of(context).primaryColor;
      return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
//          new Icon(icon, color: color),
          new IconButton(
            icon: Icon(icon),
            color: color,
            //onPressed: () {
            // },
            onPressed: btnPress,
          ),
          new Text(
            label,
            style: new TextStyle(fontSize: 12, color: color,fontWeight: FontWeight.w400),
          ),

//          new Container(
//            margin: const EdgeInsets.only(top: 1.0),
//            child: new Text(
//              label,
//              style: new TextStyle(
//                fontSize: 12.0,
//                fontWeight: FontWeight.w400,
//                color: color,
//              ),
//            ),
//          ),
        ],
      );
    }

//按钮 行
    Widget buttonSection = new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildButtonColum(
            Icons.call,
            'Call',
            _onBtn1Press,
          ),
          buildButtonColum(
            Icons.near_me,
            'Route',
            _onBtn2Press,
          ),
          buildButtonColum(
            Icons.share,
            'Share',
            _onBtn3Press,
          )
        ],
      ),
    );

    //文本显示
    Widget textSection = new Container(
      padding:
          const EdgeInsets.only(left: 12, top: 22.0, right: 12, bottom: 22),
      child: new Text(
        'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
        'Alps. Situated 1,578 meters above sea level, it is one of the ...',
        // 'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
        // 'half-hour walk through pastures and pine forest, leads you to the '
        // 'lake, which warms to 20 degrees Celsius in the summer. Activities '
        //'enjoyed here include rowing, and riding the summer toboggan run.',
        softWrap: true,
      ),
    );
    //final snackBar = new SnackBar(content: new Text('这是一个SnackBar!'));



    return MaterialApp(
      debugShowCheckedModeBanner: false, //去掉屏蔽右上角的debug
      title: 'Flutter layout Test',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter layout demo'),
        ),
        body: Column(
          children: [
            new Image.asset(
              'images/lake.jpg',
              width: 600.0,
              height: 240.0,
              fit: BoxFit.cover,
            ),
            titleSection,
            buttonSection,
            textSection,

            new FlatButton(
              onPressed: () {
                //showSnackBar('http...');
                _openHttpUrl('http://www.baidu.com');
              },
              child: new Text('百度'),
            ),
//            new Builder(builder: (BuildContext context) {
//              return new Center(
//                child: new GestureDetector(
//                  onTap: () {
//                    final mySnackBar = SnackBar(
//                      content: new Text('我是SnackBar'),
//                      backgroundColor: Colors.red,
//                      duration: Duration(seconds: 1),
//                      action: new SnackBarAction(
//                          label: '我是scackbar按钮',
//                          onPressed: () {
//                            print('点击了snackbar按钮');
//                          }),
//                    );
//                    Scaffold.of(context).showSnackBar(mySnackBar);
//                  },
//                  child: new Text('点我显示SnackBar'),
//                ),
//              );
//            }),
          ],
        ),
        key: _scaffoldkey,
      ),
    );
  }


}
