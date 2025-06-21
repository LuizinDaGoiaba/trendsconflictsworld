import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/acled_event.dart';
import '../models/watchlist_event.dart';
import '../models/comment.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addToWatchlist(ACLEDEvent event) async {
    final user = _auth.currentUser;
    if (user != null) {
      final watchlistEvent = WatchlistEvent(
        event: event,
        reference: _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(event.eventId),
      );
      await watchlistEvent.reference.set(watchlistEvent.toMap());
    }
  }

  Stream<List<WatchlistEvent>> getWatchlist() {
    final user = _auth.currentUser;
    if (user != null) {
      return _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchlist')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          try {
            return WatchlistEvent.fromSnapshot(doc);
          } catch (e) {
            print('Error deserializing watchlist event: \$e');
            return null;
          }
        }).whereType<WatchlistEvent>().toList();
      });
    }
    return Stream.value([]);
  }

  Future<void> addComment(String eventId, String text) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final comment = Comment(text: text, timestamp: DateTime.now());

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(eventId)
        .collection('notes')
        .add(comment.toMap());
  }

  Stream<List<Comment>> getComments(String eventId) {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('watchlist')
        .doc(eventId)
        .collection('notes')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Comment.fromMap(doc.data()))
            .toList());
  }
}
