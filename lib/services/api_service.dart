import 'package:http/http.dart' as http;
import '../models/article_form.dart';

class ApiService {

  Future<List<ArticleForm>> fetchArticles() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return articleFormFromJson(response.body);
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      throw Exception('Error fetching articles: $e');
    }
  }

}
