import 'dart:convert';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp3/Image_detect.dart';
import 'package:myapp3/pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var pokeApi =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";
  late List<dynamic> pokedex = [];
  late List<dynamic> filteredPokedex = [];
  int _selectedIndex = 0;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      fetchPokemonData();
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              'images/pokeball.png',
              width: 200,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: 80,
            left: 20,
            child: Text(
              "Pokedex",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Positioned(
            top: 150,
            bottom: 0,
            width: width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterPokemon(value);
                    },
                    decoration: InputDecoration(
                      labelText: "Search Pokémon",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                filteredPokedex.isNotEmpty
                    ? Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.4,
                          ),
                          itemCount: filteredPokedex.length,
                          itemBuilder: (context, index) {
                            var type = filteredPokedex[index]['type']
                                    .isNotEmpty
                                ? filteredPokedex[index]['type'][0]
                                : 'Unknown';
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PokemonDetailScreen(
                                      pokemonDetail: filteredPokedex[index],
                                      color: type == 'Grass'
                                          ? Colors.green
                                          : type == "Fire"
                                              ? Colors.red
                                              : type == "Water"
                                                  ? Colors.blue
                                                  : type == "Electric"
                                                      ? Colors.yellow
                                                      : type == "Rock"
                                                          ? Colors.grey
                                                          : type == "Ground"
                                                              ? Colors.brown
                                                              : type ==
                                                                      "Psychic"
                                                                  ? Colors.pink
                                                                  : type ==
                                                                          "Fighting"
                                                                      ? Colors
                                                                          .orange
                                                                      : type ==
                                                                              "Bug"
                                                                          ? Colors
                                                                              .lightGreenAccent
                                                                          : type ==
                                                                                  "Ghost"
                                                                              ? Colors.deepPurple
                                                                              : type == "Normal"
                                                                                  ? Colors.black26
                                                                                  : type == "Poison"
                                                                                      ? Colors.purple
                                                                                      : type == "Ice"
                                                                                          ? Colors.lightBlueAccent
                                                                                          : Colors.black26,
                                      heroTag: index,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: type == 'Grass'
                                        ? Colors.green
                                        : type == "Fire"
                                            ? Colors.red
                                            : type == "Water"
                                                ? Colors.blue
                                                : type == "Electric"
                                                    ? Colors.yellow
                                                    : type == "Rock"
                                                        ? Colors.grey
                                                        : type == "Ground"
                                                            ? Colors.brown
                                                            : type == "Psychic"
                                                                ? Colors.pink
                                                                : type ==
                                                                        "Fighting"
                                                                    ? Colors
                                                                        .orange
                                                                    : type ==
                                                                            "Bug"
                                                                        ? Colors
                                                                            .lightGreenAccent
                                                                        : type ==
                                                                                "Ghost"
                                                                            ? Colors.deepPurple
                                                                            : type == "Normal"
                                                                                ? Colors.black26
                                                                                : type == "Poison"
                                                                                    ? Colors.purple
                                                                                    : type == "Ice"
                                                                                        ? Colors.lightBlueAccent
                                                                                        : Colors.black26,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: -10,
                                        right: -10,
                                        child: Image.asset(
                                          'images/pokeball.png',
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        left: 10,
                                        child: Text(
                                          filteredPokedex[index]['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Positioned(
                                        top: 45,
                                        left: 20,
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            color: Colors.black26,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            type,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              filteredPokedex[index]['img'],
                                          height: 100,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
     bottomNavigationBar: BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.switch_account_rounded), // Placeholder for pokeball icon
      label: 'ImageScan',
    ),
  ],
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.black,
  backgroundColor: Colors.red,
  onTap: (int index) {
    if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => pokemondetect(),
        ),
      );
    }
     {
      setState(() {
        _selectedIndex = index;
      });
    }
  },
),

    );
  }

  void fetchPokemonData() {
    var url = Uri.parse(pokeApi);
    http.get(url).then((value) {
      if (value.statusCode == 200) {
        setState(() {
          pokedex = jsonDecode(value.body)['pokemon'];
          filteredPokedex = pokedex; // Initialize filtered list with all Pokémon
        });
      }
    });
  }

  void filterPokemon(String query) {
    setState(() {
      filteredPokedex = pokedex
          .where((pokemon) =>
              pokemon['name'].toString().toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}  



