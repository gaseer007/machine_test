enum BookingStatus { upcoming, completed, cancelled }

class Booking {
  final String id;
  final String spaceId;
  final String spaceName;
  final DateTime date;
  final String timeSlot;
  final double totalAmount;
  final BookingStatus status;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.spaceId,
    required this.spaceName,
    required this.date,
    required this.timeSlot,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'spaceId': spaceId,
    'spaceName': spaceName,
    'date': date.toIso8601String(),
    'timeSlot': timeSlot,
    'totalAmount': totalAmount,
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json['id'],
    spaceId: json['spaceId'],
    spaceName: json['spaceName'],
    date: DateTime.parse(json['date']),
    timeSlot: json['timeSlot'],
    totalAmount: json['totalAmount'].toDouble(),
    status: BookingStatus.values.byName(json['status']),
    createdAt: DateTime.parse(json['createdAt']),
  );
}
