class CreateCustomerDto {
  final String name;
  final String email;
  final String phone;
  final String document;

  const CreateCustomerDto({
    required this.name,
    required this.email,
    required this.phone,
    required this.document,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
    };
  }

  factory CreateCustomerDto.fromJson(Map<String, dynamic> json) {
    return CreateCustomerDto(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      document: json['document'] as String? ?? '',
    );
  }
}
