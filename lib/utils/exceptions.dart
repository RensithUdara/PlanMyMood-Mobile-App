class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;
  final StackTrace? stackTrace;

  AppException({
    required this.message,
    this.code,
    this.originalException,
    this.stackTrace,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

class NetworkException extends AppException {
  NetworkException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });
}

class DatabaseException extends AppException {
  DatabaseException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });
}

class ValidationException extends AppException {
  ValidationException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });
}

class PermissionException extends AppException {
  PermissionException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });
}

class FileException extends AppException {
  FileException({
    required super.message,
    super.code,
    super.originalException,
    super.stackTrace,
  });
}
