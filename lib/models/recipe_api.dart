import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_app_api/models/recipe.dart';

class RecipeApi {
  static Future<List<Recipe>> getRecipe() async {
    var uri = Uri.https('tasty.p.rapidapi.com', '/feeds/list', {
      "size": "5",
      "timezone": "+0700",
      "vegetarian": "false",
      "from": "0",
      "limit": "18",
      "start": "0",
      "tag": "list.recipe.popular"
    });

    try {
      final response = await http.get(uri, headers: {
        "x-rapidapi-key": "22e77f3883mshf5a39ea3bff65edp10d4dbjsn96102b8eeb72",
        "x-rapidapi-host": 'yummly2.p.rapidapi.com',
      });
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        // Проверяем наличие поля 'feed' и его тип
        if (data['feed'] != null && data['feed'] is List) {
          List _temp = [];

          for (var i in data['feed']) {
            if (i['content'] != null && i['content']['details'] != null) {
              _temp.add(i['content']['details']);
            }
          }

          return Recipe.recipesFromSnapshot(_temp);
        } else {
          throw Exception('No feed found or incorrect data format');
        }
      } else {
        throw Exception('Failed to load recipes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
      return [];
    }
  }
}
