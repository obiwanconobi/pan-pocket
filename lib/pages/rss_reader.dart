import 'package:flutter/material.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<List<RssItem>> getFeedAsync()async{
    var url = SharedPreferencesHelper.getString("rssUrl") ?? "";
    var xmlFeed = await http.get(Uri.parse(url));
    return new RssFeed.parse(xmlFeed.body).items;
  }

  getFeed()async{
    futureRssItems = getFeedAsync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getImageLink(RssItem item){

    if(item.media!.contents.length > 0){
      var ff = Uri.tryParse(item.media!.contents.first.url!);
      if(ff != null){
        return item.media!.contents.first.url;
      }
    }

    if(item.media!.thumbnails.length > 0){
      var fff = Uri.tryParse(item.media!.thumbnails.first.url!);
      if(fff != null){
        return item.media!.thumbnails.first.url;
      }
    }
    return "";
  }

  Future<void> refresh()async{
    setState(() {
      futureRssItems = getFeedAsync();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("RSS"), centerTitle: true,),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
          future: futureRssItems,
            builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              //child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Center(
                  child: Text('Error: No URL Specified'),
                ),
                TextButton(onPressed: refresh, child: Text('Refresh'))
              ],
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Image.network(getImageLink(rssItems[index])),
                        ListTile(
                          title: Text(rssItems[index].title!),
                          subtitle: Text(rssItems[index].description!.replaceAll("\n", "").replaceAll("                        ", "")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            TextButton(
                              child: const Text('View'),
                              onPressed: () {
                                /* ... */
                              },
                            ),
                            SizedBox(width: 2.w,),
                            TextButton(
                              child: const Text('Visit'),
                              onPressed: () {
                                launchUrl(Uri.parse(rssItems[index].link!));
                                /* ... */
                              },
                            ),
                          ],),
                        )
                      ],
                    ),
                  );
                }
            );
          }
        }),
      ),
    );
  }
}
