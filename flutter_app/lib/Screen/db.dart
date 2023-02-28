class UserModel {
  String? uid;
  String? email;
  String? fullname;
  String? contact;

  UserModel({this.uid, this.email, this.fullname, this.contact});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      fullname: map['fullName'],
      contact: map['Contact No'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullname,
      'Contact No': contact,
    };
  }
}
