import 'package:flutter/material.dart';
import '../models/volunteer_model.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';

class VolunteerCard extends StatelessWidget {
  final VolunteerModel volunteer;
  final VoidCallback? onTap;
  final VoidCallback? onContact;

  const VolunteerCard({
    super.key,
    required this.volunteer,
    this.onTap,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            // Header with avatar and basic info
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.primary,
                  backgroundImage: volunteer.imageUrl.isNotEmpty 
                      ? NetworkImage(volunteer.imageUrl) 
                      : null,
                  child: volunteer.imageUrl.isEmpty
                      ? Text(
                          volunteer.name.split(' ').map((e) => e[0]).take(2).join(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: AppConstants.fontMedium,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              volunteer.name,
                              style: TextStyle(
                                fontSize: AppConstants.fontLarge,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (volunteer.isVerified)
                            Icon(
                              Icons.verified,
                              color: AppColors.success,
                              size: 20,
                            ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppColors.warning, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${volunteer.rating}',
                            style: TextStyle(
                              fontSize: AppConstants.fontSmall,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            ' (${volunteer.reviewCount} reviews)',
                            style: TextStyle(
                              fontSize: AppConstants.fontSmall,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onContact,
                  icon: Icon(
                    Icons.message_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: AppConstants.paddingMedium),
            
            // Bio
            Text(
              volunteer.bio,
              style: TextStyle(
                fontSize: AppConstants.fontMedium,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: AppConstants.paddingMedium),
            
            // Skills
            Wrap(
              spacing: AppConstants.paddingSmall,
              runSpacing: 4,
              children: volunteer.skills.take(3).map((skill) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingSmall,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Text(
                    skill,
                    style: TextStyle(
                      fontSize: AppConstants.fontSmall,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: AppConstants.paddingMedium),
            
            // Footer with location and stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    SizedBox(width: 4),
                    Text(
                      volunteer.location,
                      style: TextStyle(
                        fontSize: AppConstants.fontSmall,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 14,
                      color: AppColors.success,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '${volunteer.projectsCompleted} projects',
                      style: TextStyle(
                        fontSize: AppConstants.fontSmall,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}