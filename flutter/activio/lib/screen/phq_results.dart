import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PHQResultScreen extends StatefulWidget {
  const PHQResultScreen({super.key});

  @override
  State<PHQResultScreen> createState() => _PHQResultScreenState();
}

class _PHQResultScreenState extends State<PHQResultScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

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
        onDrawerChanged: (isOpen) => setState(() => _isDrawerOpen = isOpen),
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: _buildBody(context),
      ),
    );
  }

  // ================== APP BAR (SAME AS PHQ SCREEN) ==================
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
              decoration: BoxDecoration(
                color:
                    const Color.fromARGB(255, 163, 159, 159).withOpacity(0.6),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isDrawerOpen ? Icons.close : Icons.menu,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () {
                      _isDrawerOpen
                          ? _scaffoldKey.currentState!.closeDrawer()
                          : _scaffoldKey.currentState!.openDrawer();
                    },
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MainScreen(),
                      ),
                    ),
                    child: Image.asset(
                      'images/logo.png',
                      height: 32,
                    ),
                  ),
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
        ),
      ),
    );
  }

  // ================== BODY ==================
  Widget _buildBody(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.white,
            Color(0xFFFFC1CC),
          ],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + 96,
          24,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔙 Back button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 20),

            // 📌 Title
            const Text(
              "PHQ-9 Health Status (Depression Questionnaire)",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 40),

            // ✅ Big green check circle
            Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                color: Color(0xFF8CD47E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                size: 90,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // 📝 Result title
            const Text(
              "Minimal depression",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // 📝 Result description
            const Text(
              "Well done! The symptoms of depression are minimal. "
              "As a rule, this condition does not require consultation "
              "with a specialist.\n\n"
              "However, if it has been present not only for the last "
              "two weeks, but for a longer period of time, it is better "
              "to clarify the situation.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
