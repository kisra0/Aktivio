import '../basics/data.dart';
import 'data.dart' as pimg;

import '../basics/drawer.dart';
import 'add_goal.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({super.key});

  @override
  State<RecommendationScreen> createState() => _MyWidgetState();
}

Data data = Data();
String title = "";

class _MyWidgetState extends State<RecommendationScreen> {
  void _onBodyPartTap(String part) {
    setState(() {
      title = part;
    });
  }

  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final PageController _pageController = PageController();
  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light, // Android
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
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light, // Android
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            flexibleSpace: Builder(
              builder: (context) {
                final topPadding = MediaQuery.of(context).padding.top;

                return Column(
                  children: [
                    SizedBox(height: topPadding),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 163, 159, 159)
                            .withOpacity(0.6),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isDrawerOpen ? Icons.close : Icons.menu,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              if (_isDrawerOpen) {
                                _scaffoldKey.currentState!
                                    .closeDrawer(); // ✅ CORRECT
                              } else {
                                _scaffoldKey.currentState!
                                    .openDrawer(); // ✅ CORRECT
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainScreen(),
                                ),
                              );
                            },
                            child: Image.asset(
                              'images/logo.png',
                              height: 32,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Aktivio',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: pimg.Data.avatarImage,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF375A9A), // ✅ New background color
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + 80,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ================= TITLE =================
                      const Text(
                        "Why should you do sport?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Regular exercise helps us stay fit, reduces stress, improves mood, and gives us more energy to enjoy everyday life.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ================= IMAGE 1 =================
                      Image.asset(
                        'images/rec1.png', // 🔁 replace with your image
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),

                      const SizedBox(height: 16),
                      Image.asset(
                        'images/rec2.png', // 🔁 replace with your image
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Sport improves our physical and mental health. It helps prevent diseases, builds confidence, teaches teamwork, and encourages discipline. Sport helps us stay fit, slim, and look attractive for many years; it also connects people and brings happiness through active living.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "For adults, health-promoting activity lasting at least 150 minutes per week (at moderate intensity) or 75 minutes per week (at high intensity) is recommended, as well as muscle-strengthening physical activity at least two days per week (U.S. Department of Health and Human Services 2008).",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // ================= IMAGE 2 =================

                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddGoalScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF375A9A), // same bg
                          foregroundColor: Colors.white,
                          elevation: 8, // shadow
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 14),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text("Add Goal"),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
