import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/components/user_avatar.dart';
import 'package:zhiku/pages/search_page.dart';

class HomeSearchBar extends StatelessWidget {
  final String avatar;
  final int yyuid;
  final Function onTap;

  HomeSearchBar({Key key, this.avatar, this.yyuid, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        color: THEME_COLOR,
        child: Row(
          children: <Widget>[
            Text('知库', style: TextStyle(fontSize: 18.0, color: TITLE_COLOR, fontWeight: FontWeight.bold,),),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (BuildContext context) {
                      return SearchPage();
                    }
                  ));
                },
                child: Container(
                  height: 32.0,
                  margin: EdgeInsets.symmetric(horizontal: 15.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(90, 255, 255, 255),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search,
                        size: 22,
                        color: TITLE_COLOR,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Text('搜索文章关键字、标签', style: TextStyle(fontSize: 14.0, color: TITLE_COLOR),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: yyuid > 0
                ? UserAvatar(avatar: avatar, size: 24)
                : Icon(Icons.account_circle, size: 30,),
            ),
          ],
        ),
      ),
    );
  }
}