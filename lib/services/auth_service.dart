import '../dtos/auth/login_request_dto.dart';
import '../dtos/auth/login_response_dto.dart';
import '../dtos/auth/user_response_dto.dart';

abstract class AuthService {
  Future<LoginResponseDto> login(LoginRequestDto dto);
  Future<void> logout();
  Future<UserResponseDto?> getCurrentUser();
}
