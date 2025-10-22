import 'package:form_validator/form_validator.dart';

class AppValidators {
  static String? validateRequired(String? value, {String? fieldName}) {
    return ValidationBuilder()
        .required('${fieldName ?? 'This field'} is required')
        .build()(value);
  }

  static String? validateTitle(String? value) {
    return ValidationBuilder()
        .required('Task title is required')
        .minLength(2, 'Task title must be at least 2 characters')
        .maxLength(100, 'Task title must not exceed 100 characters')
        .build()(value);
  }

  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) return null;

    return ValidationBuilder()
        .maxLength(500, 'Description must not exceed 500 characters')
        .build()(value);
  }

  static String? validateEmail(String? value) {
    return ValidationBuilder()
        .required('Email is required')
        .email('Please enter a valid email address')
        .build()(value);
  }

  static String? validatePassword(String? value) {
    return ValidationBuilder()
        .required('Password is required')
        .minLength(8, 'Password must be at least 8 characters')
        .regExp(RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)'),
            'Password must contain at least one uppercase letter, one lowercase letter, and one number')
        .build()(value);
  }

  static String? validatePhoneNumber(String? value) {
    return ValidationBuilder()
        .required('Phone number is required')
        .phone('Please enter a valid phone number')
        .build()(value);
  }

  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return null;

    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }

    return null;
  }

  static String? validateMoodSelection(List<dynamic>? moods) {
    if (moods == null || moods.isEmpty) {
      return 'Please select at least one mood';
    }
    return null;
  }

  // Custom validator for task creation
  static String? validateTaskData({
    required String? title,
    required String? iconType,
    required String? iconColor,
    required DateTime? date,
  }) {
    final titleError = validateTitle(title);
    if (titleError != null) return titleError;

    if (iconType == null || iconType.isEmpty) {
      return 'Please select an icon type';
    }

    if (iconColor == null || iconColor.isEmpty) {
      return 'Please select an icon color';
    }

    if (date == null) {
      return 'Please select a date';
    }

    return null;
  }
}
