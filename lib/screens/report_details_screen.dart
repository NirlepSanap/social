import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/report_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class ReportDetailsScreen extends StatefulWidget {
  final ReportModel report;

  const ReportDetailsScreen({
    super.key,
    required this.report,
  });

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  bool _hasVoted = false;
  int _currentVotes = 0;

  @override
  void initState() {
    super.initState();
    _currentVotes = widget.report.votes;
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'critical':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'medium':
        return AppColors.primary;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.textLight;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return AppColors.warning;
      case 'in progress':
        return AppColors.primary;
      case 'resolved':
        return AppColors.success;
      case 'closed':
        return AppColors.textLight;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inMinutes} minutes ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _shareReport,
            icon: Icon(Icons.share_outlined),
          ),
          IconButton(
            onPressed: _bookmarkReport,
            icon: Icon(Icons.bookmark_border_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildImageSection(),
            _buildContentSection(),
            _buildLocationSection(),
            _buildTagsSection(),
            _buildActionButtons(),
            _buildUpdateSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: _getPriorityColor(widget.report.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                child: Text(
                  widget.report.priority.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: _getPriorityColor(widget.report.priority),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(widget.report.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                child: Text(
                  widget.report.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(widget.report.status),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: AppConstants.paddingLarge),
          
          Text(
            widget.report.title,
            style: TextStyle(
              fontSize: AppConstants.fontXXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ).animate().slideX(delay: 100.ms),
          
          SizedBox(height: AppConstants.paddingMedium),
          
          Row(
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
                  widget.report.category,
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: AppConstants.paddingMedium),
              Text(
                _getTimeAgo(widget.report.createdAt),
                style: TextStyle(
                  fontSize: AppConstants.fontMedium,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    if (widget.report.imageUrl.isEmpty) return SizedBox.shrink();
    
    return Container(
      height: 250,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        image: DecorationImage(
          image: NetworkImage(widget.report.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    ).animate().scale(delay: 300.ms);
  }

  Widget _buildContentSection() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
              fontSize: AppConstants.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppConstants.paddingSmall),
          Text(
            widget.report.description,
            style: TextStyle(
              fontSize: AppConstants.fontMedium,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          
          SizedBox(height: AppConstants.paddingLarge),
          
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Reporter',
                  widget.report.reporterName,
                  Icons.person_outline,
                ),
              ),
              SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: _buildInfoCard(
                  'Votes',
                  '$_currentVotes',
                  Icons.thumb_up_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().slideY(delay: 400.ms);
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          SizedBox(height: AppConstants.paddingSmall),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontLarge,
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
    );
  }

  Widget _buildLocationSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: AppColors.primary, size: 24),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: AppConstants.fontSmall,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  widget.report.location,
                  style: TextStyle(
                    fontSize: AppConstants.fontMedium,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _showOnMap,
            child: Text('View on Map'),
          ),
        ],
      ),
    ).animate().slideX(delay: 500.ms);
  }

  Widget _buildTagsSection() {
    if (widget.report.tags.isEmpty) return SizedBox.shrink();
    
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tags',
            style: TextStyle(
              fontSize: AppConstants.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppConstants.paddingSmall),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: AppConstants.paddingSmall,
            children: widget.report.tags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium,
                  vertical: AppConstants.paddingSmall,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                ),
                child: Text(
                  '#$tag',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().slideY(delay: 600.ms);
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.all(AppConstants.paddingLarge),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: _hasVoted ? 'Voted' : 'Vote Up',
              icon: _hasVoted ? Icons.thumb_up : Icons.thumb_up_outlined,
              type: _hasVoted ? ButtonType.secondary : ButtonType.primary,
              onPressed: _hasVoted ? null : _voteUp,
            ),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: CustomButton(
              text: 'Follow Updates',
              icon: Icons.notifications_outlined,
              type: ButtonType.outline,
              onPressed: _followUpdates,
            ),
          ),
        ],
      ),
    ).animate().slideY(delay: 700.ms);
  }

  Widget _buildUpdateSection() {
    return Container(
      margin: EdgeInsets.all(AppConstants.paddingLarge),
      padding: EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Updates',
            style: TextStyle(
              fontSize: AppConstants.fontLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppConstants.paddingMedium),
          _buildUpdateItem(
            'Report received and under review',
            DateTime.now().subtract(Duration(hours: 2)),
            AppColors.primary,
          ),
          _buildUpdateItem(
            'Assigned to maintenance team',
            DateTime.now().subtract(Duration(days: 1)),
            AppColors.warning,
          ),
        ],
      ),
    ).animate().slideY(delay: 800.ms);
  }

  Widget _buildUpdateItem(String message, DateTime time, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppConstants.paddingSmall),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: AppConstants.fontMedium,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  _getTimeAgo(time),
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

  void _voteUp() {
    setState(() {
      _hasVoted = true;
      _currentVotes++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Thank you for your vote!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _followUpdates() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You will be notified of updates!'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _shareReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share feature coming soon!')),
    );
  }

  void _bookmarkReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Report bookmarked!')),
    );
  }

  void _showOnMap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Map feature coming soon!')),
    );
  }
}