import 'package:pan_pocket/controller/icontroller.dart';
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
    await supabase
        .from('rss_categories')
        .insert(slJson);
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

}