import '../../domain/entities/Log.dart';

class LogModel extends Log {
  const LogModel({
    id,
    required reading,
    required readAt,
  }) : super(id: id, reading: reading, readAt: readAt);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'reading': reading,
      'readAt': readAt,
    };
  }

  @override
  String toString() {
    return '{id: $id, reading: $reading, readAt: $readAt}';
  }
}
