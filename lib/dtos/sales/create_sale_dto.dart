class CreateSaleItemDto {
  final String description;
  final int quantity;
  final double unitPrice;

  const CreateSaleItemDto({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory CreateSaleItemDto.fromJson(Map<String, dynamic> json) {
    return CreateSaleItemDto(
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CreateSaleDto {
  final String customerId;
  final List<CreateSaleItemDto> items;
  final String status;

  const CreateSaleDto({
    required this.customerId,
    required this.items,
    this.status = 'Pendente',
  });

  double get totalAmount =>
      items.fold(0.0, (total, item) => total + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status,
    };
  }

  factory CreateSaleDto.fromJson(Map<String, dynamic> json) {
    return CreateSaleDto(
      customerId: json['customerId'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CreateSaleItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String? ?? 'Pendente',
    );
  }
}
