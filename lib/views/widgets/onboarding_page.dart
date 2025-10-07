import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../screens/onboarding/onboarding_flow.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingPageData data;

  const OnboardingPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: data.backgroundColor,
      padding:
          const EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),

          // Illustration (using emoji as placeholder)
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.lightCream,
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
                data.imagePath,
                style: const TextStyle(fontSize: 80),
              ),
            ),
          ),

          const SizedBox(height: AppConstants.paddingXLarge),

          // Title
          Text(
            data.title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Subtitle
          if (data.subtitle.isNotEmpty)
            Text(
              data.subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.normal,
                  ),
              textAlign: TextAlign.center,
            ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
