import 'package:any_link_preview/any_link_preview.dart';
import 'package:get_it/get_it.dart';
import 'package:pan_pocket/controller/api_controller.dart';
import 'package:pan_pocket/models/links.dart';

import '../models/saved_links.dart';

class HomeController{

  var apiController = GetIt.instance<ApiController>();
  Future<List<Links>> onInit()async {
    var data = await apiController.getLinks();
    List<Links> linksList = [];
    for(var d in data){
      var link = Links(LinkId: d['id'],Title: d['link_title'], Link: d["link_string"]);
      linksList.add(link);
    }
    return linksList;
  }

  saveLink(Metadata md)async{
    var sl = SavedLinks(link_title: md.title, link_string: md.url, archived: false, data_added: DateTime.now());
    var slJson = sl.toJson();
    await apiController.saveLink(slJson);

  }

  deleteLink(int LinkId)async{
    await apiController.deleteLink(LinkId);
  }
}