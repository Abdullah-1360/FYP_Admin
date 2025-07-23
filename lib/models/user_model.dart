class AdminUser {
  final String id;
  final String username;
  final String email;
  final bool isBlocked;
  final DateTime createdAt;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.isBlocked,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      isBlocked: json['isBlocked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'isBlocked': isBlocked,
      'createdAt': createdAt.toIso8601String(),
    };
  }
} 