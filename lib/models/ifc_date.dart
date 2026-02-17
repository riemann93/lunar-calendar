/// Represents a date in the International Fixed Calendar (IFC).
///
/// The IFC has 13 months of exactly 28 days each (364 days), plus:
/// - Year Day: after December 28, equivalent to Gregorian Dec 31
/// - Leap Day: in leap years, after June 28 and before Sol 1
///
/// Both Year Day and Leap Day exist outside any month or week.
/// January 1 is the same in both calendars.
class IfcDate {
  final int year;

  /// Month index 0-12 (0=January, 6=Sol, 12=December).
  /// -1 for Year Day and Leap Day (outside any month).
  final int month;

  /// Day within the month, 1-28. 0 for Year Day and Leap Day.
  final int day;

  final bool isYearDay;
  final bool isLeapDay;

  const IfcDate({
    required this.year,
    required this.month,
    required this.day,
    this.isYearDay = false,
    this.isLeapDay = false,
  });

  /// Year Day: the 365th day (or 366th in leap years), Gregorian Dec 31.
  const IfcDate.yearDay(this.year)
    : month = -1,
      day = 0,
      isYearDay = true,
      isLeapDay = false;

  /// Leap Day: only in leap years, between IFC June 28 and Sol 1.
  const IfcDate.leapDay(this.year)
    : month = -1,
      day = 0,
      isYearDay = false,
      isLeapDay = true;

  /// Whether this is a regular date (not Year Day or Leap Day).
  bool get isRegularDay => !isYearDay && !isLeapDay;

  /// The month name, or a special name for Year Day / Leap Day.
  String get monthName {
    if (isYearDay) return 'Year Day';
    if (isLeapDay) return 'Leap Day';
    const names = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'Sol',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return names[month];
  }

  /// Convert a Gregorian [DateTime] to an [IfcDate].
  ///
  /// The mapping uses day-of-year as the bridge:
  /// - Non-leap year: days 1-364 → 13 months, day 365 → Year Day
  /// - Leap year: days 1-168 → Jan-Jun, day 169 → Leap Day,
  ///   days 170-365 → Sol-Dec, day 366 → Year Day
  static IfcDate fromDateTime(DateTime date) {
    // Use UTC to avoid DST issues with Duration.inDays
    final utcDate = DateTime.utc(date.year, date.month, date.day);
    final utcJan1 = DateTime.utc(date.year, 1, 1);
    final dayOfYear = utcDate.difference(utcJan1).inDays + 1;
    final leap = _isLeapYear(date.year);
    final daysInYear = leap ? 366 : 365;

    // Year Day: last day of the year
    if (dayOfYear == daysInYear) {
      return IfcDate.yearDay(date.year);
    }

    if (leap) {
      // Leap Day: day 169 (Gregorian June 17 in a leap year)
      if (dayOfYear == 169) {
        return IfcDate.leapDay(date.year);
      }

      // Before Leap Day: days 1-168 map normally
      if (dayOfYear < 169) {
        final monthIndex = (dayOfYear - 1) ~/ 28;
        final day = (dayOfYear - 1) % 28 + 1;
        return IfcDate(year: date.year, month: monthIndex, day: day);
      }

      // After Leap Day: subtract 1 to skip the Leap Day, then map
      // Day 170 → adjusted day 169 → Sol 1 (month 6, day 1)
      final adjusted = dayOfYear - 1;
      final monthIndex = (adjusted - 1) ~/ 28;
      final day = (adjusted - 1) % 28 + 1;
      return IfcDate(year: date.year, month: monthIndex, day: day);
    }

    // Non-leap year: days 1-364 map directly
    final monthIndex = (dayOfYear - 1) ~/ 28;
    final day = (dayOfYear - 1) % 28 + 1;
    return IfcDate(year: date.year, month: monthIndex, day: day);
  }

  /// Convert this [IfcDate] back to a Gregorian [DateTime].
  DateTime toDateTime() {
    final leap = _isLeapYear(year);

    if (isYearDay) {
      // Last day of the Gregorian year
      return DateTime(year, 12, 31);
    }

    if (isLeapDay) {
      // Leap Day = day-of-year 169 in a leap year (Gregorian June 17)
      return DateTime(year, 6, 17);
    }

    // Regular day: compute day-of-year from month/day
    int dayOfYear = month * 28 + day;

    // In leap years, dates from Sol (month 6) onward need +1 for Leap Day
    if (leap && month >= 6) {
      dayOfYear += 1;
    }

    // Use DateTime constructor to avoid DST issues with Duration addition
    return DateTime(year, 1, dayOfYear);
  }

  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }

  @override
  bool operator ==(Object other) =>
      other is IfcDate &&
      year == other.year &&
      month == other.month &&
      day == other.day &&
      isYearDay == other.isYearDay &&
      isLeapDay == other.isLeapDay;

  @override
  int get hashCode => Object.hash(year, month, day, isYearDay, isLeapDay);

  @override
  String toString() {
    if (isYearDay) return 'IfcDate.yearDay($year)';
    if (isLeapDay) return 'IfcDate.leapDay($year)';
    return 'IfcDate($year, month=$month, day=$day)';
  }
}

// --- Gregorian calendar helpers ---

/// Number of days in a Gregorian month (1-indexed month: 1=Jan, 12=Dec).
int gregorianDaysInMonth(int year, int month) {
  return DateTime(year, month + 1, 0).day;
}

/// The weekday a Gregorian month starts on (0=Sun, 6=Sat).
/// Dart's DateTime.weekday returns 1=Mon, 7=Sun, so we convert.
int gregorianMonthStartWeekday(int year, int month) {
  final weekday = DateTime(year, month, 1).weekday; // 1=Mon, 7=Sun
  return weekday % 7; // 0=Sun, 1=Mon, ..., 6=Sat
}
