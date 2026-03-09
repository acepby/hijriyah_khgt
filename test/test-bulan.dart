import 'package:flutter/foundation.dart';
import 'package:hijriyah_khgt/hijriyah_khgt.dart';
void main() {
  // Test 2026-03-06
  DateTime testDate = DateTime(2026, 3, 6);
  Hijriyah hijri = Hijriyah.fromDate(testDate);
  
  debugPrint('=== Testing 2026-03-06 ===');
  debugPrint('Gregorian: 2026-03-06');
  debugPrint('Hijri year: ${hijri.hYear}');
  debugPrint('Hijri month: ${hijri.hMonth}');
  debugPrint('Hijri day: ${hijri.hDay}');
  debugPrint('Month name: ${hijri.longMonthName}');
  debugPrint('Formatted: ${hijri.fullDate()}');
  
  // Verify with known KHGT data
  // 1 Ramadan 1447 should be around Feb 19, 2026
  // So March 6, 2026 should be around 16-17 Ramadan
}