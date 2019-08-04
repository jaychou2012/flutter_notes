import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_note/utils/note_db_helper.dart';

import 'about.dart';

class CenterPage extends StatefulWidget {
  const CenterPage({
    Key key,
    @required this.noteDbHelpter,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;

  @override
  State<StatefulWidget> createState() {
    return CenterPageState();
  }
}

class CenterPageState extends State<CenterPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(244, 244, 244, 1),
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Container(
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                padding: EdgeInsets.all(3),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  backgroundImage: NetworkImage(
                      "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1564763468169&di=02627b2a0ff227690f3a89c5214bfd86&imgtype=0&src=h"
                      "ttp%3A%2F%2Fpic49.nipic.com%2Ffile%2F20140922%2F2531170_191654419000_2.jpg"),
                  radius: 30.0,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "最美的日记",
                    style: TextStyle(color: Colors.black, fontSize: 26),
                  ),
                  Text(
                    "编辑资料",
                    style: TextStyle(
                        color: Color.fromRGBO(162, 162, 162, 1), fontSize: 18),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: Container(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Row(
                    children: <Widget>[
                      _buildItem(0),
                      _buildItem(1),
                    ],
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      _buildItem(2),
                      _buildItem(3),
                    ],
                  ),
                  flex: 1,
                ),
                Flexible(
                  child: Row(
                    children: <Widget>[
                      _buildItem(4),
                      _buildItem(5),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
          )),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  _buildItem(int index) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: GestureDetector(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _icons.elementAt(index),
                  Expanded(child: Text("")),
                  _title.elementAt(index),
                  _des.elementAt(index),
                ],
              ),
            ),
          ),
          onTap:(){
            _click(index);
          },
        ),
      ),
      flex: 1,
    );
  }

  void _click(int index) {
    switch (index) {
      case 0:
        break;
      case 4:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return AboutPage();
        }));
        break;
    }
  }

  List<Icon> _icons = [
    Icon(
      Icons.favorite,
      size: 38,
      color: Colors.yellow,
    ),
    Icon(
      Icons.lock,
      size: 38,
      color: Colors.blue,
    ),
    Icon(
      Icons.feedback,
      size: 38,
      color: Colors.blueAccent,
    ),
    Icon(
      Icons.share,
      size: 38,
      color: Colors.deepPurpleAccent,
    ),
    Icon(
      Icons.error_outline,
      size: 38,
      color: Colors.orange,
    ),
    Icon(
      Icons.settings,
      size: 38,
      color: Colors.red,
    )
  ];

  List<Text> _title = [
    Text(
      "我的收藏",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "密码锁",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "吐槽反馈",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "分享",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "关于日记",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
    Text(
      "系统设置",
      style: TextStyle(color: Colors.black, fontSize: 20),
    ),
  ];

  List<Text> _des = [
    Text(
      "收藏的重要日记",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "设置密码锁",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "吐槽反馈你的想法",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "分享应用给他人",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "版本信息",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
    Text(
      "系统相关设置",
      style: TextStyle(color: Color.fromRGBO(162, 162, 162, 1), fontSize: 16),
    ),
  ];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
