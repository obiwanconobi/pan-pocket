import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

String? html;
class RssArticlePage extends StatefulWidget {
  RssArticlePage({super.key, required this.htmlText}){
    html = htmlText;
  }
final String htmlText;
  @override
  State<RssArticlePage> createState() => _RssArticlePageState();
}

class _RssArticlePageState extends State<RssArticlePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Article"), centerTitle: true,),
        body:
          SingleChildScrollView(child: Html(data: html)));
  }
}
