import '../screen/articles.dart';
import '../screen/event_calender.dart';
import '../screen/human_model.dart';
import '../screen/login.dart';
import '../screen/profile.dart';
import '../screen/recommendation.dart';
import '../screen/test_yourself.dart';
import 'package:flutter/material.dart';

class DrawerOption extends StatelessWidget {
  final bool isDrawerOpen;
  final VoidCallback onClose;

  const DrawerOption({
    super.key,
    required this.isDrawerOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    return Drawer(
      width: MediaQuery.of(context).size.width,
      backgroundColor: const Color(0xFF412B6B),
      child: Column(
        children: [
          SizedBox(height: topPadding),
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            color: const Color.fromARGB(255, 163, 159, 159).withOpacity(0.6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: onClose,
                ),
                Image.asset('images/logo.png', height: 32),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Aktivio',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('images/user.jpg'),
                ),
              ],
            ),
          ),

          // ✅ DRAWER CONTENT
          Expanded(
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _drawerItem(Icons.home, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventCalenderScreen(),
                      ),
                    );
                  }, 'Calender'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.fitness_center, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  }, 'Workouts'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.insights, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecommendationScreen(),
                      ),
                    );
                  }, 'Recommendations'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ArticlesScreen(),
                      ),
                    );
                  }, 'Articles'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HumanModel(),
                      ),
                    );
                  }, 'Human model'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TestYourselfScreen(),
                      ),
                    );
                  }, 'Test yourself'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.settings, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  }, 'Calculator & measurements'),
                  const SizedBox(
                    height: 40,
                  ),
                  _drawerItem(Icons.logout, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, 'Logout'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _drawerItem(
  IconData icon,
  VoidCallback action,
  String title, {
  bool isLogout = false,
}) {
  return ListTile(
    title: Text(
      title,
      style: TextStyle(
        color: isLogout ? Colors.redAccent : Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    ),
    onTap: action,
  );
}
