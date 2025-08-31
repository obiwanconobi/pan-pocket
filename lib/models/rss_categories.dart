class RssCategories {
  final int? Id;
  final DateTime? CreatedAt;
  final String? UserId;
  final String? CategoryName;
  final bool? Archived;
  RssCategories({
    this.Id,
    this.CreatedAt,
    this.UserId,
    this.CategoryName,
    this.Archived
  });

  Map<String, dynamic> toJson() {
    return {
      'category_name': CategoryName,
      'archived': false
    };
  }
}