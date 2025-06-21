import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:myapp/controllers/acled_service.dart';
import 'package:myapp/models/acled_event.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final ACLEDService _acledService = ACLEDService();
  List<ACLEDEvent> _events = [];
  bool _isLoading = false;
  String _error = '';

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  Future<void> _fetchEvents({String? country, String? keyword}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final results = await _acledService.searchEvents(
        country: country,
        keyword: keyword,
      );
      setState(() {
        _events = results.where((e) => e.latitude != 0 && e.longitude != 0).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar eventos: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents(); // busca inicial sem filtros
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Conflitos"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'País (em inglês)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _keywordController,
                    decoration: const InputDecoration(
                      labelText: 'Palavra-chave',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    _fetchEvents(
                      country: _countryController.text.trim(),
                      keyword: _keywordController.text.trim(),
                    );
                  },
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error.isNotEmpty
                    ? Center(child: Text(_error))
                    : FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(10, 0),
                          initialZoom: 2.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token={accessToken}',
                            additionalOptions: {
                              'accessToken':
                                  'pk.eyJ1IjoibHVpc3ppdG8iLCJhIjoiY21jMnBycXJqMGFyZjJucTZpdzFweWtjbCJ9.Awep3ebTL1ScQy3VJfnXIQ',
                            },
                            userAgentPackageName: 'com.example.myapp',
                          ),
                          MarkerLayer(
                            markers: _events.map((event) {
                              return Marker(
                                width: 40,
                                height: 40,
                                point: LatLng(event.latitude, event.longitude),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: Text(event.eventType),
                                        content: Text(
                                            '${event.notes}\n\nLocal: ${event.location}, ${event.country}\nData: ${event.eventDate}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Fechar'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    size: 30,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }
}