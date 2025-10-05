class ShiftModel {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;

  const ShiftModel({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'status': status,
    };
  }

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null 
          ? DateTime.parse(json['end_time'] as String) 
          : null,
      status: json['status'] as String,
    );
  }
}
