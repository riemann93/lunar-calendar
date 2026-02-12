import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/date_square.dart';
import 'package:lunar_calendar/month_card.dart';

/// Helper to pump a MonthCard inside a constrained layout.
Widget buildTestMonthCard(String monthName) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 300,
        height: 400,
        child: MonthCard(monthName: monthName),
      ),
    ),
  );
}

void main() {
  group('MonthCard', () {
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
        tester.widget<DateSquare>(find.widgetWithText(DateSquare, '10')).isSelected,
        true,
      );

      // Tap again to deselect
      await tester.tap(find.text('10'));
      await tester.pump();
      expect(
        tester.widget<DateSquare>(find.widgetWithText(DateSquare, '10')).isSelected,
        false,
      );
    });
  });
}
