import 'dart:async';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sharing_intent/flutter_sharing_intent.dart';
import 'package:flutter_sharing_intent/model/sharing_file.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_it/get_it.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pan_pocket/controller/home_controller.dart';
import 'package:pan_pocket/models/links.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late StreamSubscription _intentDataStreamSubscription;
  late AnimationController _controller;
  var controller = GetIt.instance<HomeController>();

  List<Links> linksList = [];
  late Future<List<Links>> futureLinksList;
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
    await controller.saveLink(md);
    setState(() {
      Navigator.of(context).pop();
      futureLinksList = controller.onInit();
    });
  }

  deleteLink(int id)async{
      await controller.deleteLink(id);
  }

  linkAction()async{

  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    futureLinksList = controller.onInit();
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
                                  displayDirection: UIDirection.uiDirectionHorizontal,
                                  showMultimedia: false,
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
                                  cache: Duration(days: 7),
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
      });

  }



  @override
  void dispose() {
    _intentDataStreamSubscription.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> onRefresh()async{
    futureLinksList = controller.onInit();
  }

  launchLink(String url)async{
    var uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
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
          child: FutureBuilder(
            future:futureLinksList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: Text('Offline')
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                linksList = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: linksList.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Slidable(
                        key: Key(linksList[index].LinkId.toString()),
                        startActionPane: ActionPane(
                          // A motion is a widget used to control how the pane animates.
                          motion: const ScrollMotion(),

                          // A pane can dismiss the Slidable.
                          dismissible: DismissiblePane(onDismissed: () {
                            deleteLink(linksList[index].LinkId!);
                            setState(() {
                              linksList.remove(linksList[index]);
                            });
                          }),

                          // All actions are defined in the children parameter.
                          children: [
                            // A SlidableAction can have an icon and/or a label.
                            SlidableAction(
                              onPressed: (BuildContext context) {
                                deleteLink(linksList[index].LinkId!);
                              },
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                             // label: 'Delete',
                            ),
                          ],
                        ),
                        child: AnyLinkPreview(
                          link: linksList[index].Link!,
                          displayDirection: UIDirection.uiDirectionHorizontal,
                          showMultimedia: false,
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
                          cache: Duration(days: 7),
                          backgroundColor: Colors.grey[300],
                          borderRadius: 12,
                          removeElevation: false,
                          userAgent: 'WhatsApp/2.21.12.21 A',
                          boxShadow: [BoxShadow(blurRadius: 3, color: Colors.grey)],
                          onTap: () {launchLink(linksList[index].Link!);}, // This disables tap event
                        ),);
                    });
              })),
    );
  }
}
