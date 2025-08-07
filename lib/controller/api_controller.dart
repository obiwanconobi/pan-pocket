import '../main.dart';

class ApiController{

  getLinks(bool archived)async{
    return await supabase.from('saved_links')
        .select()
        .eq('deleted', false)
        .eq('archived',archived);
  }

  saveLink(Map<String, dynamic> slJson)async{
   await supabase
        .from('saved_links')
        .insert(slJson);
  }

  deleteLink(int linkId)async{
    await supabase.from('saved_links')
        .update({'deleted': true})
        .eq('id', linkId);
  }

  archiveLink(int linkId)async{
    await supabase.from('saved_links')
        .update({'archived': true})
        .eq('id', linkId);
  }

  restoreLink(int linkId)async{
    await supabase.from('saved_links')
        .update({'archived': false})
        .eq('id', linkId);
  }

}