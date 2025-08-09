import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/rss_article_controller.dart';

String? html;
String? url;
class RssArticlePage extends StatefulWidget {
  RssArticlePage({super.key, required this.htmlText, required this.urlText}){
    html = htmlText;
    url = urlText;
  }
final String htmlText;
  final String urlText;
  @override
  State<RssArticlePage> createState() => _RssArticlePageState();
}

class _RssArticlePageState extends State<RssArticlePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var controller = GetIt.instance<RssArticleController>();

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

  saveLink()async{
    await controller.saveLink(url ?? "");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article Saved To Bookmarks')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Article"), centerTitle: true, actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveLink
          ),
        ],),
        body:
          SingleChildScrollView(child: Column(
            children: [
              Html(data: html),
              AnyLinkPreview(
                link: url ?? "",
                displayDirection: UIDirection.uiDirectionVertical,
                showMultimedia: true,
                bodyMaxLines: 5,
                bodyTextOverflow: TextOverflow.ellipsis,
                titleStyle: Theme.of(context).textTheme.bodyMedium,
                bodyStyle: Theme.of(context).textTheme.bodySmall,
                errorBody: '',
                errorTitle: 'Show my custom error title',
                errorWidget: Container(
                  color: Colors.grey[300],
                  child: Text('Oops!'),
                ),
                errorImage: "https://hitzvatlzhtqvmliqlna.supabase.co/storage/v1/object/public/appfiles/ic_launcher.png",
                cache: Duration(days: 7),
                backgroundColor: Theme.of(context).canvasColor,
                borderRadius: 12,
                removeElevation: false,
                userAgent: 'WhatsApp/2.21.12.21 A',
                boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
              ),
             // AnyLinkPreview(link: url ?? "")
            ],
          )));
  }
}
