import '../basics/data.dart';
import 'data.dart' as pimg;

import '../basics/drawer.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecommendationResultScreen extends StatefulWidget {
  const RecommendationResultScreen({super.key});

  @override
  State<RecommendationResultScreen> createState() => _MyWidgetState();
}

Data data = Data();
String title = "";

class _MyWidgetState extends State<RecommendationResultScreen> {
  void _onBodyPartTap(String part) {
    setState(() {
      title = part;
    });
  }

  @override
  void dispose() {
    _aerobicController.dispose();
    _anaerobicController.dispose();
    super.dispose();
  }

  late PageController _aerobicController;
  late PageController _anaerobicController;
  @override
  void initState() {
    super.initState();

    _aerobicController = PageController(viewportFraction: 0.85);
    _anaerobicController = PageController(viewportFraction: 0.85);
  }

  Widget trainingSlider({
    required PageController controller,
    required List<TrainingItem> items,
  }) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: controller,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // IMAGE
                      Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                      // ===== TOP OVERLAY =====
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                          ),
                          child: Row(
                            children: [
                              Icon(item.icon, color: Colors.white, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // ===== BOTTOM OVERLAY =====
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.45),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Time: 40m",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Kcal: 428",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "Difficulty: Easy",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // ===== SLIDER CONTROLS =====
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                controller.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () {
                controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ],
        ),
      ],
    );
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ================= PAGE TITLE =================
                      const Center(
                        child: Text(
                          "Your recommendations",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= AEROBIC =================
                      const Text(
                        "Aerobic trainings",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      trainingSlider(
                        controller: _aerobicController,
                        items: [
                          TrainingItem(
                            image: 'images/your_rec1.png',
                            title: 'Recovery training',
                            icon: Icons.directions_walk,
                          ),
                          TrainingItem(
                            image: 'images/your_rec2.png',
                            title: 'Alone with nature',
                            icon: Icons.eco,
                          ),
                          TrainingItem(
                            image: 'images/your_rec3.png',
                            title: 'Gym training',
                            icon: Icons.fitness_center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // ================= ANAEROBIC =================
                      const Text(
                        "Anaerobic trainings",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),

                      trainingSlider(
                        controller: _anaerobicController,
                        items: [
                          TrainingItem(
                            image: 'images/your_rec4.png',
                            title: 'Recovery training',
                            icon: Icons.directions_walk,
                          ),
                          TrainingItem(
                            image: 'images/your_rec6.png',
                            title: 'Alone with nature',
                            icon: Icons.fitness_center,
                          ),
                          TrainingItem(
                            image: 'images/your_rec4.png',
                            title: 'Gym training',
                            icon: Icons.fitness_center,
                          ),
                        ],
                      ),

                      const SizedBox(height: 50),
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

class TrainingItem {
  final String image;
  final String title;
  final IconData icon;

  TrainingItem({
    required this.image,
    required this.title,
    required this.icon,
  });
}
