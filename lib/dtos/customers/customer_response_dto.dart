class CustomerResponseDto {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String document;
  final String status;
  final DateTime createdAt;

  const CustomerResponseDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.document,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'document': document,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerResponseDto.fromJson(Map<String, dynamic> json) {
    return CustomerResponseDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      document: json['document'] as String? ?? '',
      status: json['status'] as String? ?? 'Ativo',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  CustomerResponseDto copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? document,
    String? status,
    DateTime? createdAt,
  }) {
    return CustomerResponseDto(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      document: document ?? this.document,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
