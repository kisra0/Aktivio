import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _MyWidgetState();
}

Data data = Data();
String title = "";
final TextEditingController _eventNameController = TextEditingController();
final TextEditingController _dateController = TextEditingController();
final TextEditingController _timeController = TextEditingController();
final TextEditingController _durationController = TextEditingController();

DateTime? _selectedDate;
TimeOfDay? _selectedTime;

class _MyWidgetState extends State<AddEventScreen> {
  void _onBodyPartTap(String part) {
    setState(() {
      title = part;
    });
  }

  Future<dynamic> add_event(
      String name, String date, String time, String duration) async {
    final response = await http.post(
      Uri.parse("https://developer25.pythonanywhere.com/add_event"),
      //Uri.parse("http://10.0.2.2:5000/add_event"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "name": name,
        "datePicker": date,
        "timePicker": time,
        "duration": duration,
        "user_id": Data.user_id.toString(),
        "flutter": "yes"
      },
    );
    final result = jsonDecode(response.body);
    print(result['message']);
    return result;
  }

  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final PageController _pageController = PageController();
  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void showSuccessOverlay() {
      showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.6), // full-screen opacity
        builder: (context) {
          return Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 80,
              ),
            ),
          );
        },
      );

      // ✅ Auto close after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(); // close dialog
        Navigator.of(context).pop(true); // go back to calendar
      });
    }

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromARGB(255, 1, 87, 130),
                Color.fromARGB(255, 1, 87, 130),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top + 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Create Event",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ================= EVENT NAME =================
                      _buildInput(
                        label: "Event Name",
                        hint: "Enter event name",
                        icon: Icons.event,
                        controller: _eventNameController,
                      ),

                      const SizedBox(height: 18),

                      // ================= DATE =================
                      _buildInput(
                        label: "Date",
                        hint: "Select date",
                        icon: Icons.calendar_today,
                        controller: _dateController,
                        readOnly: true,
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            initialDate: _selectedDate ?? DateTime.now(),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedDate = picked;
                              _dateController.text =
                                  "${picked.day}/${picked.month}/${picked.year}";
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 18),

                      _buildInput(
                        label: "Time",
                        hint: "Select time",
                        icon: Icons.access_time,
                        controller: _timeController,
                        readOnly: true,
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime ?? TimeOfDay.now(),
                          );

                          if (picked != null) {
                            setState(() {
                              _selectedTime = picked;
                              _timeController.text = picked.format(context);
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 18),

                      _buildInput(
                        label: "Duration",
                        hint: "e.g. 30 minutes",
                        icon: Icons.timer,
                        controller: _durationController,
                        keyboardType: TextInputType.number,
                      ),

                      const SizedBox(height: 18),

                      // ================= CREATE BUTTON =================
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            String name = _eventNameController.text.trim();
                            String date =
                                _dateController.text.trim(); // 5/1/2026

                            final parts = date.split('/');
                            final day = parts[0].padLeft(2, '0');
                            final month = parts[1].padLeft(2, '0');
                            final year = parts[2];

                            date = "$year-$month-$day";
                            String time =
                                _timeController.text.trim(); // 10:25 PM

                            final partsTime = time.split(' ');
                            final hm = partsTime[0].split(':');

                            int hour = int.parse(hm[0]);
                            int minute = int.parse(hm[1]);
                            String period = partsTime[1]; // AM or PM

                            if (period == 'PM' && hour != 12) {
                              hour += 12;
                            } else if (period == 'AM' && hour == 12) {
                              hour = 0;
                            }

                            time =
                                "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

                            String duration = _durationController.text.trim();
                            try {
                              dynamic results =
                                  await add_event(name, date, time, duration);
                              if (results["success"]) {
                                showSuccessOverlay();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(results["message"])),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text("Error in adding event$e")),
                              );
                            }
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            "Create Event",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller, // ✅ IMPORTANT
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
            prefixIcon: Icon(icon, color: Colors.white),
            filled: true,
            fillColor: Colors.white.withOpacity(0.15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
