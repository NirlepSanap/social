class ReportModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final String location;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final String status;
  final DateTime createdAt;
  final String reporterId;
  final String reporterName;
  final int votes;
  final List<String> tags;

  ReportModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.status,
    required this.createdAt,
    required this.reporterId,
    required this.reporterName,
    required this.votes,
    required this.tags,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      location: json['location'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      status: json['status'] ?? 'Open',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      reporterId: json['reporterId'] ?? '',
      reporterName: json['reporterName'] ?? '',
      votes: json['votes'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrl': imageUrl,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'reporterId': reporterId,
      'reporterName': reporterName,
      'votes': votes,
      'tags': tags,
    };
  }
}