class VolunteerModel {
  final String id;
  final String name;
  final String bio;
  final List<String> skills;
  final double rating;
  final int reviewCount;
  final String location;
  final String imageUrl;
  final String availability;
  final int projectsCompleted;
  final bool isVerified;

  VolunteerModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.skills,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.imageUrl,
    required this.availability,
    required this.projectsCompleted,
    required this.isVerified,
  });

  factory VolunteerModel.fromJson(Map<String, dynamic> json) {
    return VolunteerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      location: json['location'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      availability: json['availability'] ?? '',
      projectsCompleted: json['projectsCompleted'] ?? 0,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'skills': skills,
      'rating': rating,
      'reviewCount': reviewCount,
      'location': location,
      'imageUrl': imageUrl,
      'availability': availability,
      'projectsCompleted': projectsCompleted,
      'isVerified': isVerified,
    };
  }
}