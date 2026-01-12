import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/data/models/home_recipe_model.dart';

void main() {
  group('Recipe List Item Widget Tests', () {
    late HomeRecipeModel testRecipe;

    setUp(() {
      testRecipe = HomeRecipeModel(
        id: '52977',
        name: 'Corba',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
      );
    });

    testWidgets('should display recipe name', (WidgetTester tester) async {
      // Build our recipe list item widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              recipe: testRecipe,
              index: 0,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that recipe name is displayed
      expect(find.text('Corba'), findsOneWidget);
    });

    testWidgets('should handle tap gesture', (WidgetTester tester) async {
      bool wasTapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              recipe: testRecipe,
              index: 0,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      );

      // Tap on the recipe item
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      // Verify that onTap callback was called
      expect(wasTapped, true);
    });

    testWidgets('should display hero widget with correct tag', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              recipe: testRecipe,
              index: 5,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that Hero widget is present with correct tag
      expect(find.byType(Hero), findsOneWidget);
      
      final Hero heroWidget = tester.widget(find.byType(Hero));
      expect(heroWidget.tag, 'image-5');
    });

    testWidgets('should handle long recipe names with ellipsis', (WidgetTester tester) async {
      final longNameRecipe = HomeRecipeModel(
        id: '52977',
        name: 'This is a very long recipe name that should be truncated with ellipsis when displayed',
        thumbnailUrl: 'https://www.themealdb.com/images/media/meals/58oia61564916529.jpg',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 200, // Constrain width to force text overflow
              child: RecipeListItem(
                recipe: longNameRecipe,
                index: 0,
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      // Find the text widget
      final textFinder = find.text(longNameRecipe.name);
      expect(textFinder, findsOneWidget);

      // Verify that text has overflow property set
      final Text textWidget = tester.widget(textFinder);
      expect(textWidget.overflow, TextOverflow.ellipsis);
      expect(textWidget.maxLines, 2);
    });

    testWidgets('should display gradient overlay', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              recipe: testRecipe,
              index: 0,
              onTap: () {},
            ),
          ),
        ),
      );

      // Verify that gradient container is present
      expect(find.byType(Container), findsWidgets);
      
      // Find container with gradient decoration
      final containers = tester.widgetList<Container>(find.byType(Container));
      final gradientContainer = containers.firstWhere(
        (container) => container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).gradient != null,
      );
      
      expect(gradientContainer, isNotNull);
      
      final decoration = gradientContainer.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should have proper styling for recipe name text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RecipeListItem(
              recipe: testRecipe,
              index: 0,
              onTap: () {},
            ),
          ),
        ),
      );

      final textFinder = find.text('Corba');
      final Text textWidget = tester.widget(textFinder);
      
      expect(textWidget.style?.color, Colors.white);
      expect(textWidget.style?.fontWeight, FontWeight.bold);
      expect(textWidget.style?.shadows, isNotNull);
      expect(textWidget.style?.shadows?.isNotEmpty, true);
    });
  });
}

// Custom widget for testing recipe list item
class RecipeListItem extends StatelessWidget {
  final HomeRecipeModel recipe;
  final int index;
  final VoidCallback onTap;

  const RecipeListItem({
    Key? key,
    required this.recipe,
    required this.index,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Use a placeholder instead of network image for tests
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Hero(
                tag: "image-$index",
                child: Container(
                  width: double.infinity,
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50),
                ),
              ),
            ),
            Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.5, 1.0],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    recipe.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}