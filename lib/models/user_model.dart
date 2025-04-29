class UserModel {
  late String email;
  late String name;
  late String phone;
  late String uId;
  late String image;
  late String coverImage;
  late String bio;
  late bool isEmailVerified;
  UserModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.uId,
    required this.image,
    required this.coverImage,
    required this.bio,
    required this.isEmailVerified,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    uId = json['uId'];
    image = json['image'];
    coverImage = json['coverImage'];
    bio = json['bio'];
    isEmailVerified = json['isEmailVerified'];
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'uId': uId,
      'image': image,
      'coverImage': coverImage,
      'bio': bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}
