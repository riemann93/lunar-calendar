# CLAUDE.md — Lunar Calendar

## Project overview

A Flutter mobile app implementing a **13-month lunar calendar** system. Each month has exactly 28 days (4 weeks), with a special month called "Sol" inserted between June and July. The app features an elegant, warm aesthetic with serif typography and a dusty-rose/peachy-beige color palette.

**Target platforms:** Android, iOS (primary), with web/desktop scaffolding available.

## Tech stack

- **Language:** Dart (SDK >=3.9.2 <4.0.0)
- **Framework:** Flutter (>=3.18.0), Material 3
- **State management:** Local `setState()` only — no external state management library yet
- **Linting:** `flutter_lints` ^5.0.0 (uses `package:flutter_lints/flutter.yaml`)

## Project structure

```
lib/
├── main.dart          # App entry point, theme, CalendarHomePage, month grid
├── month_card.dart    # MonthCard widget — displays one month with day headers + date grid
├── date_square.dart   # DateSquare widget — individual date cell with selection/hover states
└── main_old.dart      # Archived Flutter template (unused, kept for reference)
```

## Common commands

```bash
# Install dependencies
flutter pub get

# Run the app (debug)
flutter run

# Run on a specific platform
flutter run -d chrome        # web
flutter run -d android       # android emulator/device
flutter run -d ios            # iOS simulator/device

# Run tests
flutter test

# Lint / static analysis
flutter analyze

# Format code
dart format lib/
```

## Design system & color palette

The app uses a consistent warm color scheme. Reuse these values — don't introduce new colors without reason.

| Name             | Hex         | Usage                          |
|------------------|-------------|--------------------------------|
| Background       | `#E8D5D0`  | Scaffold background, date cells|
| Card background  | `#F5EDE8`  | MonthCard containers           |
| Dusty rose       | `#B89090`  | Selected states, active buttons|
| Light rose       | `#C9ADAD`  | Inactive buttons               |
| Hover            | `#D4C4C0`  | Date cell hover state          |
| Text dark        | `#7D6B6B`  | Headings, month names          |
| Text muted       | `#9D8B8B`  | Subtext, day headers, dates    |

**Typography:** Serif font family throughout. Weights used: 300 (light), 400 (regular), 500 (medium).

## Code conventions

- **Widget files:** One widget per file, filename matches the widget in `snake_case` (e.g., `MonthCard` → `month_card.dart`)
- **Const constructors:** Use `const` wherever possible (`const MyWidget({super.key})`)
- **`super.key`:** Use the shorthand `super.key` syntax, not `Key? key`
- **Color literals:** Use `Color(0xFFHEXVAL)` inline — no centralized color constants file yet
- **Comments:** Brief inline comments explaining *why*, not *what* — especially for color choices and design decisions
- **State:** Keep state local to the widget that owns it. Pass callbacks down (`onDateSelected`) rather than lifting state unnecessarily

## Architecture notes

- The app is early-stage — only 3 active source files
- The 13 month names are defined as a top-level `const List<String>` in `main.dart`
- Every month has exactly 28 days (4 perfect weeks) — this is by design, not a bug
- `CalendarHomePage` uses a 2-column `GridView.builder` for the month grid
- `MonthCard` manages which date is selected within that month
- `DateSquare` is stateful only for hover tracking; selection state is owned by `MonthCard`

## Working with me (tips for the developer)

Since you're newer to agentic coding, here are some things that help me help you:

- **Be specific about what you want.** "Make it look better" is hard to act on. "Make the month cards have rounded corners and a subtle shadow" is great.
- **Tell me the platform you're testing on.** Flutter behaves differently on web vs mobile — knowing your target helps me write the right code.
- **Ask me to explain anything.** If I make a change and you don't understand why, just ask. There's no penalty for asking questions.
- **One thing at a time works well.** Rather than "build the whole app", try "add navigation between calendar view and explore view" — smaller tasks get better results.
- **Review what I produce.** I can make mistakes. Run the app after changes and tell me if something looks wrong or doesn't work.
- **You can say "undo that".** If I make a change you don't like, just tell me and I'll revert it.

## Current state / known TODOs

- The two pill buttons ("Calendar View" / "Explore & Learn") are visual only — no navigation yet
- Year is hardcoded to 2024
- No data model for actual lunar cycle calculations
- `main_old.dart` can be deleted when no longer needed for reference
- No tests written for the actual app widgets (only the default template test exists)
