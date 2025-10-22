import 'package:flutter_test/flutter_test.dart';
import 'package:planmymood_mobileapp/utils/validators.dart';

void main() {
  group('AppValidators Tests', () {
    group('validateRequired', () {
      test('should return error for null input', () {
        final result = AppValidators.validateRequired(null);
        expect(result, equals('This field is required'));
      });

      test('should return error for empty string', () {
        final result = AppValidators.validateRequired('');
        expect(result, equals('This field is required'));
      });

      test('should return null for valid input', () {
        final result = AppValidators.validateRequired('Valid input');
        expect(result, isNull);
      });

      test('should use custom field name in error message', () {
        final result =
            AppValidators.validateRequired(null, fieldName: 'Username');
        expect(result, equals('Username is required'));
      });
    });

    group('validateTitle', () {
      test('should return error for null input', () {
        final result = AppValidators.validateTitle(null);
        expect(result, contains('required'));
      });

      test('should return error for empty string', () {
        final result = AppValidators.validateTitle('');
        expect(result, contains('required'));
      });

      test('should return error for short title', () {
        final result = AppValidators.validateTitle('A');
        expect(result, contains('at least 2 characters'));
      });

      test('should return error for long title', () {
        final longTitle = 'A' * 101;
        final result = AppValidators.validateTitle(longTitle);
        expect(result, contains('not exceed 100 characters'));
      });

      test('should return null for valid title', () {
        final result = AppValidators.validateTitle('Valid Task Title');
        expect(result, isNull);
      });
    });

    group('validateDescription', () {
      test('should return null for null input (optional field)', () {
        final result = AppValidators.validateDescription(null);
        expect(result, isNull);
      });

      test('should return null for empty string (optional field)', () {
        final result = AppValidators.validateDescription('');
        expect(result, isNull);
      });

      test('should return error for long description', () {
        final longDescription = 'A' * 501;
        final result = AppValidators.validateDescription(longDescription);
        expect(result, contains('not exceed 500 characters'));
      });

      test('should return null for valid description', () {
        final result = AppValidators.validateDescription('Valid description');
        expect(result, isNull);
      });
    });

    group('validateEmail', () {
      test('should return error for null input', () {
        final result = AppValidators.validateEmail(null);
        expect(result, contains('required'));
      });

      test('should return error for invalid email', () {
        final result = AppValidators.validateEmail('invalid-email');
        expect(result, contains('valid email'));
      });

      test('should return null for valid email', () {
        final result = AppValidators.validateEmail('test@example.com');
        expect(result, isNull);
      });
    });

    group('validateTaskData', () {
      test('should return null for valid task data', () {
        final result = AppValidators.validateTaskData(
          title: 'Valid Task',
          iconType: 'work',
          iconColor: '#FF5722',
          date: DateTime.now(),
        );
        expect(result, isNull);
      });

      test('should return error for invalid title', () {
        final result = AppValidators.validateTaskData(
          title: 'A', // Too short
          iconType: 'work',
          iconColor: '#FF5722',
          date: DateTime.now(),
        );
        expect(result, contains('at least 2 characters'));
      });

      test('should return error for null icon type', () {
        final result = AppValidators.validateTaskData(
          title: 'Valid Task',
          iconType: null,
          iconColor: '#FF5722',
          date: DateTime.now(),
        );
        expect(result, contains('select an icon type'));
      });

      test('should return error for null icon color', () {
        final result = AppValidators.validateTaskData(
          title: 'Valid Task',
          iconType: 'work',
          iconColor: null,
          date: DateTime.now(),
        );
        expect(result, contains('select an icon color'));
      });

      test('should return error for null date', () {
        final result = AppValidators.validateTaskData(
          title: 'Valid Task',
          iconType: 'work',
          iconColor: '#FF5722',
          date: null,
        );
        expect(result, contains('select a date'));
      });
    });

    group('validateDateRange', () {
      test('should return null for valid date range', () {
        final startDate = DateTime(2023, 1, 1);
        final endDate = DateTime(2023, 1, 31);
        final result = AppValidators.validateDateRange(startDate, endDate);
        expect(result, isNull);
      });

      test('should return error for invalid date range', () {
        final startDate = DateTime(2023, 1, 31);
        final endDate = DateTime(2023, 1, 1);
        final result = AppValidators.validateDateRange(startDate, endDate);
        expect(result, contains('End date must be after start date'));
      });

      test('should return null for null dates', () {
        final result = AppValidators.validateDateRange(null, null);
        expect(result, isNull);
      });
    });

    group('validateMoodSelection', () {
      test('should return error for null moods', () {
        final result = AppValidators.validateMoodSelection(null);
        expect(result, contains('select at least one mood'));
      });

      test('should return error for empty moods list', () {
        final result = AppValidators.validateMoodSelection([]);
        expect(result, contains('select at least one mood'));
      });

      test('should return null for non-empty moods list', () {
        final result = AppValidators.validateMoodSelection(['Happy']);
        expect(result, isNull);
      });
    });
  });
}
