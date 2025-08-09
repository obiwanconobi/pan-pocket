import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pan_pocket/helpers/screen_helper.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:pan_pocket/pages/rss_article_page.dart';
import 'package:rss_dart/dart_rss.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
class RssReader extends StatefulWidget {
  const RssReader({super.key});

  @override
  State<RssReader> createState() => _RssReaderState();
}

class _RssReaderState extends State<RssReader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<String> urls = SharedPreferencesHelper.getStringList('urlList') ?? [];
  late Future<List<RssItem>> futureRssItems;
  List<RssItem> rssItems = [];
  ScreenHelper screenHelper = ScreenHelper();

  @override
  void initState() {
    super.initState();
    getFeed();
    _controller = AnimationController(vsync: this);
  }


  parseDateTime(String myDate){
        String month = "";
        String hour = myDate.substring(17, 25); //Get the hour section [22:00:00]

        String day = myDate.substring(5, 7); //Get the day section [28]

        if(myDate.substring(8, 11) == 'Jan'){ //Converting the month Section
          month = '01';
        } else if(myDate.substring(8, 11) == 'Feb'){
          month = '02';
        } else if(myDate.substring(8, 11) == 'Mar'){
          month = '03';
        } else if(myDate.substring(8, 11) == 'Apr'){
          month = '04';
        } else if(myDate.substring(8, 11) == 'May'){
          month = '05';
        } else if(myDate.substring(8, 11) == 'Jun'){
          month = '06';
        } else if(myDate.substring(8, 11) == 'Jul'){
          month = '07';
        } else if(myDate.substring(8, 11) == 'Aug'){
          month = '08';
        } else if(myDate.substring(8, 11) == 'Sep'){
          month = '09';
        } else if(myDate.substring(8, 11) == 'Oct'){
          month = '10';
        } else if(myDate.substring(8, 11) == 'Nov'){
          month = '11';
        } else if(myDate.substring(8, 11) == 'Dec'){
          month = '12';
        }

        String year = myDate.substring(12, 16); //Get the year section

        String date = year + '-' + month + '-' + day + ' ' + hour; //Combine them

        DateTime parsedDate = DateTime.parse(date); //parsed it.
        return parsedDate;
  }

  Future<List<RssItem>> getFeedAsync()async{
   // var url = SharedPreferencesHelper.getString("rssUrl") ?? "";
    List<RssItem> list = [];
    for(var url in urls){
      try{
        var xmlFeed = await http.get(Uri.parse(url));
        var test = RssFeed.parse(xmlFeed.body);
        list.addAll(RssFeed.parse(xmlFeed.body).items);
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to parse: $url')),
        );
      }

    }
    list.sort((a,b) => parseDateTime(b.pubDate!).compareTo(parseDateTime(a.pubDate!)));
    return list;
  }

  getFeed()async{
    futureRssItems = getFeedAsync();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  extractText(String description, String title){
    description = cleanText(description);
    RegExp exp = new RegExp(r'<img[^>]*>');
    var ff = description.replaceAll(exp, "");
    ff = Bidi.stripHtmlIfNeeded(ff);
    ff = ff.trim();
    if(ff.startsWith(title)){
      ff = ff.replaceRange(0, title.length, "");
    }
    var portrait = screenHelper.screenWidthMoreThanHeight(context);
    int maxLength = portrait ? 280 : 140;
    if(ff.length < maxLength){
      maxLength = ff.length;
    }
    return ff.substring(0, maxLength);
  }

  extractImage(String description){
    RegExp exp = new RegExp(r'<img[^>]*>');
    if(exp.hasMatch(description)){
      var result = exp.firstMatch(description);

      RegExp urlRegEx = new RegExp(r'src="([^"]+)"');
      if(urlRegEx.hasMatch(result![0]!)){
        var urls = urlRegEx.firstMatch(result![0]!);
        var ree = urls![1];
        return ree;
      }
    }
   return null;
  }


  getImageLink(RssItem item){
    if(item.media!.contents.length > 0){

      if(item.media!.contents.first.url != null){
        var ff = Uri.tryParse(item.media!.contents.first.url!);
        if(ff != null){
          return item.media!.contents.first.url;
        }
      }
    }

    if(item.media!.thumbnails.length > 0){
      var fff = Uri.tryParse(item.media!.thumbnails.first.url!);
      if(fff != null){
        return item.media!.thumbnails.first.url;
      }
    }
    if(item.content == null){
      return extractImage(item.description!);
    }
    if(item.content!.images.length > 0){
      var ffff = Uri.tryParse(item.content!.images.first.toString());
      if(ffff != null){
        return item.content!.images.first.toString();
      }
    }

    if(item.enclosure != null){
      return item.enclosure!.url.toString();
    }


    return null;
  }

  Future<void> refresh()async{
    urls = SharedPreferencesHelper.getStringList('urlList') ?? [];
    setState(() {
      futureRssItems = getFeedAsync();
    });
  }
  
  getHtmlText(RssItem item){
    if(item.content != null){
      return item.content!.value;
    }

    return item.description;
  }

  getDomain(String url){
    RegExp exp = RegExp(r'^(?:https?://)?(?:www\.)?([^/]+)');
    if(exp.hasMatch(url)){
      var domain = exp.firstMatch(url);
      var fff = domain![1];
      return fff;
    }
  }

  cleanText(String text){
    String val = 'â';
    return text.replaceAll(val, "'").replaceAll('\n', '').trim();
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
                        if(getImageLink(rssItems[index]) != null)Image.network(getImageLink(rssItems[index]), fit: BoxFit.cover),
                        ListTile(
                          title: Text(cleanText(rssItems[index].title!)),
                          subtitle: Text(extractText(rssItems[index].description!, rssItems[index].title!)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(getDomain(rssItems[index].link!), overflow: TextOverflow.clip, style: Theme.of(context).textTheme.bodySmall,),
                                  Text(rssItems[index].pubDate!.substring(0, 16), overflow: TextOverflow.clip, style: Theme.of(context).textTheme.bodySmall,)
                                ],
                              ),
                            Spacer(),
                            TextButton(
                              child: const Text('View'),
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => RssArticlePage(htmlText: getHtmlText( rssItems[index]), urlText: rssItems[index].link!,)),
                                );


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
