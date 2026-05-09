import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fp_frontend/main.dart';

void main() {
  testWidgets('App renders Home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EisenhowerApp());
    expect(find.text('Eisenhower Matrix'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('FAB navigates to Add Task screen', (WidgetTester tester) async {
    await tester.pumpWidget(const EisenhowerApp());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsOneWidget);
    expect(find.text('Save Task'), findsOneWidget);
  });
}
