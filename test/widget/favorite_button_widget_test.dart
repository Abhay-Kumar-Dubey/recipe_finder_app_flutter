import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Favorite Button Widget Tests', () {
    testWidgets('should display filled heart when isFavorite is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that filled heart icon is displayed
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
      
      // Verify icon color is red
      final IconButton iconButton = tester.widget(find.byType(IconButton));
      final Icon icon = iconButton.icon as Icon;
      expect(icon.color, Colors.red);
    });

    testWidgets('should display outlined heart when isFavorite is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that outlined heart icon is displayed
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
      
      // Verify icon color is white
      final IconButton iconButton = tester.widget(find.byType(IconButton));
      final Icon icon = iconButton.icon as Icon;
      expect(icon.color, Colors.white);
    });

    testWidgets('should call onTap when button is pressed', (WidgetTester tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: false,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap the favorite button
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Verify that onTap callback was called
      expect(wasTapped, true);
    });

    testWidgets('should have proper container styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the container
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);
      
      final Container container = tester.widget(containerFinder);
      expect(container.decoration, isA<BoxDecoration>());
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, Colors.amber);
    });

    testWidgets('should toggle favorite state correctly', (WidgetTester tester) async {
      bool isFavorite = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return FavoriteButtonWidget(
                  isFavorite: isFavorite,
                  onTap: () {
                    setState(() {
                      isFavorite = !isFavorite;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      // Initially should show outlined heart
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Tap to add to favorites
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should now show filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);

      // Tap again to remove from favorites
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      // Should show outlined heart again
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should have proper padding', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: true,
              onTap: () {},
            ),
          ),
        ),
      );

      // Find the specific padding widget with EdgeInsets.all(10.0)
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      final targetPadding = paddingWidgets.firstWhere(
        (padding) => padding.padding == const EdgeInsets.all(10.0),
      );
      
      expect(targetPadding, isNotNull);
      expect(targetPadding.padding, const EdgeInsets.all(10.0));
    });

    testWidgets('should handle rapid taps without errors', (WidgetTester tester) async {
      int tapCount = 0;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: false,
              onTap: () {
                tapCount++;
              },
            ),
          ),
        ),
      );

      // Perform multiple rapid taps
      for (int i = 0; i < 5; i++) {
        await tester.tap(find.byType(IconButton));
      }
      await tester.pump();

      // Verify all taps were registered
      expect(tapCount, 5);
    });

    testWidgets('should maintain consistent size regardless of favorite state', (WidgetTester tester) async {
      // Test with favorite = false
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final Size sizeWhenNotFavorite = tester.getSize(find.byType(Container));

      // Test with favorite = true
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: true,
              onTap: () {},
            ),
          ),
        ),
      );

      final Size sizeWhenFavorite = tester.getSize(find.byType(Container));

      // Sizes should be the same
      expect(sizeWhenNotFavorite, sizeWhenFavorite);
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FavoriteButtonWidget(
              isFavorite: false,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that the button is semantically accessible
      expect(find.byType(IconButton), findsOneWidget);
      
      // The IconButton should be tappable
      final IconButton button = tester.widget(find.byType(IconButton));
      expect(button.onPressed, isNotNull);
    });
  });
}

// Custom Favorite Button widget for testing
class FavoriteButtonWidget extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const FavoriteButtonWidget({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: IconButton(
          onPressed: onTap,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.white,
          ),
        ),
      ),
    );
  }
}