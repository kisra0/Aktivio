import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NervousScreen extends StatefulWidget {
  const NervousScreen({super.key});

  @override
  State<NervousScreen> createState() => _MyWidgetState();
}

String title = "";

class _MyWidgetState extends State<NervousScreen> {
  void _onBodyPartTap(String part) {
    setState(() {
      title = part;
    });
  }

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
                              backgroundImage: Data.avatarImage,
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
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height + 60,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: const Color.fromARGB(255, 64, 130, 42),
                ),

                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 140, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🔹 Title
                        const Text(
                          'Nervous System',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // 🔹 Subtitle / description
                        const Text(
                          'Select a category below to explore nervous system activities',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Two buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      const Color.fromARGB(255, 64, 130, 42),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('Infectious'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text('Non-Infectious'),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // 🔹 Cards grid
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildCard('Sleep apnea'),
                            _buildCard('Parkinson\'s'),
                            _buildCard('Intracranial pressure'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title) {
    return InkWell(
      onTap: () => {},
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 24,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
