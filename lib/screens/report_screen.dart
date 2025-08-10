import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/report_model.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  
  String _selectedCategory = 'Infrastructure';
  String _selectedPriority = 'Medium';
  bool _isSubmitting = false;
  XFile? _selectedImage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    // Placeholder for location service
    setState(() {
      _locationController.text = "Current Location - Mumbai, Maharashtra";
    });
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create report model
      final report = ReportModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        priority: _selectedPriority,
        location: _locationController.text.trim(),
        latitude: 19.0760, // Mumbai coordinates as default
        longitude: 72.8777,
        imageUrl: _selectedImage?.path ?? '',
        status: 'Open',
        createdAt: DateTime.now(),
        reporterId: 'current_user', // Replace with actual user ID
        reporterName: 'Current User', // Replace with actual user name
        votes: 0,
        tags: _generateTags(),
      );

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Reset form
      _resetForm();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit report: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  List<String> _generateTags() {
    List<String> tags = [];
    tags.add(_selectedCategory.toLowerCase());
    tags.add(_selectedPriority.toLowerCase());
    
    // Add tags based on keywords in title and description
    String text = '${_titleController.text} ${_descriptionController.text}'.toLowerCase();
    if (text.contains('urgent')) tags.add('urgent');
    if (text.contains('safety')) tags.add('safety');
    if (text.contains('repair')) tags.add('repair');
    
    return tags;
  }

  void _resetForm() {
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    setState(() {
      _selectedCategory = 'Infrastructure';
      _selectedPriority = 'Medium';
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Report Issue'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: AppConstants.paddingXLarge),
              _buildTitleField(),
              SizedBox(height: AppConstants.paddingLarge),
              _buildDescriptionField(),
              SizedBox(height: AppConstants.paddingLarge),
              _buildCategorySelection(),
              SizedBox(height: AppConstants.paddingLarge),
              _buildPrioritySelection(),
              SizedBox(height: AppConstants.paddingLarge),
              _buildLocationField(),
              SizedBox(height: AppConstants.paddingLarge),
              _buildImagePicker(),
              SizedBox(height: AppConstants.paddingXLarge),
              _buildSubmitButton(),
            ],
          ),
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
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Row(
        children: [
          Icon(Icons.report, color: Colors.white, size: 40),
          SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Community Issue',
                  style: TextStyle(
                    fontSize: AppConstants.fontXLarge,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Help make your community better',
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

  Widget _buildTitleField() {
    return CustomTextField(
      label: 'Issue Title',
      hint: 'Enter a brief title for the issue',
      controller: _titleController,
      prefixIcon: Icons.title,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        if (value.trim().length < 3) {
          return 'Title must be at least 3 characters long';
        }
        return null;
      },
    ).animate().slideX(delay: 200.ms);
  }

  Widget _buildDescriptionField() {
    return CustomTextField(
      label: 'Description',
      hint: 'Describe the issue in detail',
      controller: _descriptionController,
      prefixIcon: Icons.description,
      maxLines: 4,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a description';
        }
        if (value.trim().length < 10) {
          return 'Description must be at least 10 characters long';
        }
        return null;
      },
    ).animate().slideX(delay: 300.ms);
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(
            fontSize: AppConstants.fontMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppConstants.paddingSmall),
        Wrap(
          spacing: AppConstants.paddingSmall,
          runSpacing: AppConstants.paddingSmall,
          children: AppConstants.problemCategories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: AppConstants.animationNormal,
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
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().slideX(delay: 400.ms);
  }

  Widget _buildPrioritySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority Level',
          style: TextStyle(
            fontSize: AppConstants.fontMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppConstants.paddingSmall),
        Row(
          children: AppConstants.priorityLevels.map((priority) {
            final isSelected = _selectedPriority == priority;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedPriority = priority),
                child: AnimatedContainer(
                  duration: AppConstants.animationNormal,
                  margin: EdgeInsets.only(right: AppConstants.paddingSmall),
                  padding: EdgeInsets.symmetric(
                    vertical: AppConstants.paddingMedium,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? _getPriorityColor(priority) : Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(
                      color: isSelected ? _getPriorityColor(priority) : AppColors.divider,
                    ),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate().slideX(delay: 500.ms);
  }

  Widget _buildLocationField() {
    return Column(
      children: [
        CustomTextField(
          label: 'Location',
          hint: 'Enter location or use current location',
          controller: _locationController,
          prefixIcon: Icons.location_on,
          suffixIcon: Icons.my_location,
          onSuffixTap: _getCurrentLocation,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a location';
            }
            return null;
          },
        ),
      ],
    ).animate().slideX(delay: 600.ms);
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Photo (Optional)',
          style: TextStyle(
            fontSize: AppConstants.fontMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: AppConstants.paddingSmall),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: AppColors.divider),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    child: Image.network(
                      _selectedImage!.path,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image, size: 40, color: AppColors.textLight),
                            SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              'Image Selected',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                          ],
                        );
                      },
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: AppColors.textLight),
                      SizedBox(height: AppConstants.paddingSmall),
                      Text(
                        'Tap to add photo',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    ).animate().slideX(delay: 700.ms);
  }

  Widget _buildSubmitButton() {
    return CustomButton(
      text: 'Submit Report',
      onPressed: _isSubmitting ? null : _submitReport,
      isLoading: _isSubmitting,
      isFullWidth: true,
      icon: Icons.send,
    ).animate().slideY(delay: 800.ms);
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
}