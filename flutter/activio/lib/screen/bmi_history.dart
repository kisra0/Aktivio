import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BMIHistoryScreen extends StatefulWidget {
  const BMIHistoryScreen({super.key});

  @override
  State<BMIHistoryScreen> createState() => _BMIHistoryScreenState();
}

class _BMIHistoryScreenState extends State<BMIHistoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  /// Dummy BMI history (replace with API later)
  List<Map<String, dynamic>> bmiHistory = [];
  Future<void> history() async {
    final response = await http.post(
      Uri.parse("https://developer25.pythonanywhere.com/history"),
      //Uri.parse("http://10.0.2.2:5000/history"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {"user_id": Data.user_id.toString(), "flutter": "yes"},
    );
    final decoded = jsonDecode(response.body);
    final List<dynamic> rawList = decoded["results"];

    setState(() {
      bmiHistory = rawList.map((item) {
        return {
          "gender": item[0],
          "age": item[1],
          "weight": item[2],
          "height": item[3],
          "date": item[4],
          "bmi": item[5],
          "level": item[6],
        };
      }).toList();
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
                          fontWeight: FontWeight.w600),
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
        itemCount: bmiHistory.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return _bmiHistoryCard(bmiHistory[index]);
        },
      ),
    );
  }

  // ================== CARD ==================
  Widget _bmiHistoryCard(Map<String, dynamic> data) {
    final double bmi = data["bmi"];
    final info = _bmiLevel(bmi);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Stack(
        children: [
          /// BMI BADGE
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
                info["level"],
                style: TextStyle(
                  color: info["color"],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          /// CONTENT
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
              const SizedBox(height: 12),
              _infoRow("Gender", data["gender"]),
              _infoRow("Age", data["age"].toString()),
              _infoRow("Weight", "${data["weight"]} kg"),
              _infoRow("Height", "${data["height"]} m"),
              const Spacer(),
              Text(
                "BMI: ${bmi.toStringAsFixed(1)}",
                style: TextStyle(
                  fontSize: 18,
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
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: [
            TextSpan(
                text: "$label: ",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _bmiLevel(double bmi) {
    if (bmi < 18.5) {
      return {"level": "Underweight", "color": Colors.blue};
    } else if (bmi < 25) {
      return {"level": "Normal", "color": Colors.green};
    } else if (bmi < 30) {
      return {"level": "Overweight", "color": Colors.orange};
    } else {
      return {"level": "Obese", "color": Colors.red};
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
