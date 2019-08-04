import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_note/entity/note.dart';
import 'package:flutter_note/utils/event_bus.dart';
import 'package:flutter_note/utils/note_db_helper.dart';
import 'package:flutter_note/utils/time_utils.dart';
import 'package:flutter_note/utils/tost_utils.dart';

import 'write.dart';

class ReadPage extends StatefulWidget {
  const ReadPage({
    Key key,
    @required this.noteDbHelpter,
    @required this.id,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;
  final int id;

  @override
  State<StatefulWidget> createState() {
    return ReadPageState();
  }
}

class ReadPageState extends State<ReadPage> with WidgetsBindingObserver {
  String note = "";
  Note noteEntity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.noteDbHelpter.getNoteById(widget.id).then((notes) {
      setState(() {
        note = notes.content;
        noteEntity = notes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(244, 244, 244, 1),
        title: Text('日记详情'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WritePage(
                    noteDbHelpter: widget.noteDbHelpter,
                    id: widget.id,
                  );
                }));
              })
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
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(50, 5, 10, 5),
                      child: Icon(
                        Icons.wb_sunny,
                        size: 50,
                        color: Color.fromRGBO(252, 205, 24, 1),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '星期${TimeUtils.getWeekday(DateTime.fromMillisecondsSinceEpoch(noteEntity.time).weekday)}',
                          style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18),
                        ),
                        Text(
                          TimeUtils.getDateTime(
                              DateTime.fromMillisecondsSinceEpoch(
                                  noteEntity.time)),
                          style: TextStyle(
                              color: Color.fromRGBO(149, 149, 148, 1),
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Text(
                  note,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //当移除渲染树的时候调用
  @override
  void deactivate() {
    super.deactivate();
    var bool = ModalRoute.of(context).isCurrent;
    if (bool) {
      widget.noteDbHelpter.getNoteById(widget.id).then((notes) {
        setState(() {
          note = notes.content;
        });
      });
      // 发送事件、数据
      eventBus.fire(NoteEvent(widget.id));
    }
  }

  //APP生命周期监听
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //恢复可见
      widget.noteDbHelpter.getNoteById(widget.id).then((notes) {
        setState(() {
          note = notes.content;
        });
      });
    } else if (state == AppLifecycleState.paused) {
      //处在并不活动状态，无法处理用户响应
      //例如来电，画中画，弹框
    } else if (state == AppLifecycleState.inactive) {
      //不可见，后台运行，无法处理用户响应
    } else if (state == AppLifecycleState.suspending) {
      //应用被立刻暂停挂起，ios上不会回调
    }
    super.didChangeAppLifecycleState(state);
  }

  //组件即将销毁时调用
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }
}
