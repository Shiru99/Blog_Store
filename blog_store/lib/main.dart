import 'package:blog_store/Authentication.dart';
import 'package:blog_store/HomePage.dart';
import 'package:blog_store/Mapping.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() {
  runApp(BlogStore());
}

class BlogStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog Store",
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MappingPage(
        auth: Auth(),
      ),
    );
  }
}
