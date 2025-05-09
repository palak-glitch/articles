import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import 'article_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final favorites = provider.favorites;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Favorites', style: TextStyle(fontSize: width * 0.05)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body:
          favorites.isEmpty
              ? Center(
                child: Text(
                  'No connection. Showing saved favorites if available.',
                  style: TextStyle(fontSize: width * 0.045, color: Colors.grey),
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03,
                  vertical: width * 0.02,
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final article = favorites[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.04),
                    ),
                    margin: EdgeInsets.symmetric(vertical: width * 0.02),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(width * 0.04),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ArticleDetailsScreen(article: article),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: width * 0.03,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.title,
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: width * 0.015),
                            Text(
                              article.body.length > 100
                                  ? '${article.body.substring(0, 100)}...'
                                  : article.body,
                              style: TextStyle(
                                fontSize: width * 0.04,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: width * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'User ID: ${article.userId}',
                                  style: TextStyle(
                                    fontSize: width * 0.03,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: width * 0.035,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
