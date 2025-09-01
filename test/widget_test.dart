import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskmanagerapp/main.dart';

void main() {
  testWidgets('Add task test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(TaskManagerApp());

    // Wait for SplashScreen to finish (3 seconds)
    await tester.pumpAndSettle(Duration(seconds: 3));

    // Verify HomeScreen shows "No tasks yet!"
    expect(find.text('No tasks yet! 🌸'), findsOneWidget);

    // Tap the add task button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter a task in the text field
    await tester.enterText(find.byType(TextField), 'Buy groceries');

    // Tap the Add Task button
    await tester.tap(find.text('Add Task'));
    await tester.pumpAndSettle();

    // Verify the task appears in the list
    expect(find.text('Buy groceries'), findsOneWidget);
  });
}
