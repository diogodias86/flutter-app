class SaleItemResponseDto {
  final String id;
  final String description;
  final int quantity;
  final double unitPrice;

  const SaleItemResponseDto({
    required this.id,
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

  factory SaleItemResponseDto.fromJson(Map<String, dynamic> json) {
    return SaleItemResponseDto(
      id: json['id'] as String? ?? '',
      description: json['description'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class SaleResponseDto {
  final String id;
  final String customerId;
  final String customerName;
  final DateTime saleDate;
  final List<SaleItemResponseDto> items;
  final double totalAmount;
  final String status;

  const SaleResponseDto({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.saleDate,
    required this.items,
    required this.totalAmount,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'customerName': customerName,
      'saleDate': saleDate.toIso8601String(),
      'items': items.map((i) => i.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
    };
  }

  factory SaleResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>? ?? [])
        .map((item) =>
            SaleItemResponseDto.fromJson(item as Map<String, dynamic>))
        .toList();

    return SaleResponseDto(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      saleDate: json['saleDate'] != null
          ? DateTime.tryParse(json['saleDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      items: rawItems,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ??
          rawItems.fold(0.0, (total, item) => total + item.totalPrice),
      status: json['status'] as String? ?? 'Pendente',
    );
  }

  SaleResponseDto copyWith({
    String? id,
    String? customerId,
    String? customerName,
    DateTime? saleDate,
    List<SaleItemResponseDto>? items,
    double? totalAmount,
    String? status,
  }) {
    return SaleResponseDto(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      saleDate: saleDate ?? this.saleDate,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
    );
  }
}
