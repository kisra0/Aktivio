import '../basics/drawer.dart';
import 'data.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  bool _isDrawerOpen = false;
  int _currentPage = 0;

  List events = [];

  @override
  void initState() {
    super.initState();
    events = Data.results?["events"] ?? [];
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,

        // ================= APP BAR =================
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
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
                        color: const Color.fromARGB(255, 48, 46, 46)
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
                                _scaffoldKey.currentState!.closeDrawer();
                              } else {
                                _scaffoldKey.currentState!.openDrawer();
                              }
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainScreen(),
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
                                  builder: (_) => const ProfileScreen(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: Data.avatarImage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // ================= BODY =================
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color(0xFF42A5F5),
                    Color(0xFFB3E5FC),
                    Color(0xFFEAF6FF),
                  ],
                ),
              ),
            ),

            // Hero image
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset(
                'images/hero.png',
                fit: BoxFit.cover,
              ),
            ),

            // ================= CONTENT =================
            Positioned(
              top: MediaQuery.of(context).size.height * 0.4 +
                  MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -------- EVENTS --------
                    const Text(
                      'Planned activities for today',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    const SizedBox(height: 8),

                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: events.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final event = events[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              elevation: 0,
                              color: Colors.grey.shade100.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        const Text(
                                          'Training',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                        const SizedBox(height: 10),
                                        ClipOval(
                                          child: Image.asset(
                                            'images/logo.png',
                                            width: 48,
                                            height: 48,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${event[0]}, ${event[1]}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              _InfoChip(
                                                  label:
                                                      'Time: ${event[2]} min'),
                                              const _InfoChip(
                                                  label: 'Kcal: 283'),
                                              const _InfoChip(
                                                  label: 'Difficulty: medium'),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // -------- RECOMMENDATIONS --------
                    const SizedBox(height: 16),
                    const Text(
                      'Recommendations (Aktivio AI)',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color(0xFF2E2E2E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _recommendationCard(),

                    // -------- SLIDES --------
                    const SizedBox(height: 16),
                    // -------- SLIDES --------
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 240,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // 🔹 Slider
                          PageView(
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() => _currentPage = index);
                            },
                            children: const [
                              _StatCard(
                                title: 'Calories Burned',
                                value: '283',
                                unit: 'kcal',
                                icon: Icons.local_fire_department,
                              ),
                              _StatCard(
                                title: 'Duration',
                                value: '1',
                                unit: 'hour',
                                icon: Icons.timer,
                              ),
                              _StatCard(
                                title: 'Sessions',
                                value: '5',
                                unit: 'this week',
                                icon: Icons.fitness_center,
                              ),
                            ],
                          ),

                          // ⬅️ Left control
                          Positioned(
                            left: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_left,
                                size: 32,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),

                          // ➡️ Right control
                          Positioned(
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.chevron_right,
                                size: 32,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _recommendationCard() {
    return Card(
      elevation: 0,
      color: Colors.grey.shade100.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Tai Chi • steady flow',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}

// ================= INFO CHIP =================
class _InfoChip extends StatelessWidget {
  final String label;
  const _InfoChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

// ================= STAT CARD =================
class _StatCard extends StatelessWidget {
  final String title, value, unit;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      elevation: 0,
      color: Colors.white.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.withOpacity(0.15),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text('$value $unit',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
