
class ACLEDEvent {
  final String eventId;
  final String eventDate;
  final String year;
  final String timePrecision;
  final String eventType;
  final String subEventType;
  final String actor1;
  final String assocActor1;
  final String inter1;
  final String actor2;
  final String assocActor2;
  final String inter2;
  final String interaction;
  final String region;
  final String country;
  final String admin1;
  final String admin2;
  final String admin3;
  final String location;
  final double latitude;
  final double longitude;
  final String geoPrecision;
  final String source;
  final String sourceScale;
  final String notes;
  final int fatalities;
  final int timestamp;
  final String iso3;

  ACLEDEvent({
    required this.eventId,
    required this.eventDate,
    required this.year,
    required this.timePrecision,
    required this.eventType,
    required this.subEventType,
    required this.actor1,
    required this.assocActor1,
    required this.inter1,
    required this.actor2,
    required this.assocActor2,
    required this.inter2,
    required this.interaction,
    required this.region,
    required this.country,
    required this.admin1,
    required this.admin2,
    required this.admin3,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.geoPrecision,
    required this.source,
    required this.sourceScale,
    required this.notes,
    required this.fatalities,
    required this.timestamp,
    required this.iso3,
  });

  factory ACLEDEvent.fromJson(Map<String, dynamic> json) {
    return ACLEDEvent(
      eventId: json['event_id_cnty'] ?? '',
      eventDate: json['event_date'] ?? '',
      year: json['year'] ?? '',
      timePrecision: json['time_precision'] ?? '',
      eventType: json['event_type'] ?? '',
      subEventType: json['sub_event_type'] ?? '',
      actor1: json['actor1'] ?? '',
      assocActor1: json['assoc_actor_1'] ?? '',
      inter1: json['inter1'] ?? '',
      actor2: json['actor2'] ?? '',
      assocActor2: json['assoc_actor_2'] ?? '',
      inter2: json['inter2'] ?? '',
      interaction: json['interaction'] ?? '',
      region: json['region'] ?? '',
      country: json['country'] ?? '',
      admin1: json['admin1'] ?? '',
      admin2: json['admin2'] ?? '',
      admin3: json['admin3'] ?? '',
      location: json['location'] ?? '',
      latitude: double.tryParse(json['latitude']?.toString() ?? '0.0') ?? 0.0,
      longitude: double.tryParse(json['longitude']?.toString() ?? '0.0') ?? 0.0,
      geoPrecision: json['geo_precision'] ?? '',
      source: json['source'] ?? '',
      sourceScale: json['source_scale'] ?? '',
      notes: json['notes'] ?? '',
      fatalities: int.tryParse(json['fatalities']?.toString() ?? '0') ?? 0,
      timestamp: int.tryParse(json['timestamp']?.toString() ?? '0') ?? 0,
      iso3: json['iso3'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'event_id_cnty': eventId,
      'event_date': eventDate,
      'year': year,
      'time_precision': timePrecision,
      'event_type': eventType,
      'sub_event_type': subEventType,
      'actor1': actor1,
      'assoc_actor_1': assocActor1,
      'inter1': inter1,
      'actor2': actor2,
      'assoc_actor_2': assocActor2,
      'inter2': inter2,
      'interaction': interaction,
      'region': region,
      'country': country,
      'admin1': admin1,
      'admin2': admin2,
      'admin3': admin3,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'geo_precision': geoPrecision,
      'source': source,
      'source_scale': sourceScale,
      'notes': notes,
      'fatalities': fatalities,
      'timestamp': timestamp,
      'iso3': iso3,
    };
  }
}
