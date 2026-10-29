class UpdateSaleItemDto {
  final String? id;
  final String description;
  final int quantity;
  final double unitPrice;

  const UpdateSaleItemDto({
    this.id,
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  double get totalPrice => quantity * unitPrice;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory UpdateSaleItemDto.fromJson(Map<String, dynamic> json) {
    return UpdateSaleItemDto(
      id: json['id'] as String?,
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class UpdateSaleDto {
  final String id;
  final String customerId;
  final List<UpdateSaleItemDto> items;
  final String status;

  const UpdateSaleDto({
    required this.id,
    required this.customerId,
    required this.items,
    required this.status,
  });

  double get totalAmount =>
      items.fold(0.0, (total, item) => total + item.totalPrice);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'items': items.map((i) => i.toJson()).toList(),
      'status': status,
    };
  }

  factory UpdateSaleDto.fromJson(Map<String, dynamic> json) {
    return UpdateSaleDto(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => UpdateSaleItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      status: json['status'] as String? ?? 'Pendente',
    );
  }
}
