import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zhiku/common/consts.dart';
import 'package:zhiku/components/article_item.dart';
import 'package:zhiku/components/doc_item.dart';
import 'package:zhiku/components/empty_tip.dart';
import 'package:zhiku/components/exit_tip.dart';
import 'package:zhiku/components/home_search_bar.dart';
import 'package:zhiku/components/loading.dart';
import 'package:zhiku/components/sticky_tab_bar_delegate.dart';
import 'package:zhiku/components/tags_bar.dart';
import 'package:zhiku/models/api.dart';
import 'package:zhiku/models/article_list_data.dart';
import 'package:zhiku/models/doc_list_data.dart';
import 'package:zhiku/models/pop_info.dart';
import 'package:zhiku/pages/search_page.dart';
import 'package:zhiku/pages/webview_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  List<String> _tabs = [BLOG_NAME, DOC_NAME]; // tab标签

  TabController _tabController;
  ScrollController _scrollController;

  List<ArticleData> _lists = []; // 存储文章列表数据
  String _lastDate = ''; // 用于文章列表分页请求
  bool _isLoading = true; // 是否加载中
  bool _isComplete = false; // 是否加载完了
  bool _isRefresh = false; // 是否是下拉刷新

  List<DocData> _docLists = []; // 存储文档列表数据
  bool _isDocLoading = false; // 是否文档加载完了
  String _curDocType = 'all';

  SharedPreferences _prefs;
  String _avatar = DEFAULT_AVATAR;
  int _yyuid = 0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /*
   * @method _init: 初始化程序
   */
  void _init() {
    // 检查本地缓存
    _checkState();
    // 初始化控制器
    _tabController = new TabController(vsync: this, length: _tabs.length);
    _scrollController = new ScrollController();
    // 监听滚动到底部加载
    _scrollController.addListener(() {
      // 目前只针对文章的滚动加载
      if (_tabController.index == 0 && !_isRefresh && _scrollController.position.pixels > _scrollController.position.maxScrollExtent - 10) {
        if (!_isComplete && !_isLoading && _lists.length > 0) {
          _loadArticleData();
        }
      }
    });
    // 初始化加载文章数据
    _loadArticleData();
    // 初始化加载文档数据
    _loadDocData();
  }

  /*
   * @method _checkState: 检查本地状态
   */
  void _checkState() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _yyuid = _prefs.getInt('yyuid') ?? 0;
      _avatar = _prefs.getString('avatar') ?? DEFAULT_AVATAR;
    });
  }

  /*
   * @method _loadAvatar: 获取头像
   */
  void _loadAvatar(int uid) async {
    var result = await Api.getUserAvatar(uid);
    if (result.code == 0) {
      await _prefs.setString('avatar', result.data.headPic ?? DEFAULT_AVATAR);
      setState(() {
        _avatar = _prefs.getString('avatar');
      });
    }
  }

  /*
   * @method _gotoUrl: 打开新页面
   */
  void _gotoUrl(String url) async {
    var result = await Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return WebviewPage(url);
      }
    ));
    if (result != null) {
      var data = PopInfo.fromJson(json.decode(result));
      if (data.yyuid > 0 && data.yyuid != _yyuid) {
        setState(() {
          _yyuid = data.yyuid;
        });
        _loadAvatar(data.yyuid);
        await _prefs.setInt('yyuid', data.yyuid);
      } else if (data.yyuid == 0) {
        setState(() {
          _yyuid = 0;
        });
        await _prefs.setInt('yyuid', 0);
      }
    }
  }

  void _gotoSearchPage(String tag) {
    Navigator.push(context, MaterialPageRoute(
      builder: (BuildContext context) {
        return SearchPage(query: tag);
      }
    ));
  }

  /*
   * @method _loadArticleData: 加载文章列表数据
   */
  void _loadArticleData() async {
    setState(() {
      if (_isRefresh) {
        _lastDate = '';
        _isComplete = false;
      } else {
        _isLoading = true;
      }
    });
    List<ArticleData> data = await Api.getArticleList(lastDate: _lastDate);
    if (!mounted) {
      return;
    }
    setState(() {
      if (_isRefresh) {
        _lists.clear();
      }
      if (data.length > 0) {
        if (data.length >= 10) {
          _isLoading = false;
        } else {
          _isLoading = false;
          _isComplete = true;
        }
        _lists.addAll(data);
        _lastDate = _lists[_lists.length - 1]?.createTime ?? '';
      } else {
        _isLoading = false;
        _isComplete = true;
      }
      if (_isRefresh) {
        _isRefresh = false;
      }
    });
  }

  /*
   * @method _loadDocData: 加载文档列表数据
   */
  void _loadDocData() async {
    setState(() {
      _isDocLoading = true;
    });
    List<DocData> data = await Api.getDocsList();
    if (!mounted) {
      return;
    }
    setState(() {
      if (_docLists.length > 0) {
        _docLists.clear();
      }
      _docLists.addAll(data);
      _isDocLoading = false;
    });
  }

  /*
   * @method _refreshArticleData: 刷新加载文章列表数据
   */
  Future _refreshArticleData() async {
    setState(() {
      _isRefresh = true;
    });
    _loadArticleData();
  }

  /*
   * @method _refreshDocData: 刷新加载文档列表数据
   */
  Future _refreshDocData() async {
    _loadDocData();
  }

  @override
  Widget build(BuildContext context) {
    return ExitTip(
      onTap: () {
        _gotoUrl('$FES_ORIGIN/${_yyuid > 0 ? 'user' : 'login'}.html');
      },
      child: Column(
        children: <Widget>[
          Container(
            color: THEME_COLOR,
            height: MediaQuery.of(context).padding.top,
          ),
          Expanded(
            flex: 1,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  HomeSearchBar(
                    avatar: _avatar,
                    yyuid: _yyuid,
                    onTap: () {
                      _gotoUrl('$FES_ORIGIN/${_yyuid > 0 ? 'user' : 'login'}.html');
                    }
                  ),
                  _tabBar(context),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: _tabs.map((String name) {
                  return _tabBarView(name);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
   * _tabBar: tabBar组件
   */
  Widget _tabBar(BuildContext context) {
    return SliverOverlapAbsorber(
      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
      child: SliverPersistentHeader(
        pinned: true,
        floating: true,
        delegate: StickyTabBarDelegate(
          child: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Container(
              height: 40.0,
              color: THEME_COLOR,
              child: Center(
                child: TabBar(
                  controller: _tabController,
                  tabs: _tabs.map((String name) => Tab(text: name)).toList(),
                  isScrollable: true,
                  labelPadding: EdgeInsets.symmetric(horizontal: 50.0),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: TITLE_COLOR,
                  labelColor: TITLE_COLOR,
                  labelStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /*
   * _tabBarView: tabBarView组件
   */
  Widget _tabBarView(String name) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: TagsBar(
              name: name,
              docType: _curDocType,
              onTap: (String tag) {
                if (name == BLOG_NAME) {
                  _gotoSearchPage(tag);
                } else {
                  setState(() {
                    _curDocType = tag;
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Builder(
                builder: (BuildContext context) {
                  return RefreshIndicator(
                    onRefresh: name == BLOG_NAME ? _refreshArticleData : _refreshDocData,
                    child: CustomScrollView(
                      key: PageStorageKey<String>(name),
                      slivers: <Widget>[
                        name == BLOG_NAME ? _genArticleLists() : _genDocLists(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*
   * _genArticleLists: 生成文章列表
   */
  Widget _genArticleLists() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (index == _lists.length) {
            // 用于展示加载loading或者完成提示
            if (_isComplete) {
              return LoadingCompleteIndicator();
            } else {
              return LoadingIndicator(isLoading: _isLoading);
            }
          } else {
            return ArticleItem(
              data: _lists[index],
              onTap: _gotoUrl,
              onTapTag: _gotoSearchPage,
            );
          }
        },
        childCount: _lists.length + 1,
      ),
    );
  }

  /*
   * _genDocLists: 生成文档列表
   */
  Widget _genDocLists() {
    List<DocData> _filterDocLists = _docLists.where((doc) => _curDocType == 'all' || _curDocType == doc.docType).toList();
    return _filterDocLists.length > 0
      ? SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              if (index == _filterDocLists.length) {
                return LoadingIndicator(isLoading: _isDocLoading);
              } else {
                return DocItem(data: _filterDocLists[index], onTap: _gotoUrl);
              }
            },
            childCount: _filterDocLists.length + 1,
          ),
        )
      : SliverToBoxAdapter(
          child: EmptyTip(
            text: '当前暂时没有该分类的文档哦，快来补充吧~',
          ),
        );
  }
}