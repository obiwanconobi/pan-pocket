import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:pan_pocket/controller/settings_controller.dart';
import 'package:pan_pocket/helpers/screen_helper.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:pan_pocket/models/rss_categories.dart';
import 'package:pan_pocket/models/rss_link.dart';
import 'package:pan_pocket/widgets/rss_link_category_modal.dart';
import 'package:sizer/sizer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  ScreenHelper screenHelper = ScreenHelper();

  var controller = GetIt.instance<SettingsController>();

  TextEditingController rssUrlController = TextEditingController();
  //List<String> urlList = SharedPreferencesHelper.getStringList("urlList") ?? [];
  var defaultCat = SharedPreferencesHelper.getString("defaultCat") ?? "General";
  late Future<List<RssCategories>> futureCats;
  String currentCategory = "General";
  late Future<List<RssLink>> futureLinks;
  List<RssLink> urlList = [];
  @override
  void initState(){
    super.initState();
    _controller = AnimationController(vsync: this);
    rssUrlController.text = SharedPreferencesHelper.getString("rssUrl") ?? "Set Url";
   // var ffcontroller = ApiController();
    futureCats =  controller.getRssCategories();
   // getLinks();
    futureLinks = controller.rssLinksByCategory("General");


    getPreferences();
  }

  getLinks([String catName = "General"]){
    urlList.clear();
    futureLinks = controller.rssLinksByCategory(catName);
  }

  getPreferences()async{
  //  perfs = await SharedPreferences.getInstance();

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _toggleTheme()async{
    AdaptiveTheme.of(context).toggleThemeMode();
  }

  setCacheValue(int cache){
    SharedPreferencesHelper.setInt('cacheValue', cache);
  }

  getCacheValue(){
    return SharedPreferencesHelper.getInt('cacheValue') ?? 3;
  }


  saveUrl()async{
  //  SharedPreferencesHelper.setString("rssUrl", rssUrlController.text);

    var linkId = await controller.saveLinkAndGetId(rssUrlController.text);
    controller.saveCategoryLinkRel(linkId.toString(), currentCategory.toString());

    setState(() {
     // urlList.add(rssUrlController.text);
    });

   // SharedPreferencesHelper.setStringList('urlList', urlList);
  }

  removeUrlFromList(int id){
    setState(() {
   //   urlList.remove(url);
      controller.setLinkToArchived(id.toString());
    });
   // SharedPreferencesHelper.setStringList('urlList', urlList);
  }

  loadRssLinkModal(){
    Navigator.push(context,
      MaterialPageRoute(builder: (context) => RssLinkCategoryModal()),
    );
  }

  setCurrentCategory(String newCat){
    currentCategory = newCat;
    setState(() {
      getLinks(currentCategory);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true,title: const Text('Settings'),
    actions: <Widget>[
    IconButton(
    icon: const Icon(Icons.sunny),
    onPressed: _toggleTheme
    ),
    ],),
    body: Center(
      child: SizedBox(
        width: screenHelper.screenWidthMoreThanHeight(context) ? 50.w : 100.w,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Cache Days: '),
                NumberPicker(
                  value: getCacheValue(),
                  minValue: 0,
                  maxValue: 13,
                  onChanged: (value) => setState(() => setCacheValue(value)),
                ),
                Tooltip(
                  child: Icon(Icons.info, size: 30.0),
                  message: 'Set to 0 to clear cache',
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(20),
                  showDuration: Duration(seconds: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.9),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: true,
                  verticalOffset: 20,
                )
              ],
            ),
            FutureBuilder(
                future: futureCats,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: Text('Offline')
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var md = snapshot.data!;
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: md.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () => {setCurrentCategory(md[index].CategoryName!)},
                                child: Text(md[index]!.CategoryName!)),
                          );
                        }),
                  );
                }
            ),
            TextField(controller: rssUrlController,),
            TextButton(child: Text('Save'), onPressed: saveUrl,),
            FutureBuilder(
              future: futureLinks,
              builder: (context, snapshot){
                if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                child: Text('Offline')
                );
                }
                if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
                }
            urlList = snapshot.data!;
                return Container(
                height: 30.h,
                width: screenHelper.screenWidthMoreThanHeight(context) ? 50.w : 100.w,
                  child: ListView.builder(
                  itemCount: urlList.length,
                  itemBuilder: (context, index){
                    return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                      width: 70.w,
                      child: Text(urlList[index].linkString!, overflow: TextOverflow.ellipsis,maxLines: 1,)),
                      IconButton(onPressed:()=>{removeUrlFromList(urlList[index].id!)}, icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.secondary, size:30),),
                      IconButton(onPressed:loadRssLinkModal, icon: Icon(Icons.settings, color: Theme.of(context).colorScheme.secondary, size:30),),
                      ],
                    );
                  }),
            );
            }
            )
          //  RssLinkCategoryModal2()
          ],
        ),
      ),
    ),);
  }
}
