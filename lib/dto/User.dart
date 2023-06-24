import 'package:json_annotation/json_annotation.dart';
part 'User.g.dart';


@JsonSerializable()
class User {

  String? name;
  String? email;
  String? lastname;

  User({
    this.name, this.email, this.lastname
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}