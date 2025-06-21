
import 'package:cloud_firestore/cloud_firestore.dart';
import 'acled_event.dart';

class WatchlistEvent {
  final ACLEDEvent event;
  final String notes;
  final DocumentReference reference;

  WatchlistEvent({required this.event, this.notes = '', required this.reference});

  factory WatchlistEvent.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>?;

    if (data == null || data['event'] == null) {
      throw Exception('Event data is missing in the snapshot');
    }

    return WatchlistEvent(
      event: ACLEDEvent.fromJson(data['event']),
      notes: data['notes'] ?? '',
      reference: snapshot.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': event.toJson(),
      'notes': notes,
    };
  }
}
