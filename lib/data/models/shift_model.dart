class ShiftModel {
  final String id;
  final String profileId; // Изменили с userId на profileId
  final DateTime startTime;
  final DateTime? endTime;
  final String status;
  final String? description;
  final double? hourlyRate;
  final double? totalHours;
  final double? totalPay;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShiftModel({
    required this.id,
    required this.profileId,
    required this.startTime,
    this.endTime,
    required this.status,
    this.description,
    this.hourlyRate,
    this.totalHours,
    this.totalPay,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile_id': profileId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'status': status,
      'description': description,
      'hourly_rate': hourlyRate,
      'total_hours': totalHours,
      'total_pay': totalPay,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      profileId: json['profile_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time'] as String) 
          : null,
      status: json['status'] as String,
      description: json['description'] as String?,
      hourlyRate: json['hourly_rate'] != null 
          ? (json['hourly_rate'] as num).toDouble() 
          : null,
      totalHours: json['total_hours'] != null 
          ? (json['total_hours'] as num).toDouble() 
          : null,
      totalPay: json['total_pay'] != null 
          ? (json['total_pay'] as num).toDouble() 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : null,
    );
  }
}
