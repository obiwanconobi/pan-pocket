import 'package:flutter/material.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:http/http.dart' as http;
class RssReader extends StatefulWidget {
  const RssReader({super.key});

  @override
  State<RssReader> createState() => _RssReaderState();
}

class _RssReaderState extends State<RssReader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<List<RssItem>> futureRssItems;
  List<RssItem> rssItems = [];

  @override
  void initState() {
    super.initState();
    getFeed();
    _controller = AnimationController(vsync: this);
  }

  getFeedAsync()async{
    var xmlFeed = await http.get(Uri.parse("https://feeds.arstechnica.com/arstechnica/index"));
    return new RssFeed.parse(xmlFeed.body).items;
  }

  getFeed()async{
    futureRssItems = await getFeedAsync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureRssItems,
        builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          //child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else if (!snapshot.hasData) {
        return Center(
          child: Text('no_songs_error'),
        );
      } else {
        rssItems = snapshot.data!;
        return ListView.builder(
            shrinkWrap: true,
            itemCount: rssItems.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Text(rssItems[index].title!);
            }
        );
      }
    });
  }
}
