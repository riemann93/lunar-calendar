import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lunar_calendar/event_list_sheet.dart';
import 'package:lunar_calendar/models/event.dart';

/// Helper to pump an EventListSheet inside a MaterialApp.
Widget buildTestEventListSheet({
  String monthName = 'Sol',
  int day = 14,
  List<Event> events = const [],
  VoidCallback? onAddEvent,
}) {
  return MaterialApp(
    home: Scaffold(
      body: EventListSheet(
        monthName: monthName,
        day: day,
        events: events,
        onAddEvent: onAddEvent ?? () {},
      ),
    ),
  );
}

void main() {
  group('EventListSheet', () {
    testWidgets('displays month name and day', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet(
        monthName: 'Sol',
        day: 14,
      ));

      expect(find.text('Sol 14'), findsOneWidget);
    });

    testWidgets('shows empty state when no events', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet());

      expect(find.text('No events yet'), findsOneWidget);
    });

    testWidgets('displays event titles', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet(
        events: [
          Event(id: '1', title: 'Meeting', date: DateTime(2026, 1, 1)),
          Event(id: '2', title: 'Dinner', date: DateTime(2026, 1, 1)),
        ],
      ));

      expect(find.text('Meeting'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
    });

    testWidgets('displays event descriptions', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet(
        events: [
          Event(id: '1', title: 'Meeting', date: DateTime(2026, 1, 1), description: 'Team sync'),
        ],
      ));

      expect(find.text('Team sync'), findsOneWidget);
    });

    testWidgets('hides description when empty', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet(
        events: [
          Event(id: '1', title: 'Meeting', date: DateTime(2026, 1, 1)),
        ],
      ));

      // Title shows but no description text
      expect(find.text('Meeting'), findsOneWidget);
      // The empty-state text should not appear since there is an event
      expect(find.text('No events yet'), findsNothing);
    });

    testWidgets('shows Add Event button', (tester) async {
      await tester.pumpWidget(buildTestEventListSheet());

      expect(find.text('Add Event'), findsOneWidget);
    });

    testWidgets('tapping Add Event calls onAddEvent', (tester) async {
      bool called = false;
      await tester.pumpWidget(buildTestEventListSheet(
        onAddEvent: () => called = true,
      ));

      await tester.tap(find.text('Add Event'));
      expect(called, true);
    });
  });
}
