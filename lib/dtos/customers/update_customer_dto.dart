class UpdateCustomerDto {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String document;
  final String status;

  const UpdateCustomerDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.document,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
      'status': status,
    };
  }

  factory UpdateCustomerDto.fromJson(Map<String, dynamic> json) {
    return UpdateCustomerDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      document: json['document'] as String? ?? '',
      status: json['status'] as String? ?? 'Ativo',
    );
  }
}
