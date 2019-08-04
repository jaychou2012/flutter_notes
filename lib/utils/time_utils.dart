class TimeUtils {
  static String getWeekday(int day) {
    switch (day) {
      case 1:
        return "一";
      case 2:
        return "二";
      case 3:
        return "三";
      case 4:
        return "四";
      case 5:
        return "五";
      case 6:
        return "六";
      case 7:
        return "日";
    }
  }

  static String getDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  static String getDate(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月';
  }
}
