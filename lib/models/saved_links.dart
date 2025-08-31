class SavedLinks {
  final String? link_string;
  final String? link_title;
  final DateTime? data_added;
  final bool? archived;

  SavedLinks({
    this.link_string,
    this.link_title,
    this.data_added,
    this.archived
  });

  Map<String, dynamic> toJson() {
    return {
      'link_string': link_string,
      'link_title': link_title,
      'archived': archived.toString()
    };
  }

  Map<String, dynamic> toLocalDbJson() {
    return {
      'link_string': link_string,
      'link_title': link_title,
      'archived': archived,
      'date_added': data_added.toString()
    };
  }
}