import 'package:flutterdb/flutterdb.dart';
import 'package:pan_pocket/controller/icontroller.dart';
import 'package:pan_pocket/models/saved_links.dart';

import '../main.dart';

class LocalDbController implements IController{
  final db = FlutterDB();
//  late Collection links;

  @override
  getLinksCollection()async{
   // links = await db.collection('links');
  }

  @override
  getLinks(bool archived)async{
    Collection links = await db.collection('links');
    return await links.find({'archived': archived});

    return await supabase.from('saved_links')
        .select()
        .eq('deleted', false)
        .eq('archived',archived);
  }

  @override
  saveLink(SavedLinks input)async{
    var slJson = input.toLocalDbJson();
    Collection links = await db.collection('links');
      try{
        var ff = await links.insert(slJson);
      }catch(e){
        var ff = e.toString();
        if(ff.isNotEmpty){

        }
      }


  }

  @override
  deleteLink(String linkId)async{
    Collection links = await db.collection('links');

    await links.updateById(linkId.toString(), {'deleted': true});


  }
  @override
  archiveLink(String linkId)async{
    Collection links = await db.collection('links');

    await links.updateById(linkId.toString(), {'archived': true});
  }
  @override
  restoreLink(String linkId)async{
    Collection links = await db.collection('links');

    await links.updateById(linkId.toString(), {'archived': false});
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
  getCategoryLinks() {
    // TODO: implement getCategoryLinks
    throw UnimplementedError();
  }

}