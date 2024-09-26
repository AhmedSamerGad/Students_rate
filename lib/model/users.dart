class Users {
  String id = '';
  String? name;
  String phoneNumber = '';
  List<String> groups = [];
  String? image;
  UserType userType = UserType.student;

  Users(this.id, this.name, this.phoneNumber, this.groups, this.userType);
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'groups': groups,
      'image': image,
      'userType': userType.name,
    };
  }

  Users.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? '',
        name = map['name'] ?? '',
        phoneNumber = map['phoneNumber'] ?? '',
        groups = List<String>.from(map['groups'] ?? []),
        image = map['image'] ?? '',
        userType = UserType.values.firstWhere(
          (type) => type.name == map['userType'],
          orElse: () => UserType.student,
        );
}

enum UserType { admin, leader, supervisuor, student }
