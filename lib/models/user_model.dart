class UserModel {
  String uid, name, companyName, phoneNumber, city;
  UserModel({
    required this.uid,
    required this.name,
    this.companyName = 'none',
    required this.phoneNumber,
    required this.city,
  });
}
