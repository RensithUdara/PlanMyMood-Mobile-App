import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/app_controller.dart';
import '../../../controllers/mood_controller.dart';
import '../../../models/mood.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_constants.dart';
import '../home/dashboard.dart';

class MoodConfirmationScreen extends StatelessWidget {
  final Mood selectedMood;

  const MoodConfirmationScreen({
    super.key,
    required this.selectedMood,
  });

  Future<void> _confirmMoodAndContinue(BuildContext context) async {
    try {
      final appController = Provider.of<AppController>(context, listen: false);
      final moodController =
          Provider.of<MoodController>(context, listen: false);

      // Set selected mood
      await moodController.selectMood(selectedMood);

      // Complete onboarding
      await appController.completeOnboarding();

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const Dashboard();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: AppConstants.fadeAnimationDuration,
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.angry,
          ),
        );
      }
    }
  }

  void _goBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.creamBeige,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Title
              Text(
                'Your mood for today!',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppConstants.paddingXLarge),

              // Large Mood Display
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.getMoodColor(selectedMood.name),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    selectedMood.emoji,
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),

              // Mood Name
              Text(
                selectedMood.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _confirmMoodAndContinue(context),
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

              // Misclicked Button
              TextButton(
                onPressed: () => _goBack(context),
                child: const Text(
                  'Misclicked',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondaryText,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.paddingLarge),
            ],
          ),
        ),
      ),
    );
  }
}
