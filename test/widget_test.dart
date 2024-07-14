// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xoloficaciones/main.dart';

void main() {
  testWidgets('Login screen has title and input fields', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the login screen is displayed.
    expect(find.text('Xolificaciones'), findsOneWidget);

    // Verify that we have input fields for username and password.
    expect(find.byType(TextField), findsNWidgets(2));

    // Verify that we have a login button.
    expect(find.widgetWithText(ElevatedButton, 'Ingresar'), findsOneWidget);
  });

  testWidgets('Login fails with incorrect credentials', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Enter incorrect username and password
    await tester.enterText(find.byType(TextField).at(0), 'wronguser');
    await tester.enterText(find.byType(TextField).at(1), 'wrongpass');

    // Tap the login button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Ingresar'));
    await tester.pump();

    // Verify that an error message is displayed
    expect(find.text('Invalid credentials'), findsOneWidget);
  });

  // You would need to mock the database for this test
  testWidgets('Login succeeds with correct credentials', (WidgetTester tester) async {
    // TODO: Implement this test after setting up a way to mock the database
  });
}