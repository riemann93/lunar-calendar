import 'package:flutter/material.dart';
import 'models/calendar_mode.dart';
import 'models/event.dart';
import 'models/ifc_date.dart';
import 'month_card.dart';
import 'event_list_sheet.dart';
import 'event_form_sheet.dart';

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
  final EventStore _eventStore = EventStore();

  /// Convert a month index + day to a Gregorian DateTime based on current mode.
  DateTime _toGregorianDate(int monthIndex, int day) {
    final year = DateTime.now().year;
    if (_mode == CalendarMode.lunar) {
      // IFC month/day → Gregorian
      final ifcDate = IfcDate(year: year, month: monthIndex, day: day);
      return ifcDate.toDateTime();
    } else {
      // Gregorian month (0-indexed) + day → DateTime
      return DateTime(year, monthIndex + 1, day);
    }
  }

  /// Check if a given day in a month has events (for dot indicator).
  bool _hasEventOnDay(int monthIndex, int day) {
    final gregDate = _toGregorianDate(monthIndex, day);
    return _eventStore.hasEvents(gregDate);
  }

  void _onDateTapped(int monthIndex, int day) {
    final gregDate = _toGregorianDate(monthIndex, day);
    final months = _mode == CalendarMode.lunar ? lunarMonthNames : gregorianMonthNames;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => EventListSheet(
        monthName: months[monthIndex],
        day: day,
        events: _eventStore.forDate(gregDate),
        onAddEvent: () {
          Navigator.pop(context);
          _showAddEventForm(monthIndex, day);
        },
      ),
    );
  }

  void _showAddEventForm(int monthIndex, int day) {
    final months = _mode == CalendarMode.lunar ? lunarMonthNames : gregorianMonthNames;
    final gregDate = _toGregorianDate(monthIndex, day);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EventFormSheet(
          monthName: months[monthIndex],
          day: day,
          date: gregDate,
          onSave: (event) {
            setState(() {
              _eventStore.add(event);
            });
          },
        ),
      ),
    );
  }

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
                        monthIndex: index,
                        todayDay: index == todayMonthIndex ? todayDay : null,
                        hasEventOnDay: (day) => _hasEventOnDay(index, day),
                        onDateTapped: _onDateTapped,
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
                        monthIndex: index,
                        todayDay: index == todayMonthIndex ? todayDay : null,
                        hasEventOnDay: (day) => _hasEventOnDay(index, day),
                        onDateTapped: _onDateTapped,
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
