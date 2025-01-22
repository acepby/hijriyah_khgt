import 'package:flutter/foundation.dart';
import 'package:hijriyah_khgt/hijriyah_khgt.dart';
//import 'package:intl/date_symbol_data_local.dart';

void main() {
  // Test 1: Convert a date to Hijri and format it
  try {
    debugPrint(Hijriyah.fromDate(DateTime(2024, 07, 6)).toFormat("EE PP, dd MMMM yyyy"));
  } catch (e) {
    debugPrint("Test 1 failed: $e");
  }

  // Test 2: Convert a date and get the full date
  try {
    debugPrint(Hijriyah.fromDate(DateTime(2025, 03, 1)).fullDate());
  } catch (e) {
    debugPrint("Test 2 failed: $e");
  }

  // Test 3: Check if a date is before another date
  try {
    Hijriyah date1 = Hijriyah.fromDate(DateTime(2024, 07, 20));
    //Hijriyah date2 = Hijriyah.fromDate(DateTime(2025, 06, 07));
    //debugPrint(date1.isBefore(date2.hYear, date2.hMonth, date2.hDay).toString());
    debugPrint(date1.isBefore(1446,09,01).toString());
    
  } catch (e) {
    debugPrint("Test 3 failed: $e");
  }

  // Test 4: Check if a date is after another date
  try {
    Hijriyah date1 = Hijriyah.fromDate(DateTime(2024, 08, 20));
    Hijriyah date2 = Hijriyah.fromDate(DateTime(2024, 07, 08));
    debugPrint(date1.isAfter(date2.hYear, date2.hMonth, date2.hDay).toString());
  } catch (e) {
    debugPrint("Test 4 failed: $e");
  }

  // Test 5: Check if a date is at the same moment as another date
  try {
    Hijriyah date1 = Hijriyah.fromDate(DateTime(2025, 01, 20));
    debugPrint(date1.isAtSameMomentAs(date1.hYear, date1.hMonth, date1.hDay).toString());
  } catch (e) {
    debugPrint("Test 5 failed: $e");
  }

  // Test 6: Get the length of a month
  try {
    debugPrint(Hijriyah.fromDate(DateTime(2025, 01, 20)).getDaysInMonth(1446, 5).toString());
  } catch (e) {
    debugPrint("Test 6 failed: $e");
  }

  // Test 7: Validate a Hijri date
  try {
    debugPrint(Hijriyah.fromDate(DateTime(2025, 01, 20)).validateHijri(1446, 5, 15).toString());
  } catch (e) {
    debugPrint("Test 7 failed: $e");
  }
  // Test 8: Check if a date is before another date
  try {
    //Hijriyah date1 = Hijriyah.fromDate(DateTime(2024, 07, 20));
    //Hijriyah date2 = Hijriyah.fromDate(DateTime(2025, 06, 07));
    //debugPrint(date1.isBefore(date2.hYear, date2.hMonth, date2.hDay).toString());
    String masehi = Hijriyah.fromDate(DateTime(2025,03,01)).fullDate();
    debugPrint(masehi);
  } catch (e) {
    debugPrint("Test 8 failed: $e");
  }
}
