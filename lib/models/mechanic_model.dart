class MechanicModel {
  String name;
  String email;
  String profilePic;
  String qualification;
  String createdAt;
  String? phoneNumber;
  String? uid;

  MechanicModel(
      {required this.name,
      required this.email,
      required this.createdAt,
      required this.phoneNumber,
      required this.uid,
      required this.profilePic,
      required this.qualification});

  // from map
  factory MechanicModel.fromMap(Map<String, dynamic> map) {
    return MechanicModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      profilePic: map['profilePic'] ?? '',
      qualification: map['qualification'] ?? '',
    );
  }

  // to map
  Map<String, dynamic> toMap() {
    return {
      "qualification": qualification,
      "name": name,
      "email": email,
      "profilePic": profilePic,
      "uid": uid,
      "phoneNumber": phoneNumber,
      "createdAt": createdAt,
    };
  }
}
