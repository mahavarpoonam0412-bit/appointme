import 'package:flutter_test/flutter_test.dart';
import 'package:appointme/main.dart';

void main() {
  testWidgets('AppointMe app test', (WidgetTester tester) async {

    await tester.pumpWidget(const AppointMe());

    expect(find.text('AppointMe'), findsOneWidget);

  });
}