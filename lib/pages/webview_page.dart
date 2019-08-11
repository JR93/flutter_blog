import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/models/pop_info.dart';
import 'package:zhiku/components/loading.dart';

class WebviewPage extends StatefulWidget {
  final String url;

  WebviewPage(this.url);

  @override
  _WebviewPageState createState() => new _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  WebViewController _controller;
  String _title = '正在加载中...';
  int _yyuid = 0;
  int _index = 1;

  void _closeWebview() async {
    String curUrl = await _controller.currentUrl();
    // 只有包含fes_m_blog才返回uid
    if (curUrl.contains('fes_m_blog')) {
      // 如果为0时，则获取
      if (_yyuid == 0) {
        var uid = await _controller.evaluateJavascript("window.localStorage.getItem('fes_user_uid')");
        if (Platform.isAndroid) {
          // Android端返回的是json字符串，iOS暂时只支持string和string格式的NSArray，其他类型数据还不支持。
          uid = json.decode(uid);
        }
        _yyuid = (uid != null && uid != 'null') ? int.parse(uid) : 0;
      }
    }
    Navigator.of(context).pop(json.encode({
      'yyuid': _yyuid,
    }));
  }

  void _gotoLogin() async {
    var result = await Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return WebviewPage('$FES_ORIGIN/login.html');
      }
    ));
    if (result != null) {
      var data = PopInfo.fromJson(json.decode(result));
      if (data.yyuid > 0 && data.yyuid != _yyuid) {
        _yyuid = data.yyuid;
      }
    }
    _controller.evaluateJavascript("window.onBridgeEvent('pageBack')");
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool get _isFesLogin {
    return widget.url.contains('fes_m_blog/login.html');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _closeWebview();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: _backgroundColor(BG_COLOR),
        appBar: AppBar(
          backgroundColor: _backgroundColor(THEME_COLOR),
          title: Text(_isFesLogin ? '请使用工号登录' : _title, style: TextStyle(fontSize: 18.0,),),
          elevation: 0.0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              if (await _controller.canGoBack()) {
                _controller.goBack();
              } else {
                _closeWebview();
              }
            },
            child: Icon(Icons.arrow_back_ios),
          ),
        ),
        body: IndexedStack(
          index: _index,
          children: <Widget>[
            WebView(
              initialUrl: widget.url,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: <JavascriptChannel>[
                JavascriptChannel(
                  name: 'FesBridgeApiOfPop',
                  onMessageReceived: (JavascriptMessage message) {
                    _closeWebview();
                  },
                ),
                JavascriptChannel(
                  name: 'FesBridgeApiOfLogin',
                  onMessageReceived: (JavascriptMessage message) {
                    _gotoLogin();
                  },
                ),
              ].toSet(),
              onWebViewCreated: (WebViewController controller) {
                _controller = controller;
              },
              onPageFinished: (String url) async {
                if (_controller != null) {
                  var title = await _controller.evaluateJavascript('document.title');
                  if (Platform.isAndroid) {
                    // Android端返回的是json字符串，iOS暂时只支持string和string格式的NSArray，其他类型数据还不支持。
                    title = json.decode(title);
                  }
                  setState(() {
                    _title = title;
                    _index = 0;
                  });
                }
              },
            ),
            LoadingCenterIndicator(),
          ],
        ),
      ),
    );
  }

  Color _backgroundColor(Color color) {
    return _isFesLogin ? Color(0xFFEFF3F5) : color;
  }
}
