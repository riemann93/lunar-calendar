import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/models/ifc_date.dart';

void main() {
  group('IfcDate.fromDateTime', () {
    test('January 1 is the same in both calendars', () {
      final ifc = IfcDate.fromDateTime(DateTime(2026, 1, 1));
      expect(ifc.month, 0);
      expect(ifc.day, 1);
      expect(ifc.isRegularDay, true);
    });

    test('January 28 Gregorian = IFC January 28', () {
      final ifc = IfcDate.fromDateTime(DateTime(2026, 1, 28));
      expect(ifc.month, 0);
      expect(ifc.day, 28);
    });

    test('January 29 Gregorian = IFC February 1', () {
      final ifc = IfcDate.fromDateTime(DateTime(2026, 1, 29));
      expect(ifc.month, 1);
      expect(ifc.day, 1);
    });

    test('February 5 Gregorian = IFC February 8 (user example)', () {
      // Day of year: 31 (Jan) + 5 = 36
      // (36-1) ~/ 28 = 1 (February), (36-1) % 28 + 1 = 8
      final ifc = IfcDate.fromDateTime(DateTime(2026, 2, 5));
      expect(ifc.month, 1);
      expect(ifc.day, 8);
      expect(ifc.monthName, 'February');
    });

    test('February 25 Gregorian = IFC February 28 (non-leap)', () {
      // Day of year: 31 + 25 = 56. (56-1)~/28 = 1, (56-1)%28+1 = 28
      final ifc = IfcDate.fromDateTime(DateTime(2025, 2, 25));
      expect(ifc.month, 1);
      expect(ifc.day, 28);
    });

    test('February 26 Gregorian = IFC March 1 (non-leap)', () {
      // Day of year: 31 + 26 = 57. (57-1)~/28 = 2, (57-1)%28+1 = 1
      final ifc = IfcDate.fromDateTime(DateTime(2025, 2, 26));
      expect(ifc.month, 2);
      expect(ifc.day, 1);
    });

    test('Sol month starts at Gregorian June 18 (non-leap)', () {
      // Day of year for Jun 18: 31+28+31+30+31+18 = 169
      // (169-1)~/28 = 6, (169-1)%28+1 = 1
      final ifc = IfcDate.fromDateTime(DateTime(2025, 6, 18));
      expect(ifc.month, 6);
      expect(ifc.day, 1);
      expect(ifc.monthName, 'Sol');
    });

    test('December 30 Gregorian = IFC December 28 (non-leap)', () {
      // Day of year for Dec 30: 364
      // (364-1)~/28 = 12, (364-1)%28+1 = 28
      final ifc = IfcDate.fromDateTime(DateTime(2025, 12, 30));
      expect(ifc.month, 12);
      expect(ifc.day, 28);
    });

    test('December 31 Gregorian = Year Day (non-leap)', () {
      final ifc = IfcDate.fromDateTime(DateTime(2025, 12, 31));
      expect(ifc.isYearDay, true);
      expect(ifc.isRegularDay, false);
      expect(ifc.monthName, 'Year Day');
    });

    group('leap year', () {
      // 2024 is a leap year

      test('days before Leap Day are unaffected', () {
        // May 20 Gregorian in leap year: day 141 (31+29+31+30+31+20 = not right)
        // Jan=31, Feb=29, Mar=31, Apr=30, May=20 => 31+29+31+30+20 = 141
        // (141-1)~/28 = 5, (141-1)%28+1 = 1 => IFC June 1
        final ifc = IfcDate.fromDateTime(DateTime(2024, 5, 21));
        // 31+29+31+30+21 = 142. (142-1)~/28 = 5, (142-1)%28+1 = 2
        expect(ifc.month, 5);
        expect(ifc.day, 2);
      });

      test('June 17 in leap year = Leap Day', () {
        // Day of year: 31+29+31+30+31+17 = 169
        final ifc = IfcDate.fromDateTime(DateTime(2024, 6, 17));
        expect(ifc.isLeapDay, true);
        expect(ifc.isRegularDay, false);
        expect(ifc.monthName, 'Leap Day');
      });

      test('June 18 in leap year = IFC Sol 1', () {
        // Day of year: 31+29+31+30+31+18 = 170
        // adjusted = 170 - 1 = 169. (169-1)~/28 = 6, (169-1)%28+1 = 1
        final ifc = IfcDate.fromDateTime(DateTime(2024, 6, 18));
        expect(ifc.month, 6);
        expect(ifc.day, 1);
        expect(ifc.monthName, 'Sol');
      });

      test('December 31 in leap year = Year Day', () {
        // Day of year 366
        final ifc = IfcDate.fromDateTime(DateTime(2024, 12, 31));
        expect(ifc.isYearDay, true);
      });

      test('December 30 in leap year = IFC December 28', () {
        // Day of year for Dec 30, 2024: 365
        // Not Year Day (year day is 366 in leap year)
        // adjusted = 365 - 1 = 364. (364-1)~/28 = 12, (364-1)%28+1 = 28
        final ifc = IfcDate.fromDateTime(DateTime(2024, 12, 30));
        expect(ifc.month, 12);
        expect(ifc.day, 28);
      });

      test('IFC June 28 in leap year = Gregorian June 16', () {
        // Day 168 in leap year: 31+29+31+30+31+16 = 168
        // (168-1)~/28 = 5, (168-1)%28+1 = 28 => June 28
        final ifc = IfcDate.fromDateTime(DateTime(2024, 6, 16));
        expect(ifc.month, 5);
        expect(ifc.day, 28);
      });
    });
  });

  group('IfcDate.toDateTime', () {
    test('IFC January 1 = Gregorian January 1', () {
      final dt = const IfcDate(year: 2026, month: 0, day: 1).toDateTime();
      expect(dt, DateTime(2026, 1, 1));
    });

    test('IFC February 8 = Gregorian February 5 (user example)', () {
      final dt = const IfcDate(year: 2026, month: 1, day: 8).toDateTime();
      expect(dt, DateTime(2026, 2, 5));
    });

    test('Year Day converts to December 31', () {
      final dt = const IfcDate.yearDay(2025).toDateTime();
      expect(dt, DateTime(2025, 12, 31));
    });

    test('Leap Day converts to June 17 in leap year', () {
      final dt = const IfcDate.leapDay(2024).toDateTime();
      expect(dt, DateTime(2024, 6, 17));
    });

    test('IFC Sol 1 = Gregorian June 18 (non-leap)', () {
      final dt = const IfcDate(year: 2025, month: 6, day: 1).toDateTime();
      expect(dt, DateTime(2025, 6, 18));
    });

    test('IFC Sol 1 in leap year = Gregorian June 18', () {
      // In leap year, Sol 1 should be June 18 (day after Leap Day June 17)
      final dt = const IfcDate(year: 2024, month: 6, day: 1).toDateTime();
      expect(dt, DateTime(2024, 6, 18));
    });

    test('IFC December 28 = Gregorian December 30 (non-leap)', () {
      final dt = const IfcDate(year: 2025, month: 12, day: 28).toDateTime();
      expect(dt, DateTime(2025, 12, 30));
    });
  });

  group('roundtrip conversions', () {
    test('every day in 2025 (non-leap) roundtrips correctly', () {
      for (int d = 1; d <= 365; d++) {
        // Use DateTime constructor with day overflow to avoid DST issues
        final gregorian = DateTime(2025, 1, d);
        final ifc = IfcDate.fromDateTime(gregorian);
        final back = ifc.toDateTime();
        expect(
          back.year,
          gregorian.year,
          reason: 'Day $d year mismatch: $gregorian -> $ifc -> $back',
        );
        expect(
          back.month,
          gregorian.month,
          reason: 'Day $d month mismatch: $gregorian -> $ifc -> $back',
        );
        expect(
          back.day,
          gregorian.day,
          reason: 'Day $d day mismatch: $gregorian -> $ifc -> $back',
        );
      }
    });

    test('every day in 2024 (leap year) roundtrips correctly', () {
      for (int d = 1; d <= 366; d++) {
        final gregorian = DateTime(2024, 1, d);
        final ifc = IfcDate.fromDateTime(gregorian);
        final back = ifc.toDateTime();
        expect(
          back.year,
          gregorian.year,
          reason: 'Day $d year mismatch: $gregorian -> $ifc -> $back',
        );
        expect(
          back.month,
          gregorian.month,
          reason: 'Day $d month mismatch: $gregorian -> $ifc -> $back',
        );
        expect(
          back.day,
          gregorian.day,
          reason: 'Day $d day mismatch: $gregorian -> $ifc -> $back',
        );
      }
    });
  });

  group('Gregorian helpers', () {
    test('gregorianDaysInMonth for common months', () {
      expect(gregorianDaysInMonth(2025, 1), 31); // January
      expect(gregorianDaysInMonth(2025, 2), 28); // Feb non-leap
      expect(gregorianDaysInMonth(2024, 2), 29); // Feb leap
      expect(gregorianDaysInMonth(2025, 4), 30); // April
      expect(gregorianDaysInMonth(2025, 12), 31); // December
    });

    test('gregorianMonthStartWeekday returns 0=Sun through 6=Sat', () {
      // Jan 1, 2025 is a Wednesday
      expect(gregorianMonthStartWeekday(2025, 1), 3);
      // Feb 1, 2025 is a Saturday
      expect(gregorianMonthStartWeekday(2025, 2), 6);
      // Jun 1, 2025 is a Sunday
      expect(gregorianMonthStartWeekday(2025, 6), 0);
    });
  });

  group('IfcDate properties', () {
    test('monthName returns correct names', () {
      expect(const IfcDate(year: 2025, month: 0, day: 1).monthName, 'January');
      expect(const IfcDate(year: 2025, month: 6, day: 1).monthName, 'Sol');
      expect(
        const IfcDate(year: 2025, month: 12, day: 1).monthName,
        'December',
      );
    });

    test('equality works correctly', () {
      expect(
        const IfcDate(year: 2025, month: 1, day: 8),
        const IfcDate(year: 2025, month: 1, day: 8),
      );
      expect(
        const IfcDate(year: 2025, month: 1, day: 8) ==
            const IfcDate(year: 2025, month: 1, day: 9),
        false,
      );
    });

    test('Year Day and Leap Day are not equal to regular days', () {
      expect(const IfcDate.yearDay(2025) == const IfcDate.yearDay(2025), true);
      expect(const IfcDate.yearDay(2025) == const IfcDate.leapDay(2025), false);
    });
  });
}
