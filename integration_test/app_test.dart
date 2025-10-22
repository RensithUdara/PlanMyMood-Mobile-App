import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:planmymood_mobileapp/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PlanMyMood App Integration Tests', () {
    testWidgets('Complete onboarding flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Wait for splash screen to finish
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Check if onboarding screen is displayed
      expect(find.text('Welcome to\nPlanMyMood!'), findsOneWidget);

      // Navigate through onboarding screens
      final nextButton = find.text('Next');
      
      // First onboarding screen
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Second onboarding screen
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Third onboarding screen
      await tester.tap(nextButton);
      await tester.pumpAndSettle();

      // Fourth onboarding screen (mood selection)
      expect(find.text('Time to choose\nyour mood!'), findsOneWidget);

      // Select a mood (assuming Happy mood with 😊 emoji)
      await tester.tap(find.text('😊'));
      await tester.pumpAndSettle();

      // Continue to confirmation
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Complete onboarding
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      // Should now be on the dashboard
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Create and complete a task', (WidgetTester tester) async {
      // Assuming we're already on the dashboard
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Skip onboarding for this test or ensure we're on dashboard
      // This would require setting up the app state appropriately

      // Tap the FAB to create a new task
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Fill in task details
      await tester.enterText(find.byType(TextFormField).first, 'Test Task');
      await tester.pumpAndSettle();

      // Select an icon type and color (would need to implement proper finders)
      // This is a simplified version - actual implementation would need more specific selectors

      // Save the task
      await tester.tap(find.text('Save Task'));
      await tester.pumpAndSettle();

      // Verify task appears in the list
      expect(find.text('Test Task'), findsOneWidget);

      // Mark task as completed
      await tester.tap(find.byIcon(Icons.check_circle_outline));
      await tester.pumpAndSettle();

      // Verify task is marked as completed
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('Navigate between different sections', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Test navigation if you have a bottom navigation bar or drawer
      // This is a placeholder - actual implementation depends on your app structure

      // If you have a calendar view
      if (find.byIcon(Icons.calendar_today).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.calendar_today));
        await tester.pumpAndSettle();
      }

      // If you have settings
      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Return to main dashboard
      if (find.byIcon(Icons.home).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.home));
        await tester.pumpAndSettle();
      }
    });

    testWidgets('Test mood selection and filtering', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Tap on mood indicator to change mood
      // This would depend on your UI implementation
      
      // Create a task with specific mood
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Mood-specific Task');
      
      // Select mood for task
      // Implementation would depend on your mood selection UI

      await tester.tap(find.text('Save Task'));
      await tester.pumpAndSettle();

      // Filter tasks by mood
      // Implementation would depend on your filtering UI
    });

    testWidgets('Test data persistence across app restarts', (WidgetTester tester) async {
      // Create a task
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'Persistent Task');
      await tester.tap(find.text('Save Task'));
      await tester.pumpAndSettle();

      // Restart the app (simulate app being killed and restarted)
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/platform',
        const StandardMethodCodec().encodeMethodCall(
          const MethodCall('SystemNavigator.pop'),
        ),
        (data) {},
      );

      // Start app again
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify task still exists
      expect(find.text('Persistent Task'), findsOneWidget);
    });
  });
}