import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'phq_history.dart';
import 'phq_results.dart';
import 'profile.dart';
import 'test_yourself.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PHQScreen extends StatefulWidget {
  const PHQScreen({super.key});

  @override
  State<PHQScreen> createState() => _PHQScreenState();
}

class _PHQScreenState extends State<PHQScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  final List<String> questions = [
    "Little interest or pleasure in doing things",
    "Feeling down, depressed, or hopeless",
    "Trouble falling or staying asleep, or sleeping too much",
    "Feeling tired or having little energy",
    "Poor appetite or overeating",
    "Feeling bad about yourself - or that you are a failure or have let yourself or your family dow",
    "Trouble concentrating on things, such as reading the newspaper or watching television",
    "Moving or speaking so slowly that other people could have noticed? Or so fidgety or restless that you have been moving a lot more than usual",
    "Thoughts that you would be better off dead, or thoughts of hurting yourself in some way"
  ];

  final List<String> options = [
    "Not at all",
    "Several days",
    "More than half the days",
    "Nearly every day",
  ];

  late List<int?> selectedAnswers;

  @override
  void initState() {
    super.initState();
    selectedAnswers = List<int?>.filled(questions.length, null);
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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.white, Color(0xFFFFC1CC)],
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          MediaQuery.of(context).padding.top + 96,
          16,
          24,
        ),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 20),
            _buildQuestionnaire(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ================== HEADER ==================
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TestYourselfScreen(),
                  ),
                )),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "PHQ-9 Health Status (Depression Questionnaire)",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  // ================== QUESTIONNAIRE ==================
  Widget _buildQuestionnaire() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: List.generate(questions.length, (qIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${qIndex + 1}. ${questions[qIndex]}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(options.length, (oIndex) {
                final isSelected = selectedAnswers[qIndex] == oIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() => selectedAnswers[qIndex] = oIndex);
                  },
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFFFC1CC).withOpacity(0.3)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFF6F91)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      options[oIndex],
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          );
        }),
      ),
    );
  }

  // ================== SUBMIT BUTTON ==================
  Widget _buildSubmitButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: _submit,
          child: Container(
            width: double.infinity,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6F91), Color(0xFFFF9671)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              "Submit",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PHQHistoryScreen()),
            );
          },
          child: const Text(
            'Show your history',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  // ================== SUBMIT LOGIC ==================
  Future<void> _submit() async {
    if (selectedAnswers.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please answer all questions")),
      );
      return;
    }
    String toServer = "";
    String opt = "opt";
    for (int i = 0; i < selectedAnswers.length; i++) {
      String selectedOpt = "$opt${selectedAnswers[i]! + 1}";
      toServer += "$selectedOpt#";
    }
    showDialog(
      context: context,
      barrierDismissible: false, // user cannot close it
      builder: (_) => const Center(
        child: LinearProgressIndicator(),
      ),
    );
    try {
      final response = await http.post(
        Uri.parse("https://developer25.pythonanywhere.com/test_phq_action"),
        //Uri.parse("http://10.0.2.2:5000/test_phq_action"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "user_id": Data.user_id.toString(),
          "phq": toServer,
          "flutter": "yes"
        },
      );
      final result = jsonDecode(response.body);

      Navigator.of(context).pop();
    } catch (e) {
      String message = e.toString();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PHQResultScreen(),
      ),
    );
  }
}
