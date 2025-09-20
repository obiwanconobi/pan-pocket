import 'package:pan_pocket/models/saved_links.dart';

abstract class IController {
  getLinksCollection();

  getLinks(bool archived);

  saveLink(SavedLinks slJson);
  deleteLink(String linkId);

  archiveLink(String linkId);

  restoreLink(String linkId);

  rssCategoryCount();

  getRssCategories();

  addRssCategory(Map<String, dynamic> slJson);

  getCategoryLinks();

}