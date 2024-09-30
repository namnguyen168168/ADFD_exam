import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Destination> destinations = [
    Destination(name: 'Hà Nội', rating: 4.5, imageUrl: 'https://hoanghamobile.com/tin-tuc/wp-content/webp-express/webp-images/uploads/2024/04/anh-ha-noi.jpg.webp'),
    Destination(name: 'Sài Gòn', rating: 4.0, imageUrl: 'https://gmi.timchuyenbay.com/uploads/2022/02/S%C3%A0i-G%C3%B2n.jpeg'),
    Destination(name: 'Đà Nẵng', rating: 4.8, imageUrl: 'https://hoangphuan.com/wp-content/uploads/2024/06/tour-du-lich-da-nang-1.jpg'),
    Destination(name: 'Nha Trang', rating: 4.3, imageUrl: 'https://cdn.tuoitre.vn/471584752817336320/2023/4/18/tp-nha-trang-16818161974101240202452.jpeg'),
    Destination(name: 'Đà Lạt', rating: 4.3, imageUrl: 'https://dalat.tours/vi/wp-content/uploads/2019/01/dalat_tours3.jpg'),
    Destination(name: 'Hạ Long', rating: 4.2, imageUrl: 'https://vcdn1-dulich.vnecdn.net/2022/05/07/vinhHaLongQuangNinh-1651912066-8789-1651932294.jpg?w=0&h=0&q=100&dpr=2&fit=crop&s=bAYE9-ifwt-9mB2amIjnqg'),
    Destination(name: 'Quy Nhơn', rating: 4.0, imageUrl: 'https://vcdn1-dulich.vnecdn.net/2022/04/02/dulichQuyNhon-1648878861-3106-1648880222.jpg?w=0&h=0&q=100&dpr=2&fit=crop&s=wFYxIbRCAt_Yy6OCMqXkOg'),
  ];

  List<Destination> filteredDestinations = [];
  Set<String> favorites = {};
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    filteredDestinations = destinations;
  }

  void _filterDestinations(String query) {
    final filtered = destinations.where((destination) {
      return destination.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredDestinations = filtered;
    });
  }

  void _toggleFavorite(String destinationName) {
    setState(() {
      if (favorites.contains(destinationName)) {
        favorites.remove(destinationName);
      } else {
        favorites.add(destinationName);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (currentIndex == 0) {
      body = _buildHomeScreen();
    } else {
      body = FavoritesScreen(
        favorites: destinations.where((destination) => favorites.contains(destination.name)).toList(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Travel App'),
        backgroundColor: Color(0xFFD9ABE4),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterDestinations,
              decoration: InputDecoration(
                hintText: 'Search your destination',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryButton(label: 'Hotels', icon: Icons.hotel),
              CategoryButton(label: 'Flights', icon: Icons.airplanemode_active),
              CategoryButton(label: 'All', icon: Icons.explore),
            ],
          ),
        ),
       
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: filteredDestinations.map((destination) {
              return DestinationCard(
                name: destination.name,
                rating: destination.rating,
                imageUrl: destination.imageUrl,
                isFavorite: favorites.contains(destination.name),
                onFavoriteToggle: () => _toggleFavorite(destination.name),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<Destination> favorites;

  const FavoritesScreen({Key? key, required this.favorites}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return favorites.isEmpty
        ? Center(child: Text('No favorites yet.'))
        : GridView.count(
      crossAxisCount: 2,
      children: favorites.map((destination) {
        return DestinationCard(
          name: destination.name,
          rating: destination.rating,
          imageUrl: destination.imageUrl,
        );
      }).toList(),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final IconData icon;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF6D9D9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class Destination {
  final String name;
  final double rating;
  final String imageUrl;

  Destination({required this.name, required this.rating, required this.imageUrl});
}

class DestinationCard extends StatelessWidget {
  final String name;
  final double rating;
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const DestinationCard({
    Key? key,
    required this.name,
    required this.rating,
    required this.imageUrl,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 150,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavoriteToggle,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('⭐ $rating'),
          ),
        ],
      ),
    );
  }
}

