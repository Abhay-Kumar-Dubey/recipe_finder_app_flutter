import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  group('Search Bar Widget Tests', () {
    testWidgets('should display search icon and hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Verify search icon is present
      expect(find.byIcon(Icons.search), findsOneWidget);
      
      // Verify hint text is displayed
      expect(find.text('Search any recipes'), findsOneWidget);
    });

    testWidgets('should call onChanged when text is entered', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {
                changedValue = value;
              },
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Enter text in the search field
      await tester.enterText(find.byType(TextField), 'chicken');
      await tester.pump();

      // Verify that onChanged callback was called with correct value
      expect(changedValue, 'chicken');
    });

    testWidgets('should call onFilterTap when filter icon is tapped', (WidgetTester tester) async {
      bool filterTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {
                filterTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap on the filter icon
      await tester.tap(find.byKey(const Key('filter_button')));
      await tester.pump();

      // Verify that onFilterTap callback was called
      expect(filterTapped, true);
    });

    testWidgets('should display filter count badge when filterCount > 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {},
              filterCount: 2,
            ),
          ),
        ),
      );

      // Verify that filter count badge is displayed
      expect(find.text('2'), findsOneWidget);
      
      // Verify badge styling
      final Container badgeContainer = tester.widget<Container>(
        find.ancestor(
          of: find.text('2'),
          matching: find.byType(Container),
        ).first,
      );
      
      expect(badgeContainer.decoration, isA<BoxDecoration>());
      final decoration = badgeContainer.decoration as BoxDecoration;
      expect(decoration.color, Colors.amber);
      expect(decoration.borderRadius, BorderRadius.circular(6));
    });

    testWidgets('should not display filter count badge when filterCount is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {},
              filterCount: 0,
            ),
          ),
        ),
      );

      // Verify that no filter count badge is displayed
      expect(find.text('0'), findsNothing);
      expect(find.byKey(const Key('filter_badge')), findsNothing);
    });

    testWidgets('should have proper container styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Find the main container
      final containerFinder = find.byType(Container).first;
      final Container container = tester.widget(containerFinder);
      
      expect(container.decoration, isA<BoxDecoration>());
      final decoration = container.decoration as BoxDecoration;
      
      expect(decoration.borderRadius, BorderRadius.circular(20));
      expect(decoration.color, Colors.white);
      expect(decoration.boxShadow, isNotNull);
      expect(decoration.boxShadow?.isNotEmpty, true);
    });

    testWidgets('should have divider between search and filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {},
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Find the divider container
      final containers = tester.widgetList<Container>(find.byType(Container));
      final dividerContainer = containers.firstWhere(
        (container) => container.color == Colors.grey,
      );
      
      expect(dividerContainer, isNotNull);
    });

    testWidgets('should handle empty search input', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {
                changedValue = value;
              },
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Clear any existing text first
      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      
      // Then enter empty text
      await tester.enterText(find.byType(TextField), '');
      await tester.pump();

      // Verify that onChanged was called with empty string
      expect(changedValue, '');
    });

    testWidgets('should handle special characters in search', (WidgetTester tester) async {
      String? changedValue;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchBarWidget(
              onChanged: (value) {
                changedValue = value;
              },
              onFilterTap: () {},
            ),
          ),
        ),
      );

      // Enter text with special characters
      await tester.enterText(find.byType(TextField), 'café & crème');
      await tester.pump();

      // Verify that special characters are handled correctly
      expect(changedValue, 'café & crème');
    });
  });
}

// Custom SearchBar widget for testing
class SearchBarWidget extends StatelessWidget {
  final Function(String) onChanged;
  final VoidCallback onFilterTap;
  final int filterCount;

  const SearchBarWidget({
    Key? key,
    required this.onChanged,
    required this.onFilterTap,
    this.filterCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            const Icon(Icons.search),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                child: TextField(
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    hintText: "Search any recipes",
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
              width: 2,
              child: Container(color: Colors.grey),
            ),
            GestureDetector(
              key: const Key('filter_button'),
              onTap: onFilterTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Stack(
                  children: [
                    const Icon(Icons.filter_list),
                    if (filterCount > 0)
                      Positioned(
                        key: const Key('filter_badge'),
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '$filterCount',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}