class Doctor {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final List<double> ratings;
  final List<String> appointments;
  final String? chatId;
  final DateTime createdAt;

  Doctor({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.ratings,
    required this.appointments,
    this.chatId,
    required this.createdAt,
  });

  double get averageRating {
    if (ratings.isEmpty) return 0;
    return ratings.reduce((a, b) => a + b) / ratings.length;
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      experience: json['experience'] ?? 0,
      ratings: (json['ratings'] as List<dynamic>?)
              ?.map((rating) => (rating as num).toDouble())
              .toList() ??
          [],
      appointments: (json['appointments'] as List<dynamic>?)
              ?.map((appointment) => appointment.toString())
              .toList() ??
          [],
      chatId: json['chatId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'specialization': specialization,
      'experience': experience,
      'ratings': ratings,
      'appointments': appointments,
      'chatId': chatId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Doctor copyWith({
    String? name,
    String? specialization,
    int? experience,
    List<double>? ratings,
    List<String>? appointments,
    String? chatId,
  }) {
    return Doctor(
      id: id,
      name: name ?? this.name,
      specialization: specialization ?? this.specialization,
      experience: experience ?? this.experience,
      ratings: ratings ?? this.ratings,
      appointments: appointments ?? this.appointments,
      chatId: chatId ?? this.chatId,
      createdAt: createdAt,
    );
  }
} 