import 'package:flutter/material.dart';
import 'models/calendar_mode.dart';
import 'models/ifc_date.dart';
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
      theme: ThemeData(useMaterial3: true, fontFamily: 'serif'),
      home: const CalendarHomePage(),
    );
  }
}

// Keep top-level alias for backward compatibility with existing tests
const List<String> monthNames = lunarMonthNames;

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  State<CalendarHomePage> createState() => _CalendarHomePageState();
}

class _CalendarHomePageState extends State<CalendarHomePage> {
  CalendarMode _mode = CalendarMode.lunar;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isLunar = _mode == CalendarMode.lunar;

    // Determine month list, title, and today position based on mode
    final months = isLunar ? lunarMonthNames : gregorianMonthNames;
    final title = isLunar ? '13-Month Lunar Calendar' : 'Calendar';

    // Today's position in the current mode
    int? todayMonthIndex;
    int? todayDay;
    if (isLunar) {
      final todayIfc = IfcDate.fromDateTime(now);
      if (todayIfc.isRegularDay) {
        todayMonthIndex = todayIfc.month;
        todayDay = todayIfc.day;
      }
    } else {
      todayMonthIndex = now.month - 1; // 0-indexed
      todayDay = now.day;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8D5D0),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header section with title and year
                Text(
                  title,
                  style: const TextStyle(
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

                // Navigation buttons (unchanged, visual only for now)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPillButton('Calendar View', isSelected: true),
                    const SizedBox(width: 16),
                    _buildPillButton('Explore & Learn', isSelected: false),
                  ],
                ),
                const SizedBox(height: 16),

                // Calendar mode toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildModeButton('Lunar', CalendarMode.lunar),
                    const SizedBox(width: 12),
                    _buildModeButton('Standard', CalendarMode.gregorian),
                  ],
                ),
                const SizedBox(height: 32),

                // Month grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // Gregorian months can have up to 6 rows, need more height
                    childAspectRatio: isLunar ? 0.85 : 0.72,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    if (isLunar) {
                      return MonthCard(
                        monthName: months[index],
                        daysInMonth: 28,
                        startWeekday: 0,
                        todayDay: index == todayMonthIndex ? todayDay : null,
                      );
                    } else {
                      final gregMonth = index + 1;
                      return MonthCard(
                        monthName: months[index],
                        daysInMonth: gregorianDaysInMonth(now.year, gregMonth),
                        startWeekday: gregorianMonthStartWeekday(
                          now.year,
                          gregMonth,
                        ),
                        todayDay: index == todayMonthIndex ? todayDay : null,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, CalendarMode mode) {
    final isActive = _mode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _mode = mode;
        });
      },
      child: Semantics(
        label: '$label calendar',
        button: true,
        selected: isActive,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFB89090) : const Color(0xFFF5EDE8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFB89090), width: 1),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF7D6B6B),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the pill-shaped navigation buttons
  Widget _buildPillButton(String label, {required bool isSelected}) {
    return Semantics(
      label: label,
      button: true,
      selected: isSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB89090) : const Color(0xFFC9ADAD),
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
