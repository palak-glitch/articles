// To parse this JSON data, do
//
//     final articleForm = articleFormFromJson(jsonString);

import 'dart:convert';

List<ArticleForm> articleFormFromJson(String str) => List<ArticleForm>.from(json.decode(str).map((x) => ArticleForm.fromJson(x)));

String articleFormToJson(List<ArticleForm> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ArticleForm {
  int userId;
  int id;
  String title;
  String body;

  ArticleForm({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory ArticleForm.fromJson(Map<String, dynamic> json) => ArticleForm(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    body: json["body"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "body": body,
  };
}
