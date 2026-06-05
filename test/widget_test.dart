import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookvista/core/theme/app_theme.dart';

void main() {
  testWidgets('BookVista theme loads and shows app title', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Scaffold(
          body: Center(child: Text('BookVista')),
        ),
      ),
    );

    expect(find.text('BookVista'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
