class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String? profileImageUrl;
  final String location;
  final List<String> interests;
  final bool isVerified;
  final DateTime createdAt;
  final int reportsSubmitted;
  final int volunteersConnected;
  final int impactScore;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.phone,
    this.profileImageUrl,
    required this.location,
    required this.interests,
    required this.isVerified,
    required this.createdAt,
    required this.reportsSubmitted,
    required this.volunteersConnected,
    required this.impactScore,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      location: json['location'] ?? '',
      interests: List<String>.from(json['interests'] ?? []),
      isVerified: json['isVerified'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      reportsSubmitted: json['reportsSubmitted'] ?? 0,
      volunteersConnected: json['volunteersConnected'] ?? 0,
      impactScore: json['impactScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'profileImageUrl': profileImageUrl,
      'location': location,
      'interests': interests,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'reportsSubmitted': reportsSubmitted,
      'volunteersConnected': volunteersConnected,
      'impactScore': impactScore,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? profileImageUrl,
    String? location,
    List<String>? interests,
    bool? isVerified,
    DateTime? createdAt,
    int? reportsSubmitted,
    int? volunteersConnected,
    int? impactScore,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      location: location ?? this.location,
      interests: interests ?? this.interests,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
      volunteersConnected: volunteersConnected ?? this.volunteersConnected,
      impactScore: impactScore ?? this.impactScore,
    );
  }
}