import 'package:any_link_preview/any_link_preview.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/api_controller.dart';

import '../models/saved_links.dart';

class RssArticleController{
  var apiController = GetIt.instance<ApiController>();

  saveLink(String url)async{
    var md = await AnyLinkPreview.getMetadata(link: url);
    var sl = SavedLinks(link_title: md!.title, link_string: md.url, archived: false, data_added: DateTime.now());
    var slJson = sl.toJson();
    await apiController.saveLink(slJson);
  }
}