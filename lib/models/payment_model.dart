class PaymentItem {
  final String medicineName;
  final int quantity;
  final double price;

  PaymentItem({
    required this.medicineName,
    required this.quantity,
    required this.price,
  });

  factory PaymentItem.fromJson(Map<String, dynamic> json) {
    String name = '';
    final mid = json['medicineId'];
    if (mid is Map<String, dynamic>) {
      name = (mid['name'] ?? '').toString();
    } else {
      name = (json['name'] ?? '').toString();
    }
    final qty = (json['quantity'] is num) ? (json['quantity'] as num).toInt() : int.tryParse('${json['quantity']}') ?? 0;
    final pr = (json['price'] is num) ? (json['price'] as num).toDouble() : double.tryParse('${json['price']}') ?? 0.0;
    return PaymentItem(medicineName: name, quantity: qty, price: pr);
  }
}

class Payment {
  final String id;
  final String paymentIntentId;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? userEmail;
  final String? userUsername;
  final String? userName;
  final String? address;
  final String? fullAddress;
  final List<PaymentItem> items;

  Payment({
    required this.id,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.userEmail,
    this.userUsername,
    this.userName,
    this.address,
    this.fullAddress,
    this.items = const [],
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    final user = json['userId'];
    String? email;
    String? username;
    if (user is Map<String, dynamic>) {
      email = user['email'] as String?;
      username = user['username'] as String?;
    }
    
    email ??= json['userEmail'] as String?;
    username ??= json['userUsername'] as String?;
    final name = json['userName'] as String?;

    // Normalize fullAddress to a readable string if backend returns an object
    String? fullAddressStr;
    final fa = json['fullAddress'];
    if (fa is Map<String, dynamic>) {
      final street = fa['street']?.toString();
      final city = fa['city']?.toString();
      final state = fa['state']?.toString();
      final zip = fa['zipCode']?.toString();
      final country = fa['country']?.toString();
      final parts = [street, city, state, zip, country]
          .where((e) => e != null && e!.isNotEmpty)
          .map((e) => e!)
          .toList();
      fullAddressStr = parts.isNotEmpty ? parts.join(', ') : null;
    } else {
      fullAddressStr = fa?.toString();
    }
    List<PaymentItem> parsedItems = [];
    final itemsRaw = json['items'];
    if (itemsRaw is List) {
      parsedItems = itemsRaw.map((e) => PaymentItem.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }

    return Payment(
      id: (json['_id'] ?? json['id']).toString(),
      paymentIntentId: (json['paymentIntentId'] ?? '').toString(),
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.tryParse('${json['amount']}') ?? 0.0,
      currency: (json['currency'] ?? 'usd').toString(),
      status: (json['status'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString()) ?? DateTime.fromMillisecondsSinceEpoch(0),
      userEmail: email,
      userUsername: username,
      userName: name,
      address: (json['address'] as String?) ?? null,
      fullAddress: fullAddressStr,
      items: parsedItems,
    );
  }
}
