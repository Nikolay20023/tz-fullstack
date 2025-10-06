class ShiftEntity {
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

  const ShiftEntity({
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

  Duration? get duration {
    if (endTime != null) {
      return endTime!.difference(startTime);
    }
    return null;
  }

  Duration get currentDuration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  double get hoursWorked {
    final duration = this.duration ?? currentDuration;
    return duration.inMinutes / 60.0;
  }

  double get calculatedPay {
    if (hourlyRate != null && totalHours != null) {
      return hourlyRate! * totalHours!;
    }
    return 0.0;
  }

  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed';
  bool get isPaused => status == 'paused';
}
