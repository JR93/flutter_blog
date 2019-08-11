import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/common/utils.dart';

class TagsBar extends StatelessWidget {
  final String name;
  final String docType;
  final void Function(String) onTap;

  TagsBar({Key key, @required this.name, this.docType = '', this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      padding: EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: BLOCK_COLOR,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 0.1,),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: name == BLOG_NAME
          ? ARTICLE_TAGS.map((String tag) { return _tag(name, tag); }).toList()
          : DOC_TAGS.map((String tag) { return _tag(name, tag); }).toList(),
      ),
    );
  }

  /*
   * _tag: 生成标签
   */
  Widget _tag(String name, String tag) {
    return InkWell(
      onTap: () => onTap(tag),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        padding: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: (name == DOC_NAME && docType == tag) ? THEME_COLOR : BG_COLOR,
          borderRadius: BorderRadius.circular(14.0),
        ),
        child: Center(
          child: Text(
            name == BLOG_NAME ? tag : genDocName(tag),
            style: TextStyle(
              fontSize: 12.0,
              color: TITLE_COLOR,
              fontWeight: (name == DOC_NAME && docType == tag) ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}