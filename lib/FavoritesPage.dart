import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/GameProvider.dart';
import 'screens/GameDetailPage.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 51, 58),
        title: Text(
          'Favorite Games',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),
      ),
      body: gameProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : gameProvider.favorites.isEmpty
              ? Center(child: Text('No favorites added yet.'))
              : ListView.builder(
                  itemCount: gameProvider.favorites.length,
                  itemBuilder: (context, index) {
                    final game = gameProvider.favorites[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        title: Text(
                          game.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            game.backgroundImage,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  'https://via.placeholder.com/150');
                            },
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              game.releaseDate != null
                                  ? 'Released: ${game.releaseDate}'
                                  : 'Release Date: Not Available',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  ' ${game.rating != null ? game.rating.toString() : 'Not Available'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameDetailPage(game: game),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: Icon(Icons.favorite),
                          onPressed: () {
                            gameProvider.removeFromFavorites(game);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('${game.name} removed from favorites'),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
