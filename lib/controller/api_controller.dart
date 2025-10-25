import 'package:pan_pocket/controller/icontroller.dart';
import 'package:pan_pocket/models/rss_categories.dart';
import 'package:pan_pocket/models/rss_category_links.dart';
import 'package:pan_pocket/models/saved_links.dart';

import '../main.dart';

class ApiController implements IController{
  @override
  getLinks(bool archived)async{
    return await supabase.from('saved_links')
        .select()
        .eq('deleted', false)
        .eq('archived',archived);
  }
  @override
  saveLink(SavedLinks input)async{
    var slJson = input.toJson();
   await supabase
        .from('saved_links')
        .insert(slJson);
  }
  @override
  deleteLink(String linkId)async{
    await supabase.from('saved_links')
        .update({'deleted': true})
        .eq('id', linkId);
  }
  @override
  archiveLink(String linkId)async{
    await supabase.from('saved_links')
        .update({'archived': true})
        .eq('id', linkId);
  }
  @override
  restoreLink(String linkId)async{
    await supabase.from('saved_links')
        .update({'archived': false})
        .eq('id', linkId);
  }
  @override
  rssCategoryCount()async{
    await supabase.from('rss_categories')
        .count();
  }
  @override
  getRssCategories()async{
    return await supabase.from('rss_categories')
        .select()
        .eq('archived', false);

  }
  @override
  addRssCategory(Map<String, dynamic> slJson)async{

    List<Map<String, dynamic>> data = [];

    data = await supabase
          .from('rss_categories')
          .insert(slJson)
          .select();

    return data[0]["id"];
  }

  @override
  getLinksCollection() {
    // TODO: implement getLinksCollection
    throw UnimplementedError();
  }

  @override
  getCategoryLinks()async {
    // TODO: implement getCategoryLinks
    var result = await supabase.from('rss_category_links').select();
    List<RssCategoryLinks> linkList = []; 
    for(var r in result){
      linkList.add(RssCategoryLinks(CategoryName: r["category_name"], LinkString: r["link_string"]));
    }
    return linkList;
  }

  @override
  addRssCategoryRel(String link_id, String category_id) async{
    // TODO: implement addRssCategoryRel
    var catId = await supabase.from('rss_categories').select().eq('category_name', category_id);

    var json = {
      "link_id":link_id,
      "category_id": catId.first["id"]
    };
    await supabase.from("rss_categories_links_rel").insert(json);
  }

  @override
  addRssLink(String linkString)async {
    // TODO: implement addRssLink
  var rssJson = {"link_string": linkString};
    var ff = await supabase.from("rss_links").insert(rssJson).select("id");
    return ff[0]["id"];
  }

  @override
  rssLinksByCategory(String category_name) async{
    // TODO: implement rssLinksByCategory

    var data = await supabase.from('v_rss_links_by_category').select().eq('category_name', category_name).eq('archived', false);
  return data;
  }

  @override
  archivedRssLink(String link_id)async {
    // TODO: implement archivedRssLink
    await supabase.from("rss_links").update({"archived": true}).eq('id', link_id);
  }

}