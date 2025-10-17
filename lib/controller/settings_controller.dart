import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/icontroller.dart';
import 'package:pan_pocket/models/rss_categories.dart';
import 'package:pan_pocket/models/rss_link.dart';

import '../helpers/shared_preferences_helper.dart';

class SettingsController{
  var apiController = GetIt.instance<IController>(instanceName: SharedPreferencesHelper.getString("mode") ?? "cloud" );

  Future<List<RssCategories>> getRssCategories()async{
    apiController = GetIt.instance<IController>(instanceName: SharedPreferencesHelper.getString("mode") ?? "cloud" );

    var data = await apiController.getRssCategories();
      List<RssCategories> returnList = [];
    for(var result in data){
      var trttt = result["created_at"];

        returnList.add(RssCategories(Id: result["id"], CreatedAt: DateTime.parse(result["created_at"]), UserId: result["user_id"], CategoryName: result["category_name"], Archived: result["archived"]));
    }

    return returnList;
  }

  saveLinkAndGetId(String linkString)async{
    return await apiController.addRssLink(linkString);
  }

  saveCategoryLinkRel(String linkId, String categoryId )async{
    await apiController.addRssCategoryRel(linkId, categoryId);
  }

  setLinkToArchived(String linkId)async{
    await apiController.archivedRssLink(linkId);
  }

  Future<List<RssLink>> rssLinksByCategory(String categoryName)async{
    var data = await apiController.rssLinksByCategory(categoryName);
    List<RssLink> returnData = [];
    for(var d in data){
      returnData.add(RssLink(id: d["id"],linkString: d["link_string"]));
    }

    return returnData;
  }
}