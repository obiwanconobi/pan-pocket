import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pan_pocket/controller/home_controller.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:pan_pocket/pages/links_page.dart';
import 'package:sizer/sizer.dart';
import 'dart:io' show Platform;


class HomeLinksPage extends StatefulWidget {
  HomeLinksPage({super.key}){

  }


  @override
  State<HomeLinksPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeLinksPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var controller = GetIt.instance<HomeController>();
  var textController = TextEditingController();


  Key _linksPageKey = UniqueKey(); // Initialize with a unique key


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> onRefresh()async{
    // linksList.clear();
    setState(() {
      _linksPageKey = UniqueKey();
    });
  }

  getCacheValue(){
    return SharedPreferencesHelper.getInt('cacheValue') ?? 3;
  }

  saveLink(Metadata md)async{
    await controller.saveLink(md);
    setState(() {
      Navigator.of(context).pop();
    });
  }

  late Future<Metadata?> futureLink;
  getMetadata(String link){
    if(!link.startsWith("http")){
      link = "https://" + link;
    }
    futureLink = AnyLinkPreview.getMetadata(link: link, cache: const Duration(days: 2));
  }

  saveLinks(String link){
    getMetadata(link);

    setState(() {
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
                            AnyLinkPreview(
                              link: md.url!,
                              displayDirection: UIDirection.uiDirectionVertical,
                              showMultimedia: true,
                              bodyMaxLines: 5,
                              bodyTextOverflow: TextOverflow.ellipsis,
                              titleStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              bodyStyle: TextStyle(color: Colors.grey, fontSize: 12),
                              errorBody: 'Show my custom error body',
                              errorTitle: 'Show my custom error title',
                              errorWidget: Container(
                                color: Colors.grey[300],
                                child: Text('Oops!'),
                              ),
                              errorImage: "https://google.com/",
                              cache: Duration(days: getCacheValue()),
                              backgroundColor: Colors.grey[300],
                              borderRadius: 12,
                              removeElevation: false,
                              userAgent: 'WhatsApp/2.21.12.21 A',
                              boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                              onTap: () {}, // This disables tap event
                            )
                            //  Text(md!.title!),
                            // Text(md!.desc ?? ""),

                          ],
                        ),
                      ),
                    );
                  }
              )
      );
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title:Text("Pan Pocket"),
          actions: !Platform.isAndroid ? <Widget>[
            IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: onRefresh
            ),
          ] : null
        ),
        floatingActionButton: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, // circular shape
              color: Theme.of(context).focusColor
              ),

            child: IconButton(onPressed: (){ _displayTextInputDialog(context); }, icon: Icon(Icons.add, color: Colors.white,),)),
        body: RefreshIndicator(
            onRefresh: onRefresh,
            child: LinksPage(archived: false, key: _linksPageKey,))
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    String valueText = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Paste Link Here'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                   valueText = value;
                });
              },
              controller: textController,
              decoration: InputDecoration(hintText: "Text Field in Dialog"),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    saveLinks(valueText);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
