import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';

/*
 * 加载中指示器
 */
class LoadingIndicator extends StatelessWidget {
  final bool isLoading;
  final double size;
  final bool isShowText;

  LoadingIndicator({ Key key, this.isLoading = true, this.isShowText = true, this.size = 24.0 }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: Column(
            children: <Widget>[
              SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
                width: size,
                height: size,
              ),
              isShowText ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text('正在加载中', style: TextStyle(color: BORDER_COLOR, fontSize: 12.0,),),
              ) : Container(),
            ],
          ),
        )
      ),
    );
  }
}

/*
 * 加载完成提示
 */
class LoadingCompleteIndicator extends StatelessWidget {
  final String text;

  LoadingCompleteIndicator({ Key key, this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Text(text??'全部加载完了哦~', style: TextStyle(color: BORDER_COLOR,),),
      ),
    );
  }
}

class LoadingCenterIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}