class RssCategoryLinks {
  final String? CategoryName;
  final String? LinkString;
  RssCategoryLinks({
    this.CategoryName,
    this.LinkString
  });

  Map<String, dynamic> toJson() {
    return {
      'category_name': CategoryName,
      'archived': false
    };
  }
}