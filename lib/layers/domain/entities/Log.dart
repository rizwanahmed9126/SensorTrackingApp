import 'package:equatable/equatable.dart';

class Log extends Equatable {
  const Log({
    required this.id,
    required this.reading,
    required this.readAt,
  });

  final int? id;
  final double reading;
  final String readAt;

  @override
  List<Object?> get props => [
        id,
        reading,
        readAt,
      ];
}
