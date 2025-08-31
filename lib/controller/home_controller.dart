import 'package:any_link_preview/any_link_preview.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/api_controller.dart';
import 'package:pan_pocket/controller/icontroller.dart';
import 'package:pan_pocket/helpers/shared_preferences_helper.dart';
import 'package:pan_pocket/models/links.dart';

import '../models/saved_links.dart';

class HomeController{

  var apiController = GetIt.instance<IController>(instanceName: SharedPreferencesHelper.getString("mode") ?? "cloud" );
  Future<List<Links>> onInit(bool archived)async {
    apiController = GetIt.instance<IController>(instanceName: SharedPreferencesHelper.getString("mode") ?? "cloud" );
    var data = await apiController.getLinks(archived);
    List<Links> linksList = [];
    for(var d in data){
      var link = Links(LinkId: d['id'].toString(),Title: d['link_title'], Link: d["link_string"], DateAdded: DateTime.parse(d["date_added"]), Archived: d["archived"]);
      linksList.add(link);
    }
    linksList.sort((a,b) => a.DateAdded!.compareTo(b.DateAdded!));
    return linksList;
  }

  saveLink(Metadata md)async{
    var sl = SavedLinks(link_title: md.title, link_string: md.url, archived: false, data_added: DateTime.now());
    await apiController.saveLink(sl);

  }

  deleteLink(String LinkId)async{
    await apiController.deleteLink(LinkId);
  }

  archiveLink(String LinkId)async{
    await apiController.archiveLink(LinkId);
  }

  restoreLink(String LinkId)async{
    await apiController.restoreLink(LinkId);
  }
}