class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result._({this.data, this.error, required this.isSuccess});

  factory Result.success(T data) {
    return Result._(data: data, isSuccess: true);
  }

  factory Result.failure(String error) {
    return Result._(error: error, isSuccess: false);
  }

  bool get isFailure => !isSuccess;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (isSuccess && data != null) {
      return onSuccess(data as T);
    } else {
      return onError(error ?? 'Unknown error');
    }
  }
}

class ApiResponse<T> {
  final T? data;
  final String? message;
  final int statusCode;
  final bool success;

  ApiResponse({
    this.data,
    this.message,
    required this.statusCode,
    required this.success,
  });

  factory ApiResponse.success(T data, {int statusCode = 200}) {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      success: true,
    );
  }

  factory ApiResponse.error(String message, {int statusCode = 500}) {
    return ApiResponse(
      message: message,
      statusCode: statusCode,
      success: false,
    );
  }
}