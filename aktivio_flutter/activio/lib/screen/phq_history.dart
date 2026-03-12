import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PHQHistoryScreen extends StatefulWidget {
  const PHQHistoryScreen({super.key});

  @override
  State<PHQHistoryScreen> createState() => _PHQHistoryScreenState();
}

class _PHQHistoryScreenState extends State<PHQHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  List<Map<String, dynamic>> phqHistory = [];

  // ================== API ==================
  Future<void> history() async {
    final response = await http.post(
      Uri.parse("https://developer25.pythonanywhere.com/phq_history"),
      //Uri.parse("http://10.0.2.2:5000/phq_history"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "user_id": Data.user_id.toString(),
        "flutter": "yes",
      },
    );

    final decoded = jsonDecode(response.body);
    final List<dynamic> results = decoded["results"];
    final List<dynamic> questions = decoded["q"];
    print(questions);
    setState(() {
      phqHistory = List.generate(results.length, (i) {
        return {
          "date": results[i][2], // date
          "level": results[i][1], // severity text
          "questions": questions[i], // Q1–Q9 text
        };
      });
    });
  }

  @override
  void initState() {
    super.initState();
    history();
  }

  // ================== BUILD ==================
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

  // ================== APP BAR ==================
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        flexibleSpace: Column(
          children: [
            SizedBox(height: topPadding),
            Container(
              height: 80,
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                    ),
                    child: Image.asset('images/logo.png', height: 32),
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
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, Color(0xFFFFC1CC)],
        ),
      ),
      child: GridView.builder(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + 96,
          16,
          24,
        ),
        itemCount: phqHistory.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        itemBuilder: (context, index) {
          return _phqHistoryCard(phqHistory[index]);
        },
      ),
    );
  }

  // ================== CARD ==================
  Widget _phqHistoryCard(Map<String, dynamic> data) {
    final String level = data["level"];
    final info = _phqLevelFromText(level);

    return Container(
      height: 360, // ✅ increase height to fit all questions
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: info["color"].withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                level,
                style: TextStyle(
                  color: info["color"],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["date"],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              /// ALL QUESTIONS (NO LIMIT)
              ...data["questions"].map<Widget>((q) => _infoRow(q)).toList(),

              const SizedBox(height: 8),

              Text(
                "Severity: $level",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: info["color"],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// ================== HELPERS ==================
  Widget _infoRow(String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        value,
        style: const TextStyle(fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Map<String, dynamic> _phqLevelFromText(String level) {
    switch (level.toLowerCase()) {
      case "minimal":
        return {"color": Colors.green};
      case "mild":
        return {"color": Colors.lightGreen};
      case "moderate":
        return {"color": Colors.orange};
      case "moderately severe":
        return {"color": Colors.deepOrange};
      case "severe":
        return {"color": Colors.red};
      default:
        return {"color": Colors.grey}; // Not set
    }
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }
}
