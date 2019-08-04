import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_note/entity/note.dart';
import 'package:flutter_note/ui/read.dart';
import 'package:flutter_note/utils/event_bus.dart';
import 'package:flutter_note/utils/note_db_helper.dart';
import 'package:flutter_note/utils/time_utils.dart';

class ListPage extends StatefulWidget {
  const ListPage({
    Key key,
    @required this.noteDbHelpter,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;

  @override
  State<StatefulWidget> createState() {
    return ListPageState();
  }
}

class ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 5, keepScrollOffset: true);
  int _size = 0;
  List<Note> _noteList = List();
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    // 注册和监听t发送来的UserEven类型事件、数据
    subscription = eventBus.on<NoteEvent>().listen((NoteEvent event) {
      _onRefresh();
    });
    _scrollController.addListener(() {
      ///滚动监听
    });
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
          child: CustomScrollView(
            shrinkWrap: false,
            primary: false,
            // 回弹效果
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 10,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return InkWell(
                    child:
                        index % 2 == 0 ? getItem(index) : getImageItem(index),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return ReadPage(
                          id: _noteList.elementAt(index).id,
                          noteDbHelpter: widget.noteDbHelpter,
                        );
                      }));
                    },
                    onLongPress: () {
                      _showBottomSheet(index, context);
                    },
                  );
                }, childCount: _size),
              ),
            ],
          ),
          onRefresh: _onRefresh),
    );
  }

  _showBottomSheet(int index, BuildContext c) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.content_copy),
                title: Text("复制"),
                onTap: () async {
                  Clipboard.setData(
                      ClipboardData(text: _noteList.elementAt(index).content));
                  Scaffold.of(c).showSnackBar(SnackBar(
                    content: Text("已经复制到剪贴板"),
                    backgroundColor: Colors.black87,
                    duration: Duration(
                      seconds: 2,
                    ),
                  ));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_sweep),
                title: Text("删除"),
                onTap: () async {
                  widget.noteDbHelpter
                      .deleteById(_noteList.elementAt(index).id);
                  setState(() {
                    _noteList.removeAt(index);
                    _size = _noteList.length;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  // 刷新
  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('refresh');
      widget.noteDbHelpter.getDatabase().then((database) {
        database
            .query('notes', orderBy: 'time DESC')
            .then((List<Map<String, dynamic>> records) {
          _size = records.length;
          _noteList.clear();
          for (int i = 0; i < records.length; i++) {
            _noteList.add(Note.fromMap(records.elementAt(i)));
          }
          setState(() {
            print(_noteList.length);
          });
        });
      });
    });
  }

  Widget getItem(int index) {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time).day}',
                        style: TextStyle(
                            color: Color.fromRGBO(52, 52, 54, 1),
                            fontSize: 50,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time).weekday)}',
                            style: TextStyle(
                                color: Color.fromRGBO(149, 149, 148, 1),
                                fontSize: 18),
                          ),
                          Text(
                            TimeUtils.getDate(
                                DateTime.fromMillisecondsSinceEpoch(
                                    _noteList.elementAt(index).time)),
                            style: TextStyle(
                                color: Color.fromRGBO(149, 149, 148, 1),
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 50,
                      color: Color.fromRGBO(252, 205, 24, 1),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Text(
                _noteList.elementAt(index).content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Color.fromRGBO(103, 103, 103, 1),
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageItem(int index) {
    return Container(
      child: Card(
        margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                  child: Row(
                    children: <Widget>[
                      Text(
                        _noteList.length == 0
                            ? ''
                            : '${DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time).day}',
                        style: TextStyle(
                            color: Color.fromRGBO(52, 52, 54, 1),
                            fontSize: 50,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _noteList.length == 0
                                ? ''
                                : '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(_noteList.elementAt(index).time).weekday)}',
                            style: TextStyle(
                                color: Color.fromRGBO(149, 149, 148, 1),
                                fontSize: 18),
                          ),
                          Text(
                            _noteList.length == 0
                                ? ''
                                : TimeUtils.getDate(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _noteList.elementAt(index).time)),
                            style: TextStyle(
                                color: Color.fromRGBO(149, 149, 148, 1),
                                fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.fromLTRB(0, 5, 20, 5),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 50,
                      color: Color.fromRGBO(252, 205, 24, 1),
                    ),
                  ),
                ),
              ],
            ),
            Container(
                margin: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.network(
                        'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564678338847&di=ab19cbea9b5d88a9969ce0825ac5c84d&imgtype=0&src=http%3A%2F%2Fattachments.gfan.net.cn%2Fforum%2F201501%2F13%2F143316yttiiyiuvufcoyjh.jpg',
                        height: 108,
                        width: 108,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Text(
                        _noteList.elementAt(index).content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color.fromRGBO(103, 103, 103, 1),
                          fontSize: 18,
                        ),
                      ),
                    )),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  bool get wantKeepAlive => true;
}
