import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_finder_app/app/helper/api_constant.dart';

void main() {
  group('Utility Functions Tests', () {
    group('ApiConstant', () {
      test('should have correct search by name URL', () {
        expect(
          apiConstant.SearchByName,
          'https://www.themealdb.com/api/json/v1/1/search.php?s=',
        );
      });

      test('should have correct filter by area URL', () {
        expect(
          apiConstant.FilterByArea,
          'https://www.themealdb.com/api/json/v1/1/filter.php?a=',
        );
      });

      test('should have correct search by ID URL', () {
        expect(
          apiConstant.SearchById,
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=',
        );
      });

      test('should have correct list all categories URL', () {
        expect(
          apiConstant.ListAllCategiries,
          'https://www.themealdb.com/api/json/v1/1/categories.php',
        );
      });

      test('should have correct list all areas URL', () {
        expect(
          apiConstant.ListAllAreas,
          'https://www.themealdb.com/api/json/v1/1/list.php?a=list',
        );
      });

      test('should have correct filter by category URL', () {
        expect(
          apiConstant.FilterByCategory,
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=',
        );
      });

      test('should have correct list all category URL', () {
        expect(
          apiConstant.listAllCategory,
          'https://www.themealdb.com/api/json/v1/1/list.php?c=list',
        );
      });

      test('should have correct list all areas URL (duplicate check)', () {
        expect(
          apiConstant.listAllAreas,
          'https://www.themealdb.com/api/json/v1/1/list.php?a=list',
        );
      });

      test('should have consistent base URL across all endpoints', () {
        const baseUrl = 'https://www.themealdb.com/api/json/v1/1/';
        
        expect(apiConstant.SearchByName.startsWith(baseUrl), true);
        expect(apiConstant.FilterByArea.startsWith(baseUrl), true);
        expect(apiConstant.SearchById.startsWith(baseUrl), true);
        expect(apiConstant.ListAllCategiries.startsWith(baseUrl), true);
        expect(apiConstant.ListAllAreas.startsWith(baseUrl), true);
        expect(apiConstant.FilterByCategory.startsWith(baseUrl), true);
        expect(apiConstant.listAllCategory.startsWith(baseUrl), true);
        expect(apiConstant.listAllAreas.startsWith(baseUrl), true);
      });

      test('should have proper query parameter structure', () {
        // Search endpoints should end with parameter
        expect(apiConstant.SearchByName.endsWith('?s='), true);
        expect(apiConstant.SearchById.endsWith('?i='), true);
        
        // Filter endpoints should end with parameter
        expect(apiConstant.FilterByArea.endsWith('?a='), true);
        expect(apiConstant.FilterByCategory.endsWith('?c='), true);
        
        // List endpoints should have proper query structure
        expect(apiConstant.ListAllAreas.endsWith('?a=list'), true);
        expect(apiConstant.listAllCategory.endsWith('?c=list'), true);
        expect(apiConstant.listAllAreas.endsWith('?a=list'), true);
      });
    });

    group('String Utility Functions', () {
      test('should handle empty string validation', () {
        // Test empty string
        expect(''.trim().isEmpty, true);
        
        // Test whitespace string
        expect('   '.trim().isEmpty, true);
        
        // Test valid string
        expect('chicken'.trim().isEmpty, false);
      });

      test('should handle null string conversion', () {
        // Simulate JSON null handling
        String? nullValue;
        String result = nullValue?.toString() ?? '';
        expect(result, '');
        
        // Simulate JSON value handling
        dynamic jsonValue = 'test';
        String result2 = jsonValue?.toString() ?? '';
        expect(result2, 'test');
      });

      test('should handle string comparison for sorting', () {
        final names = ['Zebra Cake', 'Apple Pie', 'Banana Bread'];
        
        // Test ascending sort
        names.sort((a, b) => a.compareTo(b));
        expect(names, ['Apple Pie', 'Banana Bread', 'Zebra Cake']);
        
        // Test descending sort
        names.sort((a, b) => b.compareTo(a));
        expect(names, ['Zebra Cake', 'Banana Bread', 'Apple Pie']);
      });
    });

    group('List Utility Functions', () {
      test('should handle list intersection correctly', () {
        final list1 = ['1', '2', '3', '4'];
        final list2 = ['2', '3', '5', '6'];
        
        final intersection = list1.where((item) => list2.contains(item)).toList();
        expect(intersection, ['2', '3']);
      });

      test('should handle empty list operations', () {
        final emptyList = <String>[];
        
        expect(emptyList.isEmpty, true);
        expect(emptyList.length, 0);
        expect(emptyList.where((item) => item.isNotEmpty).toList(), isEmpty);
      });

      test('should handle list mapping correctly', () {
        final numbers = [1, 2, 3, 4, 5];
        final doubled = numbers.map((n) => n * 2).toList();
        
        expect(doubled, [2, 4, 6, 8, 10]);
      });

      test('should handle list filtering correctly', () {
        final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        final evenNumbers = numbers.where((n) => n % 2 == 0).toList();
        
        expect(evenNumbers, [2, 4, 6, 8, 10]);
      });
    });

    group('DateTime Utility Functions', () {
      test('should handle DateTime comparison correctly', () {
        final now = DateTime.now();
        final earlier = now.subtract(Duration(hours: 1));
        final later = now.add(Duration(hours: 1));
        
        expect(earlier.isBefore(now), true);
        expect(later.isAfter(now), true);
        expect(now.isAtSameMomentAs(now), true);
      });

      test('should handle DateTime sorting correctly', () {
        final now = DateTime.now();
        final dates = [
          now.add(Duration(days: 1)),
          now.subtract(Duration(days: 1)),
          now,
        ];
        
        // Sort by newest first (descending)
        dates.sort((a, b) => b.compareTo(a));
        expect(dates.first.isAfter(dates.last), true);
        
        // Sort by oldest first (ascending)
        dates.sort((a, b) => a.compareTo(b));
        expect(dates.first.isBefore(dates.last), true);
      });
    });
  });
}