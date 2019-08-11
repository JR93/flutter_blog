import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/common/utils.dart';
import 'package:zhiku/models/doc_list_data.dart';

class DocItem extends StatelessWidget {
  final DocData data;
  final Function onTap;

  DocItem({Key key, this.data, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0,),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: BLOCK_COLOR,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(offset: Offset(0, 0.5), color: Colors.black12, blurRadius: 0.1),
        ],
      ),
      child: _genItem(data),
    );
  }

  /*
   * _genItem: 生成文档项
   */
  Widget _genItem(DocData data) {
    return GestureDetector(
      onTap: () {
        onTap('$FES_ORIGIN/index.html?id=${data.id}');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, 2, 2, 0),
                child: Icon(Icons.bookmark, color: GREY_COLOR, size: 16.0,),
              ),
              Text(genDocName(data.docType), style: TextStyle(fontSize: 12.0, color: TEXT_COLOR,),),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(data.title, style: TextStyle(color: TITLE_COLOR, fontSize: 16.0, fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
    );
  }
}