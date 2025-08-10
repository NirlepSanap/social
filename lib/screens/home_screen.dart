import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/report_card.dart';
import '../models/report_model.dart';
import 'report_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Infrastructure', 'Environment', 'Safety', 'Education'];

  // Sample data - In real app, this would come from API
  final List<ReportModel> _reports = [
    ReportModel(
      id: '1',
      title: 'Broken Street Light',
      description: 'Street light has been out for 2 weeks, making the area unsafe at night.',
      category: 'Infrastructure',
      priority: 'High',
      location: '123 Main Street, Downtown',
      latitude: 37.7749,
      longitude: -122.4194,
      imageUrl: '',
      status: 'Open',
      createdAt: DateTime.now().subtract(Duration(days: 2)),
      reporterId: 'user1',
      reporterName: 'John Doe',
      votes: 25,
      tags: ['lighting', 'safety', 'urgent'],
    ),
    ReportModel(
      id: '2',
      title: 'Illegal Dumping',
      description: 'Large pile of trash dumped in the park, needs immediate cleanup.',
      category: 'Environment',
      priority: 'Medium',
      location: 'Central Park, Near Pond',
      latitude: 37.7849,
      longitude: -122.4094,
      imageUrl: '',
      status: 'In Progress',
      createdAt: DateTime.now().subtract(Duration(days: 1)),
      reporterId: 'user2',
      reporterName: 'Jane Smith',
      votes: 18,
      tags: ['environment', 'cleanup', 'park'],
    ),
  ];

  List<ReportModel> get _filteredReports {
    if (_selectedCategory == 'All') return _reports;
    return _reports.where((report) => report.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStats(),
            _buildCategoryFilter(),
            _buildReportsList(),
          ],
        ),
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
          colors: AppColors.gradientPrimary,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppConstants.radiusXLarge),
          bottomRight: Radius.circular(AppConstants.radiusXLarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good Morning!',
                    style: TextStyle(
                      fontSize: AppConstants.fontLarge,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  Text(
                    'Welcome to ImpactHub',
                    style: TextStyle(
                      fontSize: AppConstants.fontXXLarge,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(AppConstants.paddingSmall),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 100.ms),
          
          SizedBox(height: AppConstants.paddingMedium),
          
          Text(
            'Together, we\'re making our community better',
            style: TextStyle(
              fontSize: AppConstants.fontMedium,
              color: Colors.white.withOpacity(0.9),
            ),
          ).animate().slideX(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        children: [
          Expanded(child: _buildStatCard('Active Reports', '${_reports.length}', Icons.report, AppColors.primary)),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(child: _buildStatCard('Volunteers', '147', Icons.people, AppColors.secondary)),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(child: _buildStatCard('Resolved', '89', Icons.check_circle, AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
        children: [
          Container(
            padding: EdgeInsets.all(AppConstants.paddingSmall),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: AppConstants.fontSmall,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ).animate().scale(delay: 300.ms);
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: AnimatedContainer(
              duration: AppConstants.animationNormal,
              margin: EdgeInsets.only(right: AppConstants.paddingMedium),
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Center(
                child: Text(
                  category,
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

  Widget _buildReportsList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Reports',
                  style: TextStyle(
                    fontSize: AppConstants.fontXLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text('See All'),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.paddingMedium),
            
            Expanded(
              child: ListView.builder(
                itemCount: _filteredReports.length,
                itemBuilder: (context, index) {
                  final report = _filteredReports[index];
                  return ReportCard(
                    report: report,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReportDetailsScreen(report: report),
                        ),
                      );
                    },
                  ).animate().slideX(delay: (index * 100).ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}