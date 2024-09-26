import 'package:news_app/model/groubs.dart';
import 'package:news_app/model/users.dart';

class PhoneProperties {
  final List<Groups> groups;
  UserType userType;

  PhoneProperties({required this.groups, required this.userType});

  Map<String, dynamic> toMap() {
    return {
      'userType': userType.name,
      'groups': groups.map((group) => group.toMap()).toList(),
    };
  }

  factory PhoneProperties.fromMap(Map<String, dynamic> map) {
    return PhoneProperties(
      groups: List<Groups>.from(map['groups']?.map((x) => Groups.fromMap(x))),
      userType: UserType.values
          .byName(map['userType']), // Convert string back to enum
    );
  }
}
