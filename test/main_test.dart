import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/event_list_sheet.dart';
import 'package:lunar_calendar/main.dart';
import 'package:lunar_calendar/month_card.dart';

void main() {
  group('monthNames', () {
    test('has exactly 13 entries', () {
      expect(monthNames.length, 13);
    });

    test('contains Sol as the 7th month (index 6)', () {
      expect(monthNames[6], 'Sol');
    });

    test('starts with January and ends with December', () {
      expect(monthNames.first, 'January');
      expect(monthNames.last, 'December');
    });

    test('all month names are non-empty', () {
      for (final name in monthNames) {
        expect(name.isNotEmpty, true);
      }
    });

    test('has no duplicate month names', () {
      expect(monthNames.toSet().length, monthNames.length);
    });
  });

  group('MyApp', () {
    testWidgets('renders a MaterialApp', (tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('has correct app title', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.title, '13-Month Lunar Calendar');
    });

    testWidgets('disables debug banner', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.debugShowCheckedModeBanner, false);
    });

    testWidgets('uses Material3', (tester) async {
      await tester.pumpWidget(const MyApp());

      final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, true);
    });
  });

  group('CalendarHomePage - lunar mode (default)', () {
    testWidgets('renders the lunar calendar title by default', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      expect(find.text('13-Month Lunar Calendar'), findsOneWidget);
    });

    testWidgets('renders the current year', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      final currentYear = DateTime.now().year.toString();
      expect(find.text(currentYear), findsOneWidget);
    });

    testWidgets('renders Calendar View pill button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      expect(find.text('Calendar View'), findsOneWidget);
    });

    testWidgets('renders Explore & Learn pill button', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      expect(find.text('Explore & Learn'), findsOneWidget);
    });

    testWidgets('renders mode toggle buttons', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      expect(find.text('Lunar'), findsOneWidget);
      expect(find.text('Standard'), findsOneWidget);
    });

    testWidgets('renders 13 MonthCard widgets in lunar mode', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      expect(find.byType(MonthCard), findsNWidgets(13));
    });

    testWidgets('renders all lunar month names', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      for (final name in monthNames) {
        expect(find.text(name), findsAtLeastNWidgets(1));
      }
    });

    testWidgets('uses correct background color', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, const Color(0xFFE8D5D0));
    });

    testWidgets('at most one MonthCard receives a todayDay value', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      final cards = tester.widgetList<MonthCard>(find.byType(MonthCard));
      final cardsWithToday = cards
          .where((card) => card.todayDay != null)
          .toList();
      // 0 on Year Day / Leap Day, 1 on regular days
      expect(cardsWithToday.length, lessThanOrEqualTo(1));
      if (cardsWithToday.isNotEmpty) {
        expect(cardsWithToday.first.todayDay, inInclusiveRange(1, 28));
      }
    });
  });

  group('CalendarHomePage - mode toggle', () {
    testWidgets('tapping Standard switches to 12-month Gregorian view', (
      tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      // Default: 13 months
      expect(find.byType(MonthCard), findsNWidgets(13));

      // Tap "Standard"
      await tester.tap(find.text('Standard'));
      await tester.pump();

      // Should now show 12 months
      expect(find.byType(MonthCard), findsNWidgets(12));
      expect(find.text('Calendar'), findsOneWidget);
    });

    testWidgets('tapping Lunar switches back to 13-month view', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      // Switch to Gregorian
      await tester.tap(find.text('Standard'));
      await tester.pump();
      expect(find.byType(MonthCard), findsNWidgets(12));

      // Switch back to Lunar
      await tester.tap(find.text('Lunar'));
      await tester.pump();
      expect(find.byType(MonthCard), findsNWidgets(13));
      expect(find.text('13-Month Lunar Calendar'), findsOneWidget);
    });

    testWidgets('Gregorian mode does not show Sol month', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      await tester.tap(find.text('Standard'));
      await tester.pump();

      expect(find.text('Sol'), findsNothing);
    });

    testWidgets('each MonthCard receives the correct monthIndex',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      final cards = tester.widgetList<MonthCard>(find.byType(MonthCard)).toList();
      for (int i = 0; i < cards.length; i++) {
        expect(cards[i].monthIndex, i);
      }
    });

    testWidgets('MonthCards receive hasEventOnDay callback',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      final cards = tester.widgetList<MonthCard>(find.byType(MonthCard));
      for (final card in cards) {
        expect(card.hasEventOnDay, isNotNull);
      }
    });

    testWidgets('tapping a date shows the event list sheet', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: CalendarHomePage()));

      // Tap the first date "1" in the first MonthCard
      await tester.tap(find.text('1').first);
      await tester.pumpAndSettle();

      // EventListSheet should now be visible in the modal
      expect(find.byType(EventListSheet), findsOneWidget);
    });
  });
}
