class ShiftEntity {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final String status;

  const ShiftEntity({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.status,
  });

  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
}
