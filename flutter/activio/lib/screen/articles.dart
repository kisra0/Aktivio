import 'data.dart' as pimg;

import '../basics/drawer.dart';
import 'article_detail.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  String _searchText = "";

  final List<Article> articles = [
    Article(
        title: "Sleep",
        url:
            "https://www.wired.com/story/sleep-apnea-biomarker-night-breathing/"),
    Article(
        title: "Food & Nutrition / Diabetes",
        url:
            "https://www.eatingwell.com/habit-to-break-for-blood-sugar-balance-11781367"),
    Article(
        title: "Activity & Lifestyle",
        url:
            "https://www.cdc.gov/physical-activity-basics/benefits/index.html"),
    Article(
        title: "Heart & Cardiovascular Health",
        url:
            "https://www.washingtonpost.com/wellness/2025/07/28/science-prevent-heart-disease/"),
    Article(
        title: "The 8 Worst Foods to Eat for Inflammation",
        url:
            "https://www.eatingwell.com/flavanoid-variety-cancer-study-11749936"),
    Article(
        title: "Scientists Just Discovered a New Health Benefit of Coffee",
        url:
            "https://www.eatingwell.com/new-health-benefit-of-coffee-study-11726744"),
    Article(
        title: "Eating Chicken May Increase Your Mortality Risk",
        url:
            "https://www.eatingwell.com/study-chicken-mortality-risk-11720104"),
    Article(
        title: "4 ‘Healthy’ Trends That Need to End",
        url:
            "https://www.eatingwell.com/healthy-trends-that-need-to-stop-11751762"),
    Article(
        title: "Mediterranean Diet May Support Bone Health",
        url:
            "https://www.eatingwell.com/bone-health-mediterranean-diet-11711574"),
    Article(
        title: "Top 10 Food & Nutrition Trends for 2024",
        url:
            "https://www.eatingwell.com/top-10-food-nutrition-trends-2024-8415701"),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredArticles = articles
        .where((a) => a.title.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture: false,
        drawer: DrawerOption(
          isDrawerOpen: _isDrawerOpen,
          onClose: () => _scaffoldKey.currentState!.closeDrawer(),
        ),
        onDrawerChanged: (isOpen) {
          setState(() => _isDrawerOpen = isOpen);
        },
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: _buildBody(filteredArticles),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Column(
          children: [
            SizedBox(height: topPadding),
            Container(
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              color: const Color.fromARGB(255, 163, 159, 159).withOpacity(0.6),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isDrawerOpen ? Icons.close : Icons.menu,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _isDrawerOpen
                          ? _scaffoldKey.currentState!.closeDrawer()
                          : _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const MainScreen())),
                    child: Image.asset('images/logo.png', height: 32),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      "Aktivio",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen())),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundImage: pimg.Data.avatarImage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(List<Article> list) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color(0xFFE3F2FD), // light blue
            Color(0xFFE1BEE7), // light purple
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 150, 16, 24),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => setState(() => _searchText = v),
              decoration: InputDecoration(
                hintText: "Search articles...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Select an article",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            ...list.map(_buildCard),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(Article article) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ArticleDetailScreen(
              title: article.title,
              url: article.url,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        height: 70,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          article.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }
}

class Article {
  final String title;
  final String url;

  Article({required this.title, required this.url});
}
