import 'package:flutter/material.dart';
import 'models/event.dart';

/// Bottom sheet displaying events for a specific date, with an option to add new ones.
class EventListSheet extends StatelessWidget {
  final String monthName;
  final int day;
  final List<Event> events;
  final VoidCallback onAddEvent;

  const EventListSheet({
    super.key,
    required this.monthName,
    required this.day,
    required this.events,
    required this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF5EDE8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFB89090),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Date header
          Text(
            '$monthName $day',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D6B6B),
            ),
          ),
          const SizedBox(height: 16),

          // Events list or empty state
          if (events.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No events yet',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF9D8B8B),
                ),
              ),
            )
          else
            ...events.map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7D6B6B),
                          ),
                        ),
                        if (event.description.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              event.description,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF9D8B8B),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                )),

          const SizedBox(height: 8),

          // Add Event button
          GestureDetector(
            onTap: onAddEvent,
            child: Semantics(
              label: 'Add Event',
              button: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFB89090),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'Add Event',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
