import 'package:articles/screens/Bottom_Nav_Bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/article_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ArticleProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Articles',
        theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.teal,
            navigationBarTheme: NavigationBarThemeData(
            height: 70,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.teal.withOpacity(0.1),
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        home: const BottomNavBar(),
      ),
    );
  }
}


