class OrderModel {
  final int? id;
  final String orderNumber;
  final int userId;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String paymentMethod;
  final String status;
  final String deliveryAddress;
  final String? createdAt;

  OrderModel({
    this.id,
    required this.orderNumber,
    required this.userId,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.deliveryAddress,
    this.createdAt,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int?,
      orderNumber: map['order_number'] as String? ?? '',
      userId: map['user_id'] as int? ?? 0,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryFee: (map['delivery_fee'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      total: (map['total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: map['payment_method'] as String? ?? 'Cash on Delivery',
      status: map['status'] as String? ?? 'Order Placed',
      deliveryAddress: map['delivery_address'] as String? ?? '',
      createdAt: map['created_at'] as String?,
    );
  }
}
