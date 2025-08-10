import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import 'main_screen.dart';

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      icon: Icons.report_problem,
      title: 'Report Issues',
      description: 'Easily report community problems with AI-powered categorization and smart recommendations',
      color: AppColors.primary,
    ),
    OnboardingData(
      icon: Icons.volunteer_activism,
      title: 'Find Volunteers',
      description: 'Connect with passionate volunteers and organizations ready to create positive change',
      color: AppColors.secondary,
    ),
    OnboardingData(
      icon: Icons.analytics,
      title: 'Track Impact',
      description: 'Monitor progress, celebrate achievements, and see the real difference you\'re making',
      color: AppColors.accent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingMedium),
                child: TextButton(
                  onPressed: () => _navigateToMain(),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: AppConstants.fontLarge,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: EdgeInsets.all(AppConstants.paddingLarge),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                page.color,
                                page.color.withOpacity(0.7),
                              ],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: page.color.withOpacity(0.3),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            page.icon,
                            size: 80,
                            color: Colors.white,
                          ),
                        ).animate().scale(delay: 200.ms),

                        SizedBox(height: AppConstants.paddingXLarge),

                        Text(
                          page.title,
                          style: TextStyle(
                            fontSize: AppConstants.fontXXLarge + 4,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().slideY(delay: 400.ms),

                        SizedBox(height: AppConstants.paddingMedium),

                        Text(
                          page.description,
                          style: TextStyle(
                            fontSize: AppConstants.fontLarge,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ).animate().fadeIn(delay: 600.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: AppConstants.animationNormal,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? _pages[index].color
                        : AppColors.divider,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),

            SizedBox(height: AppConstants.paddingLarge),

            // Navigation Buttons
            Padding(
              padding: EdgeInsets.all(AppConstants.paddingLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentPage > 0)
                    CustomButton(
                      text: 'Previous',
                      type: ButtonType.outline,
                      onPressed: () {
                        _pageController.previousPage(
                          duration: AppConstants.animationNormal,
                          curve: Curves.easeInOut,
                        );
                      },
                      width: 100,
                    )
                  else
                    SizedBox(width: 100),

                  CustomButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _navigateToMain();
                      } else {
                        _pageController.nextPage(
                          duration: AppConstants.animationNormal,
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    width: 120,
                    icon: _currentPage == _pages.length - 1 
                        ? Icons.rocket_launch 
                        : Icons.arrow_forward,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }
}