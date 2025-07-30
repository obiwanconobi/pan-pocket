import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pan_pocket/main.dart';
import 'package:pan_pocket/models/links.dart';
import 'package:pan_pocket/models/saved_links.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late StreamSubscription _intentDataStreamSubscription;
  late AnimationController _controller;

  List<Links> linksList = [];
  late Future<Metadata?> futureLink;

  getMetadata(String link){
    futureLink = AnyLinkPreview.getMetadata(link: link, cache: const Duration(days: 2));
  }

  ParseLink(String link)async{
    try{
      futureLink = AnyLinkPreview.getMetadata(link: link, cache: const Duration(days: 2));

      var metaData = await AnyLinkPreview.getMetadata(link: link, cache: const Duration(days: 2));
      return Links(Title: metaData!.title, Link: link, Info: metaData!.desc);
    }catch(e){

    }
    return Links();
  }

  addLinkToList(String link)async{
    var parsed = await ParseLink(link);
    setState(() {
      linksList.add(parsed);
    });

  }

  saveLink(Metadata md)async{
    var sl = SavedLinks(link_title: md.title, link_string: md.url, archived: false, data_added: DateTime.now());
    var ff = sl.toJson();
    await supabase
        .from('saved_links')
        .insert(ff);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    getLinks();
    _intentDataStreamSubscription = FlutterSharingIntent.instance.getMediaStream()

        .listen((List<SharedFile> value) {
      setState(() {
       // list = value;
        addLinkToList(value.first.value!);
      });
      print("Shared: getMediaStream ${value.map((f) => f.value).join(",")}");
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });
    



    // For sharing images coming from outside the app while the app is closed
    FlutterSharingIntent.instance.getInitialSharing().then((List<SharedFile> value) async{
      print("Shared: getInitialMedia ${value.map((f) => f.value).join(",")}");
      if(value.isNotEmpty){

        getMetadata(value.first.value!);
        setState(() {

          addLinkToList(value.first.value!);
          showMaterialModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) =>
                  FutureBuilder(
                      future: futureLink,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                              child: Text('Offline')
                          );}
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        var md = snapshot.data!;
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 50, 0, 50),
                            child: Column(
                              children: [
                                TextButton(onPressed:() => {saveLink(md)}, child: Text("Save"),),
                                Text(md!.title!),
                                Text(md!.desc!),

                              ],
                            ),
                          ),
                        );
                      }
                  )
          );


        });
      }
      });

  }

  getLinks()async{
    final data = await supabase.from('saved_links').select();
  }

  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh()async{

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pan Pocket")
      ),
      body: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: linksList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  return Text(linksList[index].Title!);
                })
          )),
    );
  }
}
