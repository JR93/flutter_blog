import 'package:flutter/material.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/components/article_item.dart';
import 'package:zhiku/components/empty_tip.dart';
import 'package:zhiku/models/api.dart';
import 'package:zhiku/models/article_list_data.dart';
import 'package:zhiku/pages/webview_page.dart';
import 'package:zhiku/components/loading.dart';

class SearchPage extends StatefulWidget {
  final String queryTag;

  SearchPage({Key key, this.queryTag = ''}) : super(key: key);

  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller;
  ScrollController _scrollController; // 滚动监听
  List<ArticleData> _lists = []; // 存储列表数据
  bool _showClear = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController();
    _scrollController = new ScrollController();
    _initCheck();
  }

  void _initCheck() {
    if (widget.queryTag != '') {
      _controller.text = widget.queryTag;
      _loadSerachData(queryTag: widget.queryTag);
    }
  }

  void _loadSerachData({queryTag = '', query = ''}) async {
    setState(() {
      _isLoading = true;
    });
    List<ArticleData> data = await Api.getSearchList(queryTag: queryTag, query: query);
    _lists.clear();
    _lists.addAll(data);
    setState(() {
      _isLoading = false;
    });
  }

  void _onSubmit(String val) {
    if (val != '') {
      String tag = '';
      for (int i = 0, len = ARTICLE_TAGS.length; i < len; i++) {
        if (ARTICLE_TAGS[i].toLowerCase().contains(val.toLowerCase())) {
          tag = ARTICLE_TAGS[i];
          break;
        }
      }
      if (tag != '') {
        _loadSerachData(queryTag: tag);
      } else {
        _loadSerachData(query: val);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BG_COLOR,
      body: Column(
        children: <Widget>[
          Container(
            color: THEME_COLOR,
            height: MediaQuery.of(context).padding.top,
          ),
          _searchBar(),
          Expanded(
            flex: 1,
            child: IndexedStack(
              index: _isLoading ? 1 : 0,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: _lists.length > 0
                  ? ListView.builder(
                      controller: _scrollController,
                      itemCount: _lists.length,
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      itemBuilder: (BuildContext context, int index) {
                        return ArticleItem(
                          data: _lists[index],
                          onTap: (url) {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (BuildContext context) {
                                return WebviewPage(url);
                              }
                            ));
                          },
                          onTapTag: (tag) {
                            _controller.text = tag;
                            _loadSerachData(queryTag: tag);
                          },
                        );
                      }
                    )
                  : Container(
                      child: EmptyTip(
                        text: '没有搜索到相关文章哦，快去首页浏览吧~',
                      ),
                    ),
                ),
                LoadingCenterIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 8, 22, 8),
      color: THEME_COLOR,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: Icon(Icons.arrow_back_ios),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              height: 32.0,
              margin: EdgeInsets.fromLTRB(5, 0, 20, 0),
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
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _controller,
                      onChanged: (String text) {
                        if (text.length > 0) {
                          setState(() {
                            _showClear = true;
                          });
                        } else {
                          setState(() {
                            _showClear = false;
                          });
                        }
                      },
                      onSubmitted: _onSubmit,
                      autofocus: widget.queryTag == '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        border: InputBorder.none,
                        hintText: '搜索文章关键字、标签',
                        hintStyle: TextStyle(fontSize: 14),
                        fillColor: Colors.red,
                      ),
                      cursorColor: TITLE_COLOR,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  _showClear ? GestureDetector(
                    onTap: () {
                      _controller.text = '';
                      setState(() {
                        _showClear = false;
                      });
                    },
                    child: Icon(Icons.clear, size: 22,),
                  ) : Container(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _onSubmit(_controller.text);
            },
            child: Text('搜索', style: TextStyle(color: TITLE_COLOR, fontSize: 16, fontWeight: FontWeight.bold,),),
          ),
        ],
      ),
    );
  }
}