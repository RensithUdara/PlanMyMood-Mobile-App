import 'package:flutter/material.dart';
import '../../models/mood.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class MoodIndicator extends StatelessWidget {
  final Mood? mood;
  final VoidCallback? onTap;

  const MoodIndicator({
    super.key,
    this.mood,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: mood != null 
              ? AppColors.getMoodColor(mood!.name)
              : AppColors.grayDisabled,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            mood?.emoji ?? '🤔',
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}