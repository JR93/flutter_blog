import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/components/user_avatar.dart';
import 'package:zhiku/models/article_list_data.dart';

class ArticleItem extends StatelessWidget {
  final ArticleData data;
  final void Function(String) onTapTag;
  final void Function(String) onTap;

  ArticleItem({Key key, this.data, this.onTapTag, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: BORDER_COLOR, width: 0.6,),),
      ),
      child: _genItem(context, data),
    );
  }

  /*
   * _genItem: 生成文章项
   */
  Widget _genItem(BuildContext context, ArticleData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 5.0),
                  child: UserAvatar(avatar: data.author.avatar,),
                ),
                Text('${data?.author?.nick ?? data?.author?.name}', style: TextStyle(fontSize: 12.0),),
              ],
            ),
            Row(
              children: data.tags.map((tag) {
                return GestureDetector(
                  onTap: () {
                    onTapTag(tag);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text(tag, style: TextStyle(fontSize: 12.0, color: GREY_COLOR,),),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: GestureDetector(
            onTap: () => onTap('$FES_ORIGIN/index.html?id=${data.id}'),
            child: Text(data.title, style: TextStyle(color: TITLE_COLOR, fontSize: 16.0, fontWeight: FontWeight.bold),),
          ),
        ),
        Html(
          data: data.content.replaceAll('<p>……</p>', ''),
          defaultTextStyle: TextStyle(
            color: TEXT_COLOR,
            fontSize: 14.0,
          ),
          linkStyle: const TextStyle(
            color: LINK_COLOR,
            decorationColor: LINK_COLOR,
            decoration: TextDecoration.underline,
          ),
          onLinkTap: onTap,
        ),
        // Text('${timeFormat(data.createTime)}', style: TextStyle(fontSize: 12.0, color: GREY_COLOR,),),
      ],
    );
  }
}