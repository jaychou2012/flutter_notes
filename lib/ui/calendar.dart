import 'package:flutter/widgets.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/widget/calendar_view.dart';
import 'package:flutter_note/utils/note_db_helper.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({
    Key key,
    @required this.noteDbHelpter,
  }) : super(key: key);

  final NoteDbHelper noteDbHelpter;

  @override
  State<StatefulWidget> createState() {
    return CalendarPageState();
  }
}

class CalendarPageState extends State<CalendarPage> with AutomaticKeepAliveClientMixin{
  CalendarController calendarController;

  @override
  void initState() {
    super.initState();
    calendarController = CalendarController();
    calendarController.addMonthChangeListener(
      (year, month) {
        setState(() {});
      },
    );
    calendarController.addOnCalendarSelectListener((dateModel) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CalendarViewWidget(
      calendarController: calendarController,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
