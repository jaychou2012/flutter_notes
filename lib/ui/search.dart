import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_note/entity/note.dart';
import 'package:flutter_note/utils/note_db_helper.dart';
import 'package:flutter_note/utils/time_utils.dart';
import 'package:flutter_note/utils/tost_utils.dart';

import 'read.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key key,
    @required this.noteDbHelpter,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;

  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  int _size = 0;
  List<Note> _noteList = List();
  String keyString = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        elevation: 1,
        automaticallyImplyLeading: true,
        title: Container(
          padding: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 10),
          child: TextField(
            maxLines: 1,
            autofocus: false,
            onChanged: (text) {
              setState(() {
                keyString = text;
              });
            },
            // TextFiled装饰
            decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(10),
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    gapPadding: 0,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                hintText: '请输入搜索关键字...',
                suffixIcon: Icon(Icons.clear)),
          ),
        ),
        centerTitle: true,
        // 右侧收起的更多按钮菜单
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(left: 0.0, right: 10.0),
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            width: 50,
            child: FlatButton(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () {
                  _search();
                },
                child: Text("搜索"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                )),
          )
        ],
      ),
      body: Container(
        child: CustomScrollView(
          shrinkWrap: false,
          primary: false,
          // 回弹效果
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 10,
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return InkWell(
                  child: index % 2 == 0 ? getItem(index) : getImageItem(index),
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
      ),
    );
  }

  void _search() async {
    await Future.delayed(Duration(seconds: 0), () {
      widget.noteDbHelpter.getNoteByContent(keyString).then((List<Note> notes) {
        if (notes != null) {
          setState(() {
            _size = notes.length;
            _noteList = notes;
          });
        } else {
          setState(() {
            _size = 0;
          });
        }
      });
    });
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
}
