import 'package:flutter/material.dart';
import '../../models/mood.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

class MoodGrid extends StatelessWidget {
  final List<Mood> moods;
  final Mood? selectedMood;
  final Function(Mood) onMoodSelected;
  final bool isSelectionMode;
  final List<Mood>? selectedMoods; // For multi-select mode

  const MoodGrid({
    super.key,
    required this.moods,
    this.selectedMood,
    required this.onMoodSelected,
    this.isSelectionMode = false,
    this.selectedMoods,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        final isSelected = selectedMood?.id == mood.id;
        final isMultiSelected = selectedMoods?.any((m) => m.id == mood.id) ?? false;

        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: AnimatedContainer(
            duration: AppConstants.fadeAnimationDuration,
            decoration: BoxDecoration(
              color: AppColors.getMoodColor(mood.name),
              borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
              border: (isSelected || isMultiSelected)
                  ? Border.all(color: AppColors.primaryOrange, width: 3)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji
                Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 48),
                ),
                
                const SizedBox(height: AppConstants.paddingSmall),
                
                // Mood Name
                Text(
                  mood.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryText,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}