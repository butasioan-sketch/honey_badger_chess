import 'package:flutter_test/flutter_test.dart';
import 'package:honey_badger_chess/main.dart';

void main() {
  testWidgets('Honey Badger Chess startet', (WidgetTester tester) async {
    await tester.pumpWidget(const HoneyBadgerChessApp());
    expect(find.text('Honey Badger Chess'), findsWidgets);
  });
}
