class QueueTicket {
  final String id;
  final String serviceId;
  final String transactionType;
  final int position;
  final Duration estimatedWaitTime;
  final DateTime timestamp;
  final String status; // 'active', 'cancelled', 'completed'

  QueueTicket({
    required this.id,
    required this.serviceId,
    required this.transactionType,
    required this.position,
    required this.estimatedWaitTime,
    required this.timestamp,
    this.status = 'active',
  });

  factory QueueTicket.fromJson(Map<String, dynamic> json) {
    return QueueTicket(
      id: json['id'],
      serviceId: json['serviceId'],
      transactionType: json['transactionType'],
      position: json['position'],
      estimatedWaitTime: Duration(minutes: json['estimatedWaitTime']),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'transactionType': transactionType,
      'position': position,
      'estimatedWaitTime': estimatedWaitTime.inMinutes,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}