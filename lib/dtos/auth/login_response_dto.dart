import 'user_response_dto.dart';

class LoginResponseDto {
  final String token;
  final UserResponseDto user;

  const LoginResponseDto({
    required this.token,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String? ?? '',
      user: json['user'] != null
          ? UserResponseDto.fromJson(json['user'] as Map<String, dynamic>)
          : const UserResponseDto(
              id: '',
              name: 'Usuário',
              email: '',
              role: 'Operador',
            ),
    );
  }
}
