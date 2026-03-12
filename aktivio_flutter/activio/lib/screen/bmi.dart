import '../basics/drawer.dart';
import 'bmi_history.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'test_yourself.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  String? selectedGender;
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();

  double? bmiResult;
  String? bmiStatus;
  Color? bmiColor;

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
            _buildBMIForm(),
            const SizedBox(height: 30),
            _buildSubmitButton(),
            if (bmiResult != null) ...[
              const SizedBox(height: 30),
              _buildBMIResult(),
            ]
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
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TestYourselfScreen()),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Text(
            "Body Composition: Body Mass Index",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }

  // ================== FORM ==================
  Widget _buildBMIForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gender",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              _genderCard("Woman"),
              const SizedBox(width: 12),
              _genderCard("Man"),
            ],
          ),
          const SizedBox(height: 24),
          _buildTextField(ageController, "Age", "Enter your age"),
          const SizedBox(height: 20),
          _buildTextField(
              weightController, "Weight (kg)", "Enter weight in kg"),
          const SizedBox(height: 20),
          _buildTextField(heightController, "Height (m)", "Enter height in m"),
        ],
      ),
    );
  }

  Widget _genderCard(String gender) {
    final isSelected = selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFFC1CC).withOpacity(0.3)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color:
                    isSelected ? const Color(0xFFFF6F91) : Colors.grey.shade300,
                width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(gender, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }

  // ================== SUBMIT ==================
  Widget _buildSubmitButton() {
    return Column(
      children: [
        GestureDetector(
          onTap: _submit,
          child: Container(
            height: 55,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6F91), Color(0xFFFF9671)],
              ),
            ),
            alignment: Alignment.center,
            child: const Text("Calculate BMI",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BMIHistoryScreen()),
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

  // ================== RESULT ==================
  Widget _buildBMIResult() {
    const double minBMI = 10;
    const double maxBMI = 40;
    final double normalized =
        ((bmiResult! - minBMI) / (maxBMI - minBMI)).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Your BMI: ${bmiResult!.toStringAsFixed(1)}",
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: bmiColor!.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(bmiStatus!,
                style: TextStyle(color: bmiColor, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 25),

          /// POINTER
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(colors: [
                        Colors.blue,
                        Colors.green,
                        Colors.orange,
                        Colors.red
                      ]),
                    ),
                  ),
                  Positioned(
                    left: normalized * constraints.maxWidth - 8,
                    top: -8,
                    child: const Icon(Icons.arrow_drop_down, size: 30),
                  )
                ],
              );
            },
          ),

          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("10"),
              Text("18.5"),
              Text("25"),
              Text("30"),
              Text("40"),
            ],
          ),

          const SizedBox(height: 15),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Underweight"),
              Text("Normal"),
              Text("Overweight"),
              Text("Obese"),
            ],
          )
        ],
      ),
    );
  }

  // ================== LOGIC ==================
  Future<void> _submit() async {
    final double weight = double.parse(weightController.text);
    final double height = double.parse(heightController.text);
    final String age = ageController.text;

    showDialog(
      context: context,
      barrierDismissible: false, // user cannot close it
      builder: (_) => const Center(
        child: LinearProgressIndicator(),
      ),
    );
    try {
      final response = await http.post(
        Uri.parse("https://developer25.pythonanywhere.com/test_bmi_action"),
        //Uri.parse("http://10.0.2.2:5000/test_bmi_action"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "user_id": Data.user_id.toString(),
          "weight": weight.toString(),
          "height": height.toString(),
          "age": age,
          "gender": selectedGender,
          "flutter": "yes"
        },
      );
      final result = jsonDecode(response.body);
      String level = result["level"];

      final double bmi = double.parse(result["bmi"]);
      Color color;

      if (bmi < 18.5) {
        level = "Underweight";
        color = Colors.blue;
      } else if (bmi <= 24.9) {
        level = "Normal weight";
        color = Colors.green;
      } else if (bmi <= 29.9) {
        level = "Overweight";
        color = Colors.orange;
      } else {
        level = "Obese";
        color = Colors.red;
      }

      setState(() {
        bmiResult = bmi;
        bmiStatus = level;
        bmiColor = color;
      });
      Navigator.of(context).pop();
    } catch (e) {
      String message = e.toString();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
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
            offset: const Offset(0, 4))
      ],
    );
  }
}
