class Appointment {
  final String id;
  final String patientName;
  final String doctorName;
  final DateTime appointmentDate;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Appointment({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.appointmentDate,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['_id'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorName: json['doctorName'] ?? '',
      appointmentDate: json['appointmentDate'] != null
          ? DateTime.parse(json['appointmentDate']).toLocal()
          : DateTime.now(),
      status: json['status'] ?? 'Pending',
      notes: json['notes'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt']).toLocal()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt']).toLocal()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'patientName': patientName,
      'doctorName': doctorName,
      'appointmentDate': appointmentDate.toIso8601String(),
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Appointment copyWith({
    String? patientName,
    String? doctorName,
    DateTime? appointmentDate,
    String? status,
    String? notes,
  }) {
    return Appointment(
      id: id,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}