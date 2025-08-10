import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../models/volunteer_model.dart';
import '../widgets/volunteer_card.dart';

class VolunteerScreen extends StatefulWidget {
  const VolunteerScreen({super.key});

  @override
  State<VolunteerScreen> createState() => _VolunteerScreenState();
}

class _VolunteerScreenState extends State<VolunteerScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSkill = 'All';
  final List<String> _skills = [
    'All',
    'Environment',
    'Education',
    'Healthcare',
    'Technology',
    'Community',
  ];

  // Sample volunteer data
  final List<VolunteerModel> _volunteers = [
    VolunteerModel(
      id: '1',
      name: 'Sarah Johnson',
      bio:
          'Environmental activist with 5 years experience in community cleanup projects.',
      skills: ['Environment', 'Community'],
      rating: 4.8,
      reviewCount: 24,
      location: 'Mumbai, Maharashtra',
      imageUrl: '',
      availability: 'Weekends',
      projectsCompleted: 12,
      isVerified: true,
    ),
    VolunteerModel(
      id: '2',
      name: 'Raj Patel',
      bio: 'Software engineer passionate about digital literacy and education.',
      skills: ['Technology', 'Education'],
      rating: 4.9,
      reviewCount: 31,
      location: 'Pune, Maharashtra',
      imageUrl: '',
      availability: 'Evenings',
      projectsCompleted: 18,
      isVerified: true,
    ),
  ];

  // Sample project data
  final List<ProjectModel> _projects = [
    ProjectModel(
      id: '1',
      title: 'Community Garden Initiative',
      description:
          'Help establish and maintain community gardens in urban areas.',
      category: 'Environment',
      requiredVolunteers: 10,
      currentVolunteers: 6,
      startDate: DateTime.now().add(Duration(days: 7)),
      endDate: DateTime.now().add(Duration(days: 30)),
      location: 'Bandra, Mumbai',
      organizer: 'Green Mumbai Foundation',
      imageUrl: '',
    ),
    ProjectModel(
      id: '2',
      title: 'Digital Literacy Program',
      description: 'Teach basic computer skills to elderly residents.',
      category: 'Education',
      requiredVolunteers: 5,
      currentVolunteers: 3,
      startDate: DateTime.now().add(Duration(days: 14)),
      endDate: DateTime.now().add(Duration(days: 45)),
      location: 'Thane, Mumbai',
      organizer: 'TechForAll NGO',
      imageUrl: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<VolunteerModel> get _filteredVolunteers {
    if (_selectedSkill == 'All') return _volunteers;
    return _volunteers
        .where((volunteer) => volunteer.skills.contains(_selectedSkill))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Volunteers'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Find Volunteers'),
            Tab(text: 'Projects'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSkillFilter(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildVolunteersTab(), _buildProjectsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.gradientSecondary,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusXLarge),
          bottomRight: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.volunteer_activism, color: Colors.white, size: 40),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connect with Volunteers',
                  style: TextStyle(
                    fontSize: AppConstants.fontXLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Find passionate people for your cause',
                  style: TextStyle(
                    fontSize: AppConstants.fontMedium,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideY(delay: 100.ms);
  }

  Widget _buildSkillFilter() {
    return Container(
      height: 50,
      margin: EdgeInsets.all(AppConstants.paddingLarge),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _skills.length,
        itemBuilder: (context, index) {
          final skill = _skills[index];
          final isSelected = _selectedSkill == skill;

          return GestureDetector(
            onTap: () => setState(() => _selectedSkill = skill),
            child: AnimatedContainer(
              duration: AppConstants.animationNormal,
              margin: EdgeInsets.only(right: AppConstants.paddingMedium),
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.secondary : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.divider,
                ),
              ),
              child: Center(
                child: Text(
                  skill,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVolunteersTab() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: ListView.builder(
        itemCount: _filteredVolunteers.length,
        itemBuilder: (context, index) {
          final volunteer = _filteredVolunteers[index];
          return VolunteerCard(
            volunteer: volunteer,
            onTap: () => _showVolunteerDetails(volunteer),
            onContact: () => _contactVolunteer(volunteer),
          ).animate().slideX(delay: (index * 100).ms);
        },
      ),
    );
  }

  Widget _buildProjectsTab() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return _buildProjectCard(project);
        },
      ),
    );
  }

  Widget _buildProjectCard(ProjectModel project) {
    final progressPercentage =
        (project.currentVolunteers / project.requiredVolunteers).clamp(
          0.0,
          1.0,
        );

    return Container(
      margin: EdgeInsets.only(bottom: AppConstants.paddingMedium),
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingSmall,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                ),
                child: Text(
                  project.category,
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Text(
                '${project.currentVolunteers}/${project.requiredVolunteers} volunteers',
                style: TextStyle(
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),

          SizedBox(height: AppConstants.paddingSmall),

          Text(
            project.title,
            style: TextStyle(
              fontSize: AppConstants.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: AppConstants.paddingSmall),

          Text(
            project.description,
            style: TextStyle(
              fontSize: AppConstants.fontMedium,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: AppConstants.paddingMedium),

          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textLight,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  project.location,
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textLight,
                  ),
                ),
              ),
              Text(
                'By ${project.organizer}',
                style: TextStyle(
                  fontSize: AppConstants.fontSmall,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),

          SizedBox(height: AppConstants.paddingMedium),

          // Progress bar
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Volunteer Progress',
                    style: TextStyle(
                      fontSize: AppConstants.fontSmall,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(progressPercentage * 100).round()}%',
                    style: TextStyle(
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              LinearProgressIndicator(
                value: progressPercentage,
                backgroundColor: AppColors.divider,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
            ],
          ),

          SizedBox(height: AppConstants.paddingMedium),

          ElevatedButton(
            onPressed: () => _joinProject(project),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              minimumSize: Size(double.infinity, 40),
            ),
            child: Text('Join Project'),
          ),
        ],
      ),
    );
  }

  void _showVolunteerDetails(VolunteerModel volunteer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppConstants.radiusXLarge),
              topRight: Radius.circular(AppConstants.radiusXLarge),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primary,
                            child: Text(
                              volunteer.name
                                  .split(' ')
                                  .map((e) => e[0])
                                  .take(2)
                                  .join(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: AppConstants.fontLarge,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      volunteer.name,
                                      style: TextStyle(
                                        fontSize: AppConstants.fontXLarge,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (volunteer.isVerified) ...[
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.verified,
                                        color: AppColors.success,
                                        size: 20,
                                      ),
                                    ],
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: AppColors.warning,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '${volunteer.rating}',
                                      style: TextStyle(
                                        fontSize: AppConstants.fontMedium,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      ' (${volunteer.reviewCount} reviews)',
                                      style: TextStyle(
                                        fontSize: AppConstants.fontMedium,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppConstants.paddingLarge),

                      Text(
                        'About',
                        style: TextStyle(
                          fontSize: AppConstants.fontLarge,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        volunteer.bio,
                        style: TextStyle(
                          fontSize: AppConstants.fontMedium,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: AppConstants.paddingLarge),

                      Text(
                        'Skills',
                        style: TextStyle(
                          fontSize: AppConstants.fontLarge,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: AppConstants.paddingSmall),
                      Wrap(
                        spacing: AppConstants.paddingSmall,
                        children: volunteer.skills.map((skill) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusLarge,
                              ),
                            ),
                            child: Text(
                              skill,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: AppConstants.paddingLarge),

                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailItem(
                              'Location',
                              volunteer.location,
                              Icons.location_on,
                            ),
                          ),
                          Expanded(
                            child: _buildDetailItem(
                              'Availability',
                              volunteer.availability,
                              Icons.schedule,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppConstants.paddingMedium),

                      _buildDetailItem(
                        'Projects Completed',
                        '${volunteer.projectsCompleted}',
                        Icons.check_circle,
                      ),

                      SizedBox(height: AppConstants.paddingXLarge),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _contactVolunteer(volunteer);
                              },
                              icon: Icon(Icons.message),
                              label: Text('Contact'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: AppConstants.paddingMedium),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                                _inviteVolunteer(volunteer);
                              },
                              icon: Icon(Icons.person_add),
                              label: Text('Invite'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                padding: EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: AppConstants.fontMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _contactVolunteer(VolunteerModel volunteer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${volunteer.name}...'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _inviteVolunteer(VolunteerModel volunteer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invitation sent to ${volunteer.name}!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _joinProject(ProjectModel project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully joined ${project.title}!'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

// Project Model - Define this here since it's specific to the volunteer screen
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int requiredVolunteers;
  final int currentVolunteers;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String organizer;
  final String imageUrl;
  final List<String> skillsRequired;
  final bool isActive;
  final double? latitude;
  final double? longitude;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.requiredVolunteers,
    required this.currentVolunteers,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizer,
    required this.imageUrl,
    this.skillsRequired = const [],
    this.isActive = true,
    this.latitude,
    this.longitude,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      requiredVolunteers: json['requiredVolunteers'] ?? 0,
      currentVolunteers: json['currentVolunteers'] ?? 0,
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['endDate'] ??
            DateTime.now().add(Duration(days: 30)).toIso8601String(),
      ),
      location: json['location'] ?? '',
      organizer: json['organizer'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      skillsRequired: List<String>.from(json['skillsRequired'] ?? []),
      isActive: json['isActive'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'requiredVolunteers': requiredVolunteers,
      'currentVolunteers': currentVolunteers,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'location': location,
      'organizer': organizer,
      'imageUrl': imageUrl,
      'skillsRequired': skillsRequired,
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Calculate percentage of volunteers joined
  double get completionPercentage {
    if (requiredVolunteers == 0) return 0.0;
    return (currentVolunteers / requiredVolunteers).clamp(0.0, 1.0);
  }

  // Check if project has available spots
  bool get hasAvailableSpots {
    return currentVolunteers < requiredVolunteers;
  }

  // Get remaining volunteer spots
  int get remainingSpots {
    return (requiredVolunteers - currentVolunteers).clamp(
      0,
      requiredVolunteers,
    );
  }

  // Check if project is starting soon (within 7 days)
  bool get isStartingSoon {
    final now = DateTime.now();
    final difference = startDate.difference(now).inDays;
    return difference >= 0 && difference <= 7;
  }

  // Check if project is currently active (between start and end date)
  bool get isCurrentlyActive {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate) && isActive;
  }

  // Get project status
  String get status {
    final now = DateTime.now();
    if (now.isBefore(startDate)) {
      return 'Upcoming';
    } else if (now.isAfter(endDate)) {
      return 'Completed';
    } else if (isCurrentlyActive) {
      return 'Active';
    } else {
      return 'Inactive';
    }
  }

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    int? requiredVolunteers,
    int? currentVolunteers,
    DateTime? startDate,
    DateTime? endDate,
    String? location,
    String? organizer,
    String? imageUrl,
    List<String>? skillsRequired,
    bool? isActive,
    double? latitude,
    double? longitude,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      requiredVolunteers: requiredVolunteers ?? this.requiredVolunteers,
      currentVolunteers: currentVolunteers ?? this.currentVolunteers,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      location: location ?? this.location,
      organizer: organizer ?? this.organizer,
      imageUrl: imageUrl ?? this.imageUrl,
      skillsRequired: skillsRequired ?? this.skillsRequired,
      isActive: isActive ?? this.isActive,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
