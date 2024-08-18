import 'package:aurora/components/carousel.dart';
import 'package:aurora/components/reusable_carousel.dart';
import 'package:aurora/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../fallbackData/anime_data.dart';

class AnimeHomePage extends StatefulWidget {
  const AnimeHomePage({super.key});

  @override
  State<AnimeHomePage> createState() => _AnimeHomePageState();
}

class _AnimeHomePageState extends State<AnimeHomePage> {
  List<dynamic>? spotlightAnimes;
  List<dynamic>? trendingAnimes;
  List<dynamic>? latestEpisodeAnimes;
  List<dynamic>? topUpcomingAnimes;
  Map<String, dynamic>? top10Animes;
  List<dynamic>? topAiringAnimes;
  List<dynamic>? mostPopularAnimes;
  List<dynamic>? mostFavoriteAnimes;
  List<dynamic>? latestCompletedAnimes;
  List<dynamic>? genres;
  final TextEditingController _searchTerm = TextEditingController();

  @override
  void initState() {
    super.initState();
    InitFallbackData();
    fetchData();
  }

  void InitFallbackData() {
    spotlightAnimes = animeData['spotlightAnimes'];
    trendingAnimes = animeData['trendingAnimes'];
    latestEpisodeAnimes = animeData['latestEpisodeAnimes'];
    topUpcomingAnimes = animeData['topUpcomingAnimes'];
    top10Animes = animeData['top10Animes'];
    topAiringAnimes = animeData['topAiringAnimes'];
    mostPopularAnimes = animeData['mostPopularAnimes'];
    mostFavoriteAnimes = animeData['mostFavoriteAnimes'];
    latestCompletedAnimes = animeData['latestCompletedAnimes'];
    genres = animeData['genres'];
  }

  Future<void> fetchData() async {
    const String apiUrl = 'https://aniwatch-ryan.vercel.app/anime/home';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          spotlightAnimes = data['spotlightAnimes'];
          trendingAnimes = data['trendingAnimes'];
          latestEpisodeAnimes = data['latestEpisodeAnimes'];
          topUpcomingAnimes = data['topUpcomingAnimes'];
          top10Animes = data['top10Animes'];
          topAiringAnimes = data['topAiringAnimes'];
          mostPopularAnimes = data['mostPopularAnimes'];
          mostFavoriteAnimes = data['mostFavoriteAnimes'];
          latestCompletedAnimes = data['latestCompletedAnimes'];
          genres = data['genres'];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Header(
              controller: _searchTerm,
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Trending ',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Animes',
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Carousel(animeData: topAiringAnimes),
            ReusableCarousel(
                title: "Upcoming", carouselData: topUpcomingAnimes),
            ReusableCarousel(
                title: "Latest", carouselData: latestEpisodeAnimes),
            ReusableCarousel(
                title: "Completed", carouselData: latestCompletedAnimes),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  final TextEditingController controller;
  const Header({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Afternoon',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Ryan Yuuki',
                        style: TextStyle(
                          fontFamily: 'Poppins-Bold',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Theme.of(context).colorScheme.tertiary),
                    borderRadius: BorderRadius.circular(50)),
                child: IconButton(
                  icon: Icon(
                      themeProvider.selectedTheme.brightness == Brightness.dark
                          ? Iconsax.moon
                          : Iconsax.sun),
                  onPressed: () {
                      themeProvider.toggleTheme();
                  },
                  color: Theme.of(context).iconTheme.color,
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            onSubmitted: (searchTerm) => {
              Navigator.pushNamed(context, '/anime/search', arguments: {
                "term": searchTerm,
              })
            },
            decoration: InputDecoration(
              hintText: 'Search Anime...',
              prefixIcon: const Icon(Iconsax.search_normal),
              suffixIcon: const Icon(IconlyBold.filter),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
