import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DiseasesScreen extends StatefulWidget {
  final String title;
  final String content;

  const DiseasesScreen({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  State<DiseasesScreen> createState() => _CardiovascularScreenState();
}

class _CardiovascularScreenState extends State<DiseasesScreen> {
  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

        // 🔹 SAME APP BAR AS NervousScreen
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
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

        // 🔹 BODY (Scrollable text content)
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 64, 130, 42),
          padding: const EdgeInsets.fromLTRB(16, 140, 16, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.content,
                  textScaleFactor: MediaQuery.textScaleFactorOf(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.6,
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
