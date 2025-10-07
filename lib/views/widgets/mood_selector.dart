import 'package:flutter/material.dart';

import '../../models/mood.dart';
import '../../utils/app_colors.dart';

class MoodSelector extends StatelessWidget {
  final List<Mood> moods;
  final List<Mood> selectedMoods;
  final Function(List<Mood>) onMoodsChanged;
  final bool allowMultiSelect;

  const MoodSelector({
    super.key,
    required this.moods,
    required this.selectedMoods,
    required this.onMoodsChanged,
    this.allowMultiSelect = true,
  });

  void _toggleMood(Mood mood) {
    List<Mood> newSelectedMoods = List.from(selectedMoods);

    if (allowMultiSelect) {
      // Multi-select mode
      if (newSelectedMoods.any((m) => m.id == mood.id)) {
        newSelectedMoods.removeWhere((m) => m.id == mood.id);
      } else {
        newSelectedMoods.add(mood);
      }
    } else {
      // Single-select mode
      if (newSelectedMoods.isNotEmpty && newSelectedMoods.first.id == mood.id) {
        newSelectedMoods.clear();
      } else {
        newSelectedMoods = [mood];
      }
    }

    onMoodsChanged(newSelectedMoods);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final mood = moods[index];
          final isSelected = selectedMoods.any((m) => m.id == mood.id);

          return GestureDetector(
            onTap: () => _toggleMood(mood),
            child: Container(
              width: 50,
              height: 50,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.getMoodColor(mood.name),
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border.all(color: AppColors.primaryOrange, width: 3)
                    : null,
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  mood.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
