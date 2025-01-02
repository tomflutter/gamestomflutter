import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../providers/GameProvider.dart';
import 'GameDetailPage.dart';

class GameListPage extends StatefulWidget {
  @override
  _GameListPageState createState() => _GameListPageState();
}

class _GameListPageState extends State<GameListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.fetchGames(); 
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 53, 51, 58),
        title: Text(
          'Games For You',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                if (query.isNotEmpty) {
                  gameProvider.searchGames(
                      query); 
                } else {
                  gameProvider
                      .fetchGames(); 
                }
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          gameProvider.fetchGames(); 
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                return gameProvider.isLoading
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ListView.builder(
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.grey,
                              ),
                              title: Container(
                                height: 12.0,
                                color: Colors.grey,
                              ),
                              subtitle: Container(
                                height: 12.0,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      )
                    : ListView.builder(
                        itemCount: gameProvider.games.length,
                        itemBuilder: (context, index) {
                          final game = gameProvider.games[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
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
                                  game.backgroundImage.isNotEmpty
                                      ? game.backgroundImage
                                      : 'https://via.placeholder.com/150',
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
                                  SizedBox(
                                      height:
                                          8), 

                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow,
                                        size: 18,
                                      ),
                                      SizedBox(
                                          width:
                                              4),
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
                                final gameId = game
                                    .id;
                                gameProvider
                                    .fetchGameDetails(gameId)
                                    .then((gameDetails) {
                                  Get.to(
                                      () => GameDetailPage(game: gameDetails));
                                }).catchError((error) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Failed to load game details')));
                                });
                              },
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
