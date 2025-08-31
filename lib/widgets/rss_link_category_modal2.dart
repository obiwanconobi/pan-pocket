import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/models/rss_categories.dart';

import '../controller/api_controller.dart';

class RssLinkCategoryModal2 extends StatefulWidget {
  const RssLinkCategoryModal2({super.key});

  @override
  State<RssLinkCategoryModal2> createState() => _RssLinkCategoryModalState();
}

class _RssLinkCategoryModalState extends State<RssLinkCategoryModal2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  var apiController = GetIt.instance<ApiController>();
  late Future<List<RssCategories>> categoryFuture;
  TextEditingController rssUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryFuture = GetCategories();
    _controller = AnimationController(vsync: this);
  }

  Future<List<RssCategories>> GetCategories() async {
    List<RssCategories> cl = [];
    var categories = await apiController.getRssCategories();
    for (var res in categories) {
      cl.add(RssCategories(Id: res["id"],
          CreatedAt: DateTime.parse(res["created_at"]),
          CategoryName: res["category_name"]));
    }

    return cl;
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveUrl()async{
    var sl = RssCategories(CategoryName: rssUrlController.text,);
    var slJson = sl.toJson();
    await apiController.addRssCategory(slJson);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: rssUrlController,),
        TextButton(child: Text('Save'), onPressed: saveUrl,),
        FutureBuilder(
            future: categoryFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Text('Offline')
                );
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<RssCategories> categories = snapshot!.data!;
              return ListView.builder(shrinkWrap: true,
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Text(categories[index].CategoryName!);
                  });
            }),
      ],
    );
  }
}