import '../basics/data.dart';
import 'data.dart' as pimg;

import '../basics/drawer.dart';
import 'nervous_diseases.dart';
import 'disease.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HumanModel extends StatefulWidget {
  const HumanModel({super.key});

  @override
  State<HumanModel> createState() => _MyWidgetState();
}

Data data = Data();
String title = "";

class _MyWidgetState extends State<HumanModel> {
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

                // Human body image (3/4 screen height)
                Positioned(
                  top: 150,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: Image.asset(
                      'images/body.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // HEAD ICON
                Positioned(
                  top: 150,
                  child: _bodyIcon(
                    icon: 'images/i1.png',
                    onTap: () => _onBodyPartTap('Nervous system'),
                  ),
                ),
                Positioned(
                  top: 310,
                  child: _bodyIcon(
                    icon: 'images/i9.png',
                    onTap: () => _onBodyPartTap('Endocrine system'),
                  ),
                ),

                // CHEST ICON
                Positioned(
                  top: 380,
                  left: 250,
                  child: _bodyIcon(
                    icon: 'images/i2.png',
                    onTap: () => _onBodyPartTap('Cardiovascular system'),
                  ),
                ),
                Positioned(
                  left: 150,
                  top: 400,
                  child: _bodyIcon(
                    icon: 'images/i3.png',
                    onTap: () => _onBodyPartTap('Respiratory system'),
                  ),
                ),

                // LEFT ARM

                // RIGHT ARM
                Positioned(
                  top: 460,
                  child: _bodyIcon(
                    icon: 'images/i4.png',
                    onTap: () => _onBodyPartTap('Musculoskeletal system'),
                  ),
                ),

                // LEG
                Positioned(
                  top: 460,
                  left: 300,
                  child: _bodyIcon(
                    icon: 'images/i5.png',
                    onTap: () => _onBodyPartTap('Skin & mucous system'),
                  ),
                ),
                Positioned(
                  top: 550,
                  child: _bodyIcon(
                    icon: 'images/i7.png',
                    onTap: () => _onBodyPartTap('Digestive system'),
                  ),
                ),
                Positioned(
                  top: 650,
                  child: _bodyIcon(
                    icon: 'images/i8.png',
                    onTap: () => _onBodyPartTap('Reproductive system'),
                  ),
                ),
                Positioned(
                  top: 500,
                  left: 130,
                  child: _bodyIcon(
                    icon: 'images/i6.png',
                    onTap: () => _onBodyPartTap('Urinary system'),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.90,
                  left: MediaQuery.of(context).size.width * 0.125, // center 75%
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8),
                        // Title
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Description

                        const SizedBox(height: 16),

                        // Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (title == "Nervous system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const NervousScreen(),
                                  ),
                                );
                              } else if (title == "Cardiovascular system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Cardiovascular system",
                                        content: data.Cardiovascular),
                                  ),
                                );
                              } else if (title == "Respiratory system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Respiratory system",
                                        content: data.Respiratory),
                                  ),
                                );
                              } else if (title == "Musculoskeletal system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Musculoskeletal system",
                                        content: data.Musculoskeletal),
                                  ),
                                );
                              } else if (title == "Skin & mucous system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Skin & mucous system",
                                        content: data.skin),
                                  ),
                                );
                              } else if (title == "Urinary system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Urinary system",
                                        content: data.Urinary),
                                  ),
                                );
                              } else if (title == "Digestive system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Digestive system",
                                        content: data.Digestive),
                                  ),
                                );
                              } else if (title == "Reproductive system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Reproductive system",
                                        content: data.Reproductive),
                                  ),
                                );
                              } else if (title == "Endocrine system") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DiseasesScreen(
                                        title: "Endocrine system",
                                        content: data.Endocrine),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Select a part then show disease'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Show Disease",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
}

Widget _bodyIcon({
  required String icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black26,
          ),
        ],
      ),
      child: Image.asset(
        icon,
        height: 50,
        width: 50,
      ),
    ),
  );
}
