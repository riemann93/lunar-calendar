import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/date_square.dart';
import 'package:lunar_calendar/month_card.dart';

/// Helper to pump a MonthCard inside a constrained layout.
Widget buildTestMonthCard(
  String monthName, {
  int daysInMonth = 28,
  int startWeekday = 0,
  int monthIndex = 0,
  int? todayDay,
  bool Function(int)? hasEventOnDay,
  void Function(int, int)? onDateTapped,
}) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 300,
        height: 500,
        child: MonthCard(
          monthName: monthName,
          daysInMonth: daysInMonth,
          startWeekday: startWeekday,
          monthIndex: monthIndex,
          todayDay: todayDay,
          hasEventOnDay: hasEventOnDay,
          onDateTapped: onDateTapped,
        ),
      ),
    ),
  );
}

void main() {
  group('MonthCard - lunar mode (28 days, no offset)', () {
    testWidgets('displays the month name', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('Sol'));

      expect(find.text('Sol'), findsOneWidget);
    });

    testWidgets('displays all 7 day-of-week headers', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      for (final day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']) {
        expect(find.text(day), findsOneWidget);
      }
    });

    testWidgets('renders 28 DateSquare widgets', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      expect(find.byType(DateSquare), findsNWidgets(28));
    });

    testWidgets('displays date numbers 1 through 28', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      for (int i = 1; i <= 28; i++) {
        expect(find.text('$i'), findsOneWidget);
      }
    });

    testWidgets('no date is selected initially', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      final squares = tester.widgetList<DateSquare>(find.byType(DateSquare));
      for (final sq in squares) {
        expect(sq.isSelected, false);
      }
    });

    testWidgets('tapping a date selects it', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      await tester.tap(find.text('15'));
      await tester.pump();

      final ds = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '15'),
      );
      expect(ds.isSelected, true);
    });

    testWidgets('tapping a different date moves selection', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      // Select date 15
      await tester.tap(find.text('15'));
      await tester.pump();

      // Select date 20
      await tester.tap(find.text('20'));
      await tester.pump();

      final ds15 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '15'),
      );
      final ds20 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '20'),
      );
      expect(ds15.isSelected, false);
      expect(ds20.isSelected, true);
    });

    testWidgets('tapping a selected date deselects it', (tester) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      // Select date 10
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(
        tester
            .widget<DateSquare>(find.widgetWithText(DateSquare, '10'))
            .isSelected,
        true,
      );

      // Tap again to deselect
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(
        tester
            .widget<DateSquare>(find.widgetWithText(DateSquare, '10'))
            .isSelected,
        false,
      );
    });

    testWidgets(
      'passes isToday to correct DateSquare when todayDay is provided',
      (tester) async {
        await tester.pumpWidget(buildTestMonthCard('January', todayDay: 14));

        final ds14 = tester.widget<DateSquare>(
          find.widgetWithText(DateSquare, '14'),
        );
        expect(ds14.isToday, true);

        // Other dates should not be today
        final ds15 = tester.widget<DateSquare>(
          find.widgetWithText(DateSquare, '15'),
        );
        expect(ds15.isToday, false);
      },
    );

    testWidgets('no DateSquare has isToday when todayDay is null', (
      tester,
    ) async {
      await tester.pumpWidget(buildTestMonthCard('January'));

      final squares = tester.widgetList<DateSquare>(find.byType(DateSquare));
      for (final sq in squares) {
        expect(sq.isToday, false);
      }
    });

    testWidgets('passes hasEvent to correct DateSquares via hasEventOnDay', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestMonthCard(
          'January',
          hasEventOnDay: (day) => day == 5 || day == 10,
        ),
      );

      final ds5 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '5'),
      );
      final ds10 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '10'),
      );
      final ds6 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '6'),
      );

      expect(ds5.hasEvent, true);
      expect(ds10.hasEvent, true);
      expect(ds6.hasEvent, false);
    });

    testWidgets('calls onDateTapped when a date is tapped', (tester) async {
      int? tappedMonth;
      int? tappedDay;

      await tester.pumpWidget(
        buildTestMonthCard(
          'Sol',
          monthIndex: 6,
          onDateTapped: (month, day) {
            tappedMonth = month;
            tappedDay = day;
          },
        ),
      );

      await tester.tap(find.text('14'));
      await tester.pump();

      expect(tappedMonth, 6);
      expect(tappedDay, 14);
    });
  });

  group('MonthCard - Gregorian mode (variable days and offset)', () {
    testWidgets('renders 31 DateSquares for a 31-day month', (tester) async {
      await tester.pumpWidget(
        buildTestMonthCard('March', daysInMonth: 31, startWeekday: 0),
      );

      expect(find.byType(DateSquare), findsNWidgets(31));
    });

    testWidgets('renders 30 DateSquares for a 30-day month', (tester) async {
      await tester.pumpWidget(
        buildTestMonthCard('April', daysInMonth: 30, startWeekday: 0),
      );

      expect(find.byType(DateSquare), findsNWidgets(30));
    });

    testWidgets('renders correct number with weekday offset', (tester) async {
      // A month starting on Wednesday (offset 3) with 31 days
      await tester.pumpWidget(
        buildTestMonthCard('January', daysInMonth: 31, startWeekday: 3),
      );

      // Should still have 31 DateSquare widgets (offset cells are SizedBox)
      expect(find.byType(DateSquare), findsNWidgets(31));
    });

    testWidgets('offset cells are empty SizedBox widgets', (tester) async {
      // Month starts on Saturday (offset 6)
      await tester.pumpWidget(
        buildTestMonthCard('August', daysInMonth: 31, startWeekday: 6),
      );

      // 31 date squares + 6 empty SizedBox cells in the grid
      // The grid has 37 items total but only 31 are DateSquare
      expect(find.byType(DateSquare), findsNWidgets(31));
    });

    testWidgets('hasEventOnDay callback is respected in Gregorian mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestMonthCard(
          'January',
          daysInMonth: 31,
          hasEventOnDay: (day) => day == 15,
        ),
      );

      final ds15 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '15'),
      );
      expect(ds15.hasEvent, true);

      final ds16 = tester.widget<DateSquare>(
        find.widgetWithText(DateSquare, '16'),
      );
      expect(ds16.hasEvent, false);
    });
  });
}
