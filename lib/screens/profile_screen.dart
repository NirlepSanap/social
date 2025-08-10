import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Sample user data - In real app, this would come from authentication
  final UserModel _user = UserModel(
    id: 'user1',
    email: 'john.doe@example.com',
    name: 'John Doe',
    phone: '+91 98765 43210',
    location: 'Mumbai, Maharashtra',
    interests: ['Environment', 'Education', 'Community'],
    isVerified: true,
    createdAt: DateTime.now().subtract(Duration(days: 90)),
    reportsSubmitted: 12,
    volunteersConnected: 8,
    impactScore: 450,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showSettings,
            icon: Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildStatsSection(),
            _buildMenuSection(),
            _buildActivitySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
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
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage: _user.profileImageUrl != null
                    ? NetworkImage(_user.profileImageUrl!)
                    : null,
                child: _user.profileImageUrl == null
                    ? Text(
                        _user.name.split(' ').map((e) => e[0]).take(2).join(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontXXLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ).animate().scale(delay: 100.ms),
          
          SizedBox(height: AppConstants.paddingMedium),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _user.name,
                style: TextStyle(
                  fontSize: AppConstants.fontXXLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (_user.isVerified) ...[
                SizedBox(width: 8),
                Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ],
          ).animate().fadeIn(delay: 200.ms),
          
          SizedBox(height: 4),
          
          Text(
            _user.email,
            style: TextStyle(
              fontSize: AppConstants.fontMedium,
              color: Colors.white.withOpacity(0.8),
            ),
          ).animate().fadeIn(delay: 300.ms),
          
          SizedBox(height: 4),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                _user.location,
                style: TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Reports',
              '${_user.reportsSubmitted}',
              Icons.report_outlined,
              AppColors.primary,
            ),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: _buildStatCard(
              'Connections',
              '${_user.volunteersConnected}',
              Icons.people_outlined,
              AppColors.secondary,
            ),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: _buildStatCard(
              'Impact Score',
              '${_user.impactScore}',
              Icons.star_outline,
              AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
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
          Icon(icon, color: color, size: 24),
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
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSmall,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 500.ms);
  }

  Widget _buildMenuSection() {
    return Container(
      margin: EdgeInsets.all(AppConstants.paddingLarge),
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
          _buildMenuItem(
            'Edit Profile',
            Icons.edit_outlined,
            () => _editProfile(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            'My Reports',
            Icons.report_outlined,
            () => _viewMyReports(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            'My Connections',
            Icons.people_outlined,
            () => _viewMyConnections(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            'Achievements',
            Icons.emoji_events_outlined,
            () => _viewAchievements(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            'Notifications',
            Icons.notifications_outlined,
            () => _viewNotifications(),
          ),
          _buildMenuDivider(),
          _buildMenuItem(
            'Help & Support',
            Icons.help_outline,
            () => _showHelp(),
          ),
        ],
      ),
    ).animate().slideY(delay: 600.ms);
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: AppConstants.fontLarge,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textLight,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildMenuDivider() {
    return Divider(
      height: 1,
      color: AppColors.divider,
      indent: 56,
    );
  }

  Widget _buildActivitySection() {
    return Container(
      margin: EdgeInsets.all(AppConstants.paddingLarge),
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
          Padding(
            padding: EdgeInsets.all(AppConstants.paddingMedium),
            child: Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: AppConstants.fontLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildActivityItem(
            'Reported street light issue',
            '2 days ago',
            Icons.report,
            AppColors.warning,
          ),
          _buildActivityItem(
            'Connected with Sarah Johnson',
            '5 days ago',
            Icons.people,
            AppColors.secondary,
          ),
          _buildActivityItem(
            'Joined Community Garden project',
            '1 week ago',
            Icons.volunteer_activism,
            AppColors.success,
          ),
        ],
      ),
    ).animate().slideY(delay: 700.ms);
  }

  Widget _buildActivityItem(String title, String time, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.settings, color: AppColors.primary),
              title: Text('App Settings'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to settings
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              title: Text('Privacy Policy'),
              onTap: () {
                Navigator.pop(context);
                // Show privacy policy
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: AppColors.error),
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit Profile feature coming soon!')),
    );
  }

  void _viewMyReports() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('My Reports feature coming soon!')),
    );
  }

  void _viewMyConnections() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('My Connections feature coming soon!')),
    );
  }

  void _viewAchievements() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Achievements feature coming soon!')),
    );
  }

  void _viewNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notifications feature coming soon!')),
    );
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Help & Support feature coming soon!')),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Perform logout
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}