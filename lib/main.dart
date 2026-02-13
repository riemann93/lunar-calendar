import 'package:flutter/material.dart';
import 'month_card.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '13-Month Lunar Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'serif', // Matches the elegant serif font in design
      ),
      home: const CalendarHomePage(),
    );
  }
}

// List of 13 month names for the lunar calendar
const List<String> monthNames = [
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

class CalendarHomePage extends StatelessWidget {
  const CalendarHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Compute today's position in the 13-month lunar calendar.
    // Each month is exactly 28 days, so day-of-year maps directly.
    // Days beyond 364 (day 365/366) are clamped to December 28.
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays + 1;
    final clampedDay = dayOfYear.clamp(1, 364);
    final todayMonthIndex = (clampedDay - 1) ~/ 28;
    final todayDay = (clampedDay - 1) % 28 + 1;

    return Scaffold(
      // Soft peachy-beige background color from design
      backgroundColor: const Color(0xFFE8D5D0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header section with title and year
                const Text(
                  '13-Month Lunar Calendar',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7D6B6B),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '${now.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFF9D8B8B),
                  ),
                ),
                const SizedBox(height: 24),

                // Button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPillButton('Calendar View', isSelected: true),
                    const SizedBox(width: 16),
                    _buildPillButton('Explore & Learn', isSelected: false),
                  ],
                ),
                const SizedBox(height: 32),

                // 2-column grid of month cards
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85, // Adjust height ratio
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: monthNames.length,
                  itemBuilder: (context, index) {
                    return MonthCard(
                      monthName: monthNames[index],
                      todayDay: index == todayMonthIndex ? todayDay : null,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the pill-shaped buttons
  Widget _buildPillButton(String label, {required bool isSelected}) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFB89090) // Dusty rose when selected
              : const Color(0xFFC9ADAD), // Lighter rose when not selected
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
