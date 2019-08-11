
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';

/*
 * 首页专用，退出提示
 */
class ExitTip extends StatefulWidget {
  final Widget child;
  final void Function() onTap;

  ExitTip({Key key, @required this.child, this.onTap}) : super(key: key);

  _ExitTipState createState() => new _ExitTipState();
}

class _ExitTipState extends State<ExitTip> with SingleTickerProviderStateMixin {

  AnimationController _animation;
  CurvedAnimation _curved;
  Timer _countdownTimer;
  int _lastTime = 0;

  @override
  void initState() {
    super.initState();
    _animation = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _curved = new CurvedAnimation(parent: _animation, curve: Curves.easeInOut);
    _animation.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _lastTime = 0;
        });
      }
    });
  }

  Future<bool> _onWillPop() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastTime < 500) {
      setState(() {
        _lastTime = 0;
      });
      return Future.value(true);
    } else {
      setState(() {
        _lastTime = now;
        _animation.forward();
      });
      _countdownTimer = new Timer.periodic(
        const Duration(milliseconds: 1500),
        (timer) {
          _animation.reverse();
          _countdownTimer?.cancel();
          _countdownTimer = null;
        },
      );
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: BG_COLOR,
        body: Stack(
          children: <Widget>[
            widget.child,
            _lastTime > 0
              ? FadeTransition(
                  opacity: _curved,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 150.0,
                      height: 30.0,
                      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: Color.fromRGBO(0, 0, 0, 0.9),
                      ),
                      child: Center(
                        child: Text(
                          '再次点击退出应用',
                          style: TextStyle(
                              color: Colors.white, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          ],
        ),
        floatingActionButton: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
            decoration: BoxDecoration(
              color: THEME_COLOR,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(offset: Offset(0.0, 1.0), color: Colors.black12, blurRadius: 3,),
              ],
            ),
            child: Icon(Icons.create, color: TITLE_COLOR, size: 24,),
          ),
        ),
      ),
    );
  }
}