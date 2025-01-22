library hijri;

import 'package:hijriyah_indonesia/digits_converter.dart';
import 'package:hijriyah_indonesia/exstensions/word_extension.dart';
import 'hijriyah_array.dart';
import 'package:flutter/foundation.dart';

class Hijriyah {
  static const int ummulquraOffset = 16260;
  static const int khgtOffset = 60499;
  DateTime startKHGT = DateTime(2024,7,7);
  int hYear = 0;
  int hMonth = 0;
  int hDay = 0;
  int lengthOfMonth = 0;
  int wkDay = 0;
  int jPasaran = 0;
  int offset = khgtOffset;
  late String longMonthName;
  late String shortMonthName;
  late String dayWeName;
  late String nmPasaran;
  static String language = 'id';
  Map<int, int>? adjustments;
  static final Map<String, Map<String, Map<int, String>>> _local = {
    'en': {
      'long': monthNames,
      'short': monthShortNames,
      'days': wdNames,
      'short_days': shortWdNames
    },
    'id': {
      'long': idMonthNames,
      'short': idMonthShortNames,
      'days': idWdNames,
      'short_days': idShortWdNames,
      'pasaran': pasaranNames
    },
    'ar': {
      'long': arMonthNames,
      'short': arMonthShortNames,
      'days': arWkNames,
      'short_days': arShortWdNames
    },
    'tr': {
      'long': trMonthNames,
      'short': trMonthShortNames,
      'short_days': trShortWdNames
    },
  };

  // Consider switching to the factory pattern
  factory Hijriyah.setLocal(String locale) {
    language = locale;
    return Hijriyah();
  }
  Hijriyah();

  Hijriyah.fromDate(DateTime date) : offset = _determineOffset(date) {
    gregorianToHijri(date.year, date.month, date.day);
  }

  Hijriyah.now() : offset = _determineOffset(DateTime.now()) {
    _now();
  }

  static int _determineOffset(DateTime date) {
    return date.isBefore(DateTime(2024, 7, 7)) ? ummulquraOffset : khgtOffset;
  }

  void _now() {
    DateTime now = DateTime.now();
    gregorianToHijri(now.year, now.month, now.day);
  }

  Hijriyah.addMonth(int year, int month) {
    hYear = month % 12 == 0 ? year - 1 : year;
    hMonth = month % 12 == 0 ? 12 : month % 12;
    hDay = 1;
  }

  int lengthOfYear({int? year = 0}) {
    int total = 0;
    if (year == 0) year = hYear;
    for (int m = 0; m <= 11; m++) {
      total += getDaysInMonth(year!, m);
    }
    return total;
  }

  Hijriyah.addLocale(String locale, Map<String, Map<int, String>> names) {
    _local[locale] = names;
  }

  DateTime hijriToGregorian(year, month, day) { //iyear, imonth, iday
    int iy = year;
    int im = month;
    int id = day;
    int ii = iy - 1;
    int iln = (ii * 12) + 1 + (im - 1);
    //offset = (iy < 1446) ? ummulquraOffset:khgtOffset;
    //debugPrint("Offset: $offset");
    int i = (offset == ummulquraOffset) ? iln - offset : iln - (offset - 43159).floor();//iln - offset;
    //debugPrint("i: $i");
    int mcjdn = id + _getDataIndex(i - 1, offset)! - 1;
    int cjdn = mcjdn + 2400000;
    //debugPrint("cjdn: $cjdn");
    return julianToGregorian(cjdn);
  }

  DateTime julianToGregorian(julianDate) {
    //source from: http://keith-wood.name/calendars.html
    int z = (julianDate + 0.5).floor();
    int a = ((z - 1867216.25) / 36524.25).floor();
    a = z + 1 + a - (a / 4).floor();
    int b = a + 1524;
    int c = ((b - 122.1) / 365.25).floor();
    int d = (365.25 * c).floor();
    int e = ((b - d) / 30.6001).floor();
    int day = b - d - (e * 30.6001).floor();
    //var wd = _gMod(julianDate + 1, 7) + 1;
    int month = e - (e > 13.5 ? 13 : 1);
    int year = c - (month > 2.5 ? 4716 : 4715);
    if (year <= 0) {
      year--;
    } // No year zero
    //debugPrint("year: $year, month: $month, day: $day");
    return DateTime(year, (month), day);
  }

