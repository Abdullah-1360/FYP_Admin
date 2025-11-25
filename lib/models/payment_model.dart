class Payment {
  final String id;
  final String paymentIntentId;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final String? userEmail;
  final String? userUsername;
  final String? address;
  final String? fullAddress;

  Payment({
    required this.id,
    required this.paymentIntentId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.userEmail,
    this.userUsername,
    this.address,
    this.fullAddress,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    final user = json['userId'];
    String? email;
    String? username;
    if (user is Map<String, dynamic>) {
      email = user['email'] as String?;
      username = user['username'] as String?;
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
      address: (json['address'] as String?) ?? null,
      fullAddress: (json['fullAddress'] as String?) ?? null,
    );
  }
}
