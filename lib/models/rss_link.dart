import 'package:meta/meta.dart';

@immutable
class RssLink {
  final int? id;
  final DateTime? createdAt;
  final String? linkString;
  final bool archived;
  final String? userId;


  const RssLink({
    this.id,
    this.createdAt,
    this.linkString,
    this.archived = false,
    this.userId,
  });

  // Create a copy with optional overrides
  RssLink copyWith({
    int? id,
    DateTime? createdAt,
    String? linkString,
    bool? archived,
    String? userId,
    int? categoryId,
    String? categoryName,
  }) {
    return RssLink(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      linkString: linkString ?? this.linkString,
      archived: archived ?? this.archived,
      userId: userId ?? this.userId,
    );
  }

  // From a Map (e.g., from supabase client or json decode)
  factory RssLink.fromMap(Map<String, dynamic> map) {
    return RssLink(
      id: map['id'] is int ? map['id'] as int : (map['id'] as num).toInt(),
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      linkString: map['link_string'] as String?,
      archived: map['archived'] == null
          ? false
          : (map['archived'] is bool
          ? map['archived'] as bool
          : (map['archived'].toString().toLowerCase() == 'true')),
      userId: map['user_id'] as String?,

    );
  }

  // To map (for inserts/updates or JSON encoding)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'link_string': linkString,
      'archived': archived,
      'user_id': userId,
      // view fields included for convenience but can be omitted for insert

    };
  }

  // JSON helpers
  factory RssLink.fromJson(Map<String, dynamic> json) => RssLink.fromMap(json);
  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() {
    return 'RssLink(id: $id, linkString: $linkString, archived: $archived';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RssLink &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.linkString == linkString &&
        other.archived == archived &&
        other.userId == userId;

  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdAt,
      linkString,
      archived,
      userId,
    );
  }
}