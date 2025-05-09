import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/article_provider.dart';
import 'article_details_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    provider.init(); // Load articles initially
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ArticleProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return Consumer<ArticleProvider>(
        builder: (context, provider, _)
    {
      return FutureBuilder(
        future: provider.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 2,
              surfaceTintColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(width * 0.05),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {}, // Optional: Add a drawer or action
                color: Colors.grey[700],
              ),
              title: Text(
                'Explore Articles',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {}, // Optional: Go to profile/settings
                  color: Colors.grey[700],
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    width * 0.04,
                    width * 0.03,
                    width * 0.04,
                    0,
                  ),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(width * 0.03),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        if (_debounce?.isActive ?? false) _debounce!.cancel();
                        _debounce = Timer(const Duration(milliseconds: 500), () {
                          provider.searchArticles(query);
                        });
                        // provider.searchArticles(query); // Now searches by title
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by title...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width * 0.03),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: width * 0.02),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.refresh,
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: 8,
                      ),
                      itemCount: provider.articles.length,
                      // itemCount: provider.articles.length,
                      itemBuilder: (context, index) {
                        final article = provider.articles[index];
                        final isFav = provider.isFavorite(article.id);
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                          margin: EdgeInsets.symmetric(vertical: width * 0.02),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: Text(
                              article.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                article.body.length > 100
                                    ? '${article.body.substring(0, 100)}...'
                                    : article.body,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav ? Colors.redAccent : Colors.grey,
                              ),
                              onPressed:
                                  () => provider.toggleFavorite(article.id),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                      ArticleDetailsScreen(article: article),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
    );
  }
}
