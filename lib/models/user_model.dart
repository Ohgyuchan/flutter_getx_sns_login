class UserModel {
  const UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.shortDesc,
    required this.followings,
    required this.followers,
  });

  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String shortDesc;
  final List followings;
  final List followers;
}
