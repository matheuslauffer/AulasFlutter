enum UserType {PARTICULAR, PROFESSIONAL}

class User{
  String name;
  String email;
  String password;

  String phone;

  UserType userType = UserType.PARTICULAR;

  User({this.email, this.name, this.password});
}