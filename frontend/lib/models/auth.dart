class Auth {
  final String email;
  final String nickname;
  final DateTime? birth;
  final int? gender; // 0 또는 1로 구분
  final int? height;
  final int? weight;
  final MemberImage? memberImage;
  final String joinType;

  Auth({
    required this.email,
    required this.nickname,
    this.birth,
    this.gender,
    this.height,
    this.weight,
    this.memberImage,
    required this.joinType,
  });

  factory Auth.fromJson(Map<String, dynamic> json) {
    return Auth(
      email: json['email'],
      nickname: json['nickname'],
      birth: json['birth'] != null ? DateTime.parse(json['birth']) : null,
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      joinType: json['joinType'],
      memberImage: json['memberImage'] != null
          ? MemberImage.fromJson(json['memberImage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'nickname': nickname,
      'birth': birth != null
          ? '${birth!.year}-${birth!.month.toString().padLeft(2, '0')}-${birth!.day.toString().padLeft(2, '0')}'
          : null,
      'gender': gender,
      'height': height,
      'weight': weight,
      'joinType': joinType,
      'memberImage': memberImage?.toJson(),
      // 'memberImage': memberImage != null ? memberImage!.toJson() : null,
    };
  }
}

class MemberImage {
  final int? memberId;
  final String? url;
  final String? path;

  MemberImage({
    this.memberId,
    this.url,
    this.path,
  });

  factory MemberImage.fromJson(Map<String, dynamic> json) {
    return MemberImage(
      memberId: json['memberId'],
      url: json['url'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'url': url,
      'path': path,
    };
  }
}