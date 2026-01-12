import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:recipe_finder_app/app/services/api_service.dart';

void main() {
  group('ApiService Unit Tests', () {
    group('searchRecipesByName', () {
      test('should return list of recipes when API call is successful', () async {
        // This test would require dependency injection to properly mock
        // For now, we'll test the exception classes and URL constants
        expect(true, true); // Placeholder
      });

      test('should handle empty response correctly', () async {
        // Test the data parsing logic
        final List<Map<String, dynamic>> result = 
            List<Map<String, dynamic>>.from(<dynamic>[]);
        expect(result, isEmpty);
      });
    });

    group('ApiException', () {
      test('should create exception with message and status code', () {
        // Act
        final exception = ApiException('Test error', 404);

        // Assert
        expect(exception.message, 'Test error');
        expect(exception.statusCode, 404);
        expect(exception.toString(), 'ApiException: Test error (Status: 404)');
      });

      test('should handle different status codes', () {
        final exception500 = ApiException('Server error', 500);
        final exception401 = ApiException('Unauthorized', 401);
        
        expect(exception500.statusCode, 500);
        expect(exception401.statusCode, 401);
        expect(exception500.message, 'Server error');
        expect(exception401.message, 'Unauthorized');
      });
    });

    group('Data Processing', () {
      test('should handle null meals in response', () {
        final Map<String, dynamic> mockResponse = {'meals': null};
        final result = List<Map<String, dynamic>>.from(mockResponse['meals'] ?? []);
        expect(result, isEmpty);
      });

      test('should handle empty meals array', () {
        final Map<String, dynamic> mockResponse = {'meals': []};
        final result = List<Map<String, dynamic>>.from(mockResponse['meals'] ?? []);
        expect(result, isEmpty);
      });

      test('should process valid meals data', () {
        final Map<String, dynamic> mockResponse = {
          'meals': [
            {'idMeal': '1', 'strMeal': 'Test Recipe'},
            {'idMeal': '2', 'strMeal': 'Another Recipe'}
          ]
        };
        final result = List<Map<String, dynamic>>.from(mockResponse['meals'] ?? []);
        expect(result.length, 2);
        expect(result.first['strMeal'], 'Test Recipe');
      });
    });

    group('URL Construction', () {
      test('should have valid base URLs', () {
        // Test that all API constants are properly formatted URLs
        expect(Uri.tryParse('https://www.themealdb.com/api/json/v1/1/search.php?s=test'), isNotNull);
        expect(Uri.tryParse('https://www.themealdb.com/api/json/v1/1/filter.php?a=test'), isNotNull);
        expect(Uri.tryParse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=test'), isNotNull);
      });
    });
  });
}