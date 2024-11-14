import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> searchResults = [];
  bool isLoading = false;

  Future<void> searchMovies(String query) async {
    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://api.tvmaze.com/search/shows?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      setState(() {
        searchResults = jsonResponse.map((data) => Movie.fromJson(data['show'])).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load search results');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search movies...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onSubmitted: (query) {
            if (query.isNotEmpty) {
              searchMovies(query);
            }
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.red))
          : searchResults.isEmpty
              ? Center(
                  child: Text(
                    'Search for a movie',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: searchResults.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final movie = searchResults[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/details', arguments: movie);
                      },
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(
                              movie.image ??
                                  'https://via.placeholder.com/150', // Fallback for missing image
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            movie.name,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
