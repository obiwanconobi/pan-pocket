import 'package:any_link_preview/any_link_preview.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/api_controller.dart';
import 'package:pan_pocket/controller/icontroller.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';

import '../models/saved_links.dart';

class RssArticleController{
  var apiController = GetIt.instance<IController>(instanceName: SharedPreferencesHelper.getString("mode") ?? "cloud" );

  saveLink(String url)async{
    var md = await AnyLinkPreview.getMetadata(link: url);
    var sl = SavedLinks(link_title: md!.title, link_string: md.url, archived: false, data_added: DateTime.now());
    await apiController.saveLink(sl);
  }
}