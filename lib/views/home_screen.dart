
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/views/map_screen.dart';
import '../controllers/acled_service.dart';
import '../controllers/auth_service.dart';
import '../controllers/watchlist_service.dart';
import '../models/acled_event.dart';
import '../models/watchlist_event.dart';
import '../models/comment.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ACLEDService _acledService = ACLEDService();

  List<ACLEDEvent> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _keywordController = TextEditingController();

  void _search() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final results = await _acledService.searchEvents(
        country: _countryController.text,
        keyword: _keywordController.text,
      );
      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Acessa o AuthService uma vez no início do build para evitar chamadas repetidas
    final authService = Provider.of<AuthService>(context, listen: false);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        authService.signOut(); // Chama o signOut diretamente
      },
      child: Scaffold(
        backgroundColor: Colors.red[900],
        appBar: AppBar(
          title: const Text('ACLED Event Monitor'),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.map),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed:
                  authService.signOut, // Chama o signOut diretamente
            ),
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'My Watchlist',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 0) {
      return _buildSearchTab();
    } else {
      return _buildWatchlistTab();
    }
  }

  Widget _buildSearchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _countryController,
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  controller: _keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Keyword',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: _search,
              ),
            ],
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator(color: Colors.white)),
        if (_errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_errorMessage,
                style: const TextStyle(color: Colors.white)),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final event = _searchResults[index];
              return ListTile(
                title: Text(event.eventType,
                    style: const TextStyle(color: Colors.white)),
                subtitle: Text(event.country,
                    style: const TextStyle(color: Colors.white70)),
                onTap: () => _showEventDetails(event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWatchlistTab() {
    final watchlistService = Provider.of<WatchlistService>(context);
    return StreamBuilder<List<WatchlistEvent>>(
      stream: watchlistService.getWatchlist(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.white));
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white)));
        }
        final watchlist = snapshot.data ?? [];
        if (watchlist.isEmpty) {
          return const Center(
            child: Text('Your watchlist is empty.',
                style: TextStyle(color: Colors.white)),
          );
        }
        return ListView.builder(
          itemCount: watchlist.length,
          itemBuilder: (context, index) {
            final event = watchlist[index];
            return ListTile(
              title: Text(event.event.eventType,
                  style: const TextStyle(color: Colors.white)),
              subtitle: Text(event.event.country,
                  style: const TextStyle(color: Colors.white70)),
              onTap: () => _showWatchlistEventDetails(event),
            );
          },
        );
      },
    );
  }

  void _showEventDetails(ACLEDEvent event) {
    final watchlistService = Provider.of<WatchlistService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(event.eventType, style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Text(
              '${event.notes} Location: ${event.location}, ${event.country}',
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                watchlistService.addToWatchlist(event);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Event added to watchlist!'),
                  ),
                );
              },
              child: const Text('Add to Watchlist',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showWatchlistEventDetails(WatchlistEvent watchlistEvent) {
  final watchlistService = Provider.of<WatchlistService>(context, listen: false);
  final commentController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.black,
        title: Text(watchlistEvent.event.eventType,
            style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data: ${watchlistEvent.event.eventDate}\n'
                'Tipo: ${watchlistEvent.event.eventType} - ${watchlistEvent.event.subEventType}\n'
                'Local: ${watchlistEvent.event.location}, ${watchlistEvent.event.admin1}, ${watchlistEvent.event.admin2}, ${watchlistEvent.event.admin3}\n'
                'País: ${watchlistEvent.event.country}\n'
                'Fatalidades: ${watchlistEvent.event.fatalities}\n\n'
                'Notas: ${watchlistEvent.event.notes}',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Escreva um comentário',
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final text = commentController.text.trim();
                  if (text.isNotEmpty) {
                    await watchlistService.addComment(
                        watchlistEvent.event.eventId, text);
                    commentController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white),
                child: const Text('Enviar comentário',
                    style: TextStyle(color: Colors.black)),
              ),
              const SizedBox(height: 10),
              StreamBuilder<List<Comment>>(
                stream: watchlistService
                    .getComments(watchlistEvent.event.eventId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  final comments = snapshot.data ?? [];
                  if (comments.isEmpty) {
                    return const Text('Sem comentários.',
                        style: TextStyle(color: Colors.white70));
                  }
                  return SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return ListTile(
                          title: Text(comment.text,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                            comment.timestamp.toString(),
                            style: const TextStyle(color: Colors.white54),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );
}
}
