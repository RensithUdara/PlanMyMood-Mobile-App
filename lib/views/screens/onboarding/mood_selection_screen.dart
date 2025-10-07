import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/app_controller.dart';
import '../../../controllers/mood_controller.dart';
import '../../../models/mood.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../../../views/widgets/mood_grid.dart';
import 'mood_confirmation_screen.dart';

class MoodSelectionScreen extends StatefulWidget {
  const MoodSelectionScreen({super.key});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  Mood? _selectedMood;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  Future<void> _loadMoods() async {
    final moodController = Provider.of<MoodController>(context, listen: false);
    if (moodController.moods.isEmpty) {
      await moodController.loadMoods();
    }
  }

  void _onMoodSelected(Mood mood) {
    setState(() {
      _selectedMood = mood;
    });
  }

  void _continueToConfirmation() {
    if (_selectedMood != null) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return MoodConfirmationScreen(selectedMood: _selectedMood!);
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
  }

  void _skipMoodSelection() {
    _completeOnboardingAndNavigate();
  }

  Future<void> _completeOnboardingAndNavigate() async {
    final appController = Provider.of<AppController>(context, listen: false);
    await appController.completeOnboarding();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/dashboard',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBeige,
      body: SafeArea(
        child: Consumer<MoodController>(
          builder: (context, moodController, child) {
            if (moodController.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryOrange),
                ),
              );
            }

            return Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      const SizedBox(height: AppConstants.paddingMedium),
                      Text(
                        AppConstants.onboardingTitles[3],
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: AppColors.primaryText,
                                  fontWeight: FontWeight.bold,
                                ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                    ],
                  ),
                ),

                // Mood Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingLarge,
                    ),
                    child: MoodGrid(
                      moods: moodController.moods,
                      selectedMood: _selectedMood,
                      onMoodSelected: _onMoodSelected,
                      isSelectionMode: true,
                    ),
                  ),
                ),

                // Bottom Actions
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    children: [
                      // Continue Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _selectedMood != null
                              ? _continueToConfirmation
                              : null,
                          child: const Text(
                            'Continue',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppConstants.paddingMedium),

                      // Skip Button
                      TextButton(
                        onPressed: _skipMoodSelection,
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