  String gregorianToHijri(int year, int month, int day) {
    int cjdn = _calculateChronologicalJulianDay(year, month, day);
    int mcjdn = cjdn - 2400000;
    //debugPrint("offset: $offset");
    //debugPrint("mcjdn: $mcjdn");
    int i = _getIndexForOffset(mcjdn, offset);
    
    int iln = (offset == ummulquraOffset) ? i + offset : i + (offset - 43159).floor();
    //debugPrint("i: $i");
    //debugPrint("iln: $iln");
    hYear = ((iln - 1) ~/ 12) + 1;
    hMonth = iln - 12 * ((iln - 1) ~/ 12);

    int? dataIndex1 = _getDataIndex(i - 1, offset);
    int? dataIndex2 = _getDataIndex(i, offset);

    if (dataIndex1 == null || dataIndex2 == null) {
      throw ArgumentError("Invalid date index");
    }

    hDay = mcjdn - dataIndex1 + 1;
    lengthOfMonth = dataIndex2 - dataIndex1;
    wkDay = _gMod(cjdn + 1, 7) == 0 ? 7 : _gMod(cjdn + 1, 7);
    jPasaran = _getPasaran(year, month, day);
    return hDate(hYear, hMonth, hDay);
  }

  int _calculateChronologicalJulianDay(int year, int month, int day) {
    if (month < 3) {
      year -= 1;
      month += 12;
    }
    int a = (year ~/ 100);
    int jgc = a - (a ~/ 4) - 2;

    return (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() + day - jgc - 1524;
  }

  int _getIndexForOffset(int mcjdn, int offset) {
    List<int> dateArray = (offset == ummulquraOffset) ? ummAlquraDateArray : khgtDateArray;
    return dateArray.indexWhere((value) => value > mcjdn);
  }

  int? _getDataIndex(int index, int offset) {
    List<int> dateArray = (offset == ummulquraOffset) ? ummAlquraDateArray : khgtDateArray;
    // Apply adjustments if available
    if(offset == ummulquraOffset){
      if (adjustments != null && adjustments!.containsKey(index + offset)) {
        return adjustments![index + offset];
      }
      if (index < 0 || index >= dateArray.length) {
        debugPrint("Invalid date index: $index with offset: $offset");
        return null;
      }
    }
    return dateArray[index];
  }

  int _gMod(int n, int m) => ((n % m) + m) % m;

  bool validateHijri(int year, int month, int day) {
    return year >= 1 && (month >= 1 && month <= 12) && (day >= 1 && day <= 30);
  }

  int getDaysInMonth(int year, int month) {
    int i = _getNewMoonMJDNIndex(year, month);
    return _getDataIndex(i, offset)! - _getDataIndex(i - 1, offset)!;
  }

  int _getNewMoonMJDNIndex(int hy, int hm) {
    int cYears = hy - 1, totalMonths = (cYears * 12) + 1 + (hm - 1);
    int mOffset = (hy < 1446)? ummulquraOffset : khgtOffset - 43159;
    return totalMonths - mOffset;
  }

  bool isValid() {
    return validateHijri(hYear, hMonth, hDay) && hDay <= getDaysInMonth(hYear, hMonth);
  }

  List<int> toList() => [hYear, hMonth, hDay];

  String hDate(int year, int month, int day) {
    hYear = year;
    hMonth = month;
    longMonthName = _local[language]!['long']![month]!;
    dayWeName = _local[language]!['days']![wkDay]!;
    shortMonthName = _local[language]!['short']![month]!;
    hDay = day;
    if(language == "id") nmPasaran = _local[language]!['pasaran']![jPasaran]!;
    return format(hYear, hMonth, hDay, "dd/mm/yyyy");
  }

  String toFormat(String format) {
    return this.format(hYear, hMonth, hDay, format).toLowerCase().toTitleCase();
  }

  String format(year, month, day, format) {
    String newFormat = format;

    String dayString;
    String monthString;
    String yearString;

    if (language == 'ar') {
      dayString = DigitsConverter.convertWesternNumberToEastern(day);
      monthString = DigitsConverter.convertWesternNumberToEastern(month);
      yearString = DigitsConverter.convertWesternNumberToEastern(year);
    } else {
      dayString = day.toString();
      monthString = month.toString();
      yearString = year.toString();
    }

    if (newFormat.contains("dd")) {
      newFormat = newFormat.replaceFirst("dd", dayString);
    } else {
      if (newFormat.contains("d")) {
        newFormat = newFormat.replaceFirst("d", day.toString());
      }
    }

    //=========== Day Name =============//
    // Friday
    if (newFormat.contains("EEEE")) {
      newFormat = newFormat.replaceFirst(
          "EEEE", "${_local[language]!['days']![wkDay]}");

      // Fri
    } else if (newFormat.contains("EE")) {
      newFormat = newFormat.replaceFirst(
          "EE", "${_local[language]!['short_days']![wkDay]}");
    } 
    
    if(newFormat.contains("PP")){
      newFormat = newFormat.replaceFirst("PP", "${_local[language]!['pasaran']![jPasaran]}");
    }

    //============== Month ========================//
    // 1
    if (newFormat.contains("mm")) {
      newFormat = newFormat.replaceFirst("mm", monthString);
    } else {
      newFormat = newFormat.replaceFirst("m", monthString);
    }

    // Muharram
    if (newFormat.contains("MMMM")) {
      newFormat =
          newFormat.replaceFirst("MMMM", _local[language]!['long']![month]!);
    } else {
      if (newFormat.contains("MM")) {
        newFormat =
            newFormat.replaceFirst("MM", _local[language]!['short']![month]!);
      }
    }

    //================= Year ========================//
    if (newFormat.contains("yyyy")) {
      newFormat = newFormat.replaceFirst("yyyy", yearString);
    } else {
      newFormat = newFormat.replaceFirst("yy", yearString.substring(2, 4));
    }
    return newFormat;
  }


  int weekDay() {
    DateTime wkDay = hijriToGregorian(hYear, hMonth, hDay);
    return wkDay.weekday;
  }

  @override
  String toString() {
    return "$hDay $jPasaran -$hMonth-$hYear";
  }

  String fullDate() {
    if(language == "id") {
      return format(hYear, hMonth, hDay, "EEEE PP, dd MMMM yyyy").toTitleCase();
    } else {
    return format(hYear, hMonth, hDay, "EEEE , MMMM dd, yyyy").toTitleCase();
    }
  }

  bool isBefore(int year, int month, int day) {
    DateTime currentGregorian = hijriToGregorian(hYear, hMonth, hDay);
  DateTime targetGregorian = hijriToGregorian(year, month, day);
  return currentGregorian.isBefore(targetGregorian);
  }

  bool isAfter(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch >
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  bool isAtSameMomentAs(int year, int month, int day) {
    return hijriToGregorian(hYear, hMonth, hDay).millisecondsSinceEpoch ==
        hijriToGregorian(year, month, day).millisecondsSinceEpoch;
  }

  void setAdjustments(Map<int, int> adj) {
    adjustments = adj;
  }

  int _getPasaran(int year, int month, int day){
    //offset pasaran dari tanggal 7,7,2024 adalah kliwon 
    //bandingkan tanggal hari ini dengan base startKHGT
    int diff = DateTime(year,month,day).difference(startKHGT).inDays;
    int pasaran = _gMod(diff, 5) == 0 ? 5 : _gMod(diff, 5);
    
    return pasaran;
  }
}