
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lunacare/main.dart';

void main() {
  testWidgets(
    'LunaCare menampilkan halaman login',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const LunaCareApp(),
      );

      expect(
        find.text('LunaCare'),
        findsOneWidget,
      );

      expect(
        find.text('Selamat Datang'),
        findsOneWidget,
      );

      expect(
        find.byType(TextField),
        findsNWidgets(2),
      );
    },
  );
}
