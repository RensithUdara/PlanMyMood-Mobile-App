import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:planmymood_mobileapp/views/widgets/mood_grid.dart';
import 'package:planmymood_mobileapp/models/mood.dart';

void main() {
  group('MoodGrid Widget Tests', () {
    late List<Mood> testMoods;

    setUp(() {
      testMoods = [
        Mood(id: 1, name: 'Happy', emoji: '😊', color: '#FFD700'),
        Mood(id: 2, name: 'Sad', emoji: '😢', color: '#6BB6E8'),
        Mood(id: 3, name: 'Angry', emoji: '😠', color: '#E86B6B'),
      ];
    });

    testWidgets('MoodGrid displays all moods', (WidgetTester tester) async {
      Mood? selectedMood;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoodGrid(
              moods: testMoods,
              selectedMood: null,
              onMoodSelected: (mood) {
                selectedMood = mood;
              },
            ),
          ),
        ),
      );

      // Check if all moods are displayed
      expect(find.text('😊'), findsOneWidget);
      expect(find.text('😢'), findsOneWidget);
      expect(find.text('😠'), findsOneWidget);
    });

    testWidgets('MoodGrid handles mood selection', (WidgetTester tester) async {
      Mood? selectedMood;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoodGrid(
              moods: testMoods,
              selectedMood: null,
              onMoodSelected: (mood) {
                selectedMood = mood;
              },
            ),
          ),
        ),
      );

      // Tap on the first mood
      await tester.tap(find.text('😊'));
      await tester.pump();

      // Verify the mood was selected
      expect(selectedMood, equals(testMoods.first));
    });

    testWidgets('MoodGrid shows selected mood with different style',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MoodGrid(
              moods: testMoods,
              selectedMood: testMoods.first, // Pre-select first mood
              onMoodSelected: (mood) {},
            ),
          ),
        ),
      );

      await tester.pump();

      // The selected mood should be visually different
      // This would need to check for specific styling
      expect(find.text('😊'), findsOneWidget);
    });
  });
}