import 'package:news_app/constant.dart';

class Groups {
  String id = '';
  String name = '';
  String? description;
  String? picture;
  final List<String> members;

  Groups(
      {required this.id,
      required this.name,
      required this.description,
      this.members = const [],
      this.picture = groupImage});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'picture': picture,
      'members': members,
    };
  }

  Groups.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        name = map['name'] ?? '',
        description = map['description'] ?? '',
        picture = map['picture'],
        members = List<String>.from(map['members'] ?? []);

  Groups copyWith({
    String? id,
    String? name,
    String? description,
    String? picture,
    List<String>? members,
  }) {
    return Groups(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      picture: picture ?? this.picture,
      members: members ?? this.members,
    );
  }
}
