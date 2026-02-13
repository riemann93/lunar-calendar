import 'package:flutter/material.dart';
import 'models/event.dart';

/// Bottom sheet form for creating a new event with title and optional description.
class EventFormSheet extends StatefulWidget {
  final String monthName;
  final int day;
  final ValueChanged<Event> onSave;

  const EventFormSheet({
    super.key,
    required this.monthName,
    required this.day,
    required this.onSave,
  });

  @override
  State<EventFormSheet> createState() => _EventFormSheetState();
}

class _EventFormSheetState extends State<EventFormSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _titleIsEmpty = true;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      setState(() {
        _titleIsEmpty = _titleController.text.trim().isEmpty;
      });
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleIsEmpty) return;

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
    );
    widget.onSave(event);
    Navigator.pop(context);
  }

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

          // Header
          const Text(
            'New Event',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D6B6B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.monthName} ${widget.day}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xFF9D8B8B),
            ),
          ),
          const SizedBox(height: 20),

          // Title field
          TextField(
            controller: _titleController,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D6B6B),
            ),
            decoration: const InputDecoration(
              hintText: 'Event title',
              hintStyle: TextStyle(
                color: Color(0xFF9D8B8B),
                fontWeight: FontWeight.w300,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD4C4C0)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB89090)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Description field
          TextField(
            controller: _descriptionController,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF7D6B6B),
            ),
            decoration: const InputDecoration(
              hintText: 'Description (optional)',
              hintStyle: TextStyle(
                color: Color(0xFF9D8B8B),
                fontWeight: FontWeight.w300,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD4C4C0)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB89090)),
              ),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 24),

          // Save button — disabled when title is empty
          GestureDetector(
            onTap: _titleIsEmpty ? null : _handleSave,
            child: Semantics(
              label: 'Save',
              button: true,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _titleIsEmpty
                      ? const Color(0xFFC9ADAD) // Inactive
                      : const Color(0xFFB89090), // Active
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'Save',
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
