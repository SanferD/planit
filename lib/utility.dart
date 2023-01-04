import 'package:intl/intl.dart';

class Utility {
  static String yMMMEd(DateTime dateTime) {
    return DateFormat.yMMMEd().format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat("h:mm a").format(dateTime);
  }

  static int durationInMinutes(DateTime startDateTime, DateTime endDateTime) {
    return endDateTime.difference(startDateTime).inMinutes;
  }

  static String dayOnly(DateTime dateTime) {
    return DateFormat.EEEE().format(dateTime);
  }

  static String MMMEd(DateTime dateTime) {
    return DateFormat.MMMEd().format(dateTime);
  }
}
