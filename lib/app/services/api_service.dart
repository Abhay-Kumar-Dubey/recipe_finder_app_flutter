import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:recipe_finder_app/app/helper/api_constant.dart';

class ApiService {
  static const Duration _timeout = Duration(seconds: 20);

  // Base HTTP GET method
  static Future<Map<String, dynamic>> _get(String url) async {
    try {
      log('API Request: $url');

      final response = await http.get(Uri.parse(url)).timeout(_timeout);

      log('API Response Status: ${response.statusCode}');

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final data = jsonDecode(response.body);
        log('API Response: ${response.body}');
        return data;
      } else {
        throw ApiException(
          'Failed to load data. Status code: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      log('API Error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Network error: $e', 0);
    }
  }

  // Search recipes by name
  static Future<List<Map<String, dynamic>>> searchRecipesByName(
    String query,
  ) async {
    final data = await _get('${apiConstant.SearchByName}$query');
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }

  // Get recipe details by ID
  static Future<List<Map<String, dynamic>>> getRecipeById(String id) async {
    final data = await _get('${apiConstant.SearchById}$id');
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }

  // Filter recipes by area
  static Future<List<Map<String, dynamic>>> filterRecipesByArea(
    String area,
  ) async {
    final data = await _get('${apiConstant.FilterByArea}$area');
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }

  // Filter recipes by category
  static Future<List<Map<String, dynamic>>> filterRecipesByCategory(
    String category,
  ) async {
    final data = await _get('${apiConstant.FilterByCategory}$category');
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }

  // Get all categories
  static Future<List<Map<String, dynamic>>> getAllCategories() async {
    final data = await _get(apiConstant.ListAllCategiries);
    return List<Map<String, dynamic>>.from(data['categories'] ?? []);
  }

  // Get list of all category names
  static Future<List<Map<String, dynamic>>> getCategoryList() async {
    final data = await _get(apiConstant.listAllCategory);
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }

  // Get list of all areas
  static Future<List<Map<String, dynamic>>> getAreaList() async {
    final data = await _get(apiConstant.listAllAreas);
    return List<Map<String, dynamic>>.from(data['meals'] ?? []);
  }
}

// Custom exception class for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}
