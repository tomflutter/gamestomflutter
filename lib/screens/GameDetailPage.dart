import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart' as html_parser;
import '../models/game.dart';
import '../providers/GameProvider.dart';

class GameDetailPage extends StatelessWidget {
  final Game game;

  GameDetailPage({required this.game});

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    bool isFavorite = gameProvider.favorites.contains(game);

    var document = html_parser.parse(game.description);
    String cleanedDescription =
        document.body?.text ?? 'Description not available';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 51, 58),
        title: Text('Detail'),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              if (isFavorite) {
                gameProvider.removeFromFavorites(game);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('${game.name} removed from favorites')));
              } else {
                gameProvider.addToFavorites(game);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${game.name} added to favorites')));
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(game.backgroundImage),
              SizedBox(height: 16),

              Text(
                '${game.genres?.join(', ') ?? 'Not Available'}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),

              Text(
                game.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              Text(
                'Release Date : ${game.releaseDate ?? 'Not Available'}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 8),

              Row(
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 18,
                  ),
                  SizedBox(
                      width:
                          8),
                  Text(
                    ' ${game.rating != null ? game.rating.toString() : 'Not Available'}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),

                  SizedBox(
                      width: 16),

                  Row(
                    children: [
                      Icon(
                        Icons.movie,
                        color: Colors.grey[700],
                        size: 20, 
                      ),
                      SizedBox(
                          width:
                              8), 
                      Text(
                        '${game.playtime} minutes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              Text(
                cleanedDescription,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
