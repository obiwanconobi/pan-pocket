import '../main.dart';

class ApiController{

  getLinks()async{
    return await supabase.from('saved_links')
        .select()
        .eq('archived',false);
  }

  saveLink(Map<String, dynamic> slJson)async{
   await supabase
        .from('saved_links')
        .insert(slJson);
  }

  deleteLink(int linkId)async{
    await supabase.from('saved_links')
        .update({'archived': true})
        .eq('id', linkId);
  }

}