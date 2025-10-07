import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/app_controller.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../views/widgets/onboarding_page.dart';
import 'mood_selection_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: AppConstants.onboardingTitles[0],
      subtitle: AppConstants.onboardingSubtitles[0],
      imagePath: '🏆', // Placeholder emoji
      backgroundColor: AppColors.creamBeige,
    ),
    OnboardingPageData(
      title: AppConstants.onboardingTitles[1],
      subtitle: AppConstants.onboardingSubtitles[1],
      imagePath: '💡', // Placeholder emoji
      backgroundColor: AppColors.creamBeige,
    ),
    OnboardingPageData(
      title: AppConstants.onboardingTitles[2],
      subtitle: AppConstants.onboardingSubtitles[2],
      imagePath: '🚀', // Placeholder emoji
      backgroundColor: AppColors.creamBeige,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: AppConstants.slideAnimationDuration,
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMoodSelection();
    }
  }

  void _navigateToMoodSelection() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const MoodSelectionScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: AppConstants.slideAnimationDuration,
      ),
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBeige,
      body: SafeArea(
        child: Column(
          children: [
            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return OnboardingPage(data: _pages[index]);
                },
              ),
            ),
            
            // Bottom Section
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                children: [
                  // Progress Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => _buildProgressDot(index),
                    ),
                  ),
                  
                  const SizedBox(height: AppConstants.paddingLarge),
                  
                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _pages.length - 1
                            ? 'Get started'
                            : 'Next',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressDot(int index) {
    return AnimatedContainer(
      duration: AppConstants.fadeAnimationDuration,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? AppColors.primaryOrange
            : AppColors.grayDisabled,
      ),
    );
  }
}

class OnboardingPageData {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color backgroundColor;

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.backgroundColor,
  });
}