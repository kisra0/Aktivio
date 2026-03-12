import '../basics/data.dart';
import 'data.dart' as pimg;

import '../basics/drawer.dart';
import 'loading_rec.dart';
import 'main_screen.dart';
import 'profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({super.key});

  @override
  State<AddGoalScreen> createState() => _MyWidgetState();
}

Data data = Data();
String title = "";

final List<String> goals = [
  "Be healthier and more energetic",
  "Feeling more comfortable in my body",
  "Change my figure",
  "Stay active",
  "Others",
];

final List<String> sports = [
  "Aerobic trainings (cardio)",
  "Anaerobic trainings",
  "Flexibility trainings",
  "Balance trainings",
  "Others",
];

final List<String> priorities = [
  "Aerobic trainings (cardio)",
  "Anaerobic trainings",
  "Flexibility trainings",
  "Balance trainings",
  "Others",
];

Widget comboSelectionCard({
  required BuildContext context,
  required String title,
  required List<String> items,
  required List<String> selectedItems,
  bool showPriority = false,
  Map<String, int>? priorityMap,
  required void Function(String) onSelect,
}) {
  return GestureDetector(
    onTap: () {
      showModalBottomSheet(
        context: context,
        backgroundColor: const Color(0xFF375A9A),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(color: Colors.white24),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final selected = selectedItems.contains(item);

                      return ListTile(
                        onTap: () {
                          onSelect(item);
                        },
                        title: Text(
                          item,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        trailing: selected
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (showPriority &&
                                      priorityMap != null &&
                                      priorityMap[item] != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Prio ${priorityMap[item]}",
                                        style: const TextStyle(
                                          color: Color(0xFF375A9A),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_circle,
                                      color: Colors.white),
                                ],
                              )
                            : const Icon(Icons.circle_outlined,
                                color: Colors.white70),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    },

    // ================= CARD =================
    child: Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),

          // -------- CONTENT --------
          if (selectedItems.isEmpty)
            const Text(
              "Select item",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: selectedItems.map((item) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xFF375A9A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    ),
  );
}

class _MyWidgetState extends State<AddGoalScreen> {
  void _onBodyPartTap(String part) {
    setState(() {
      title = part;
    });
  }

// -------- STATE --------
  List<String> selectedGoals = [];
  List<String> selectedSports = [];
  Map<String, int?> sportPriority = {};
  bool priorityExpanded = false;
  bool goalExpanded = false;
  bool sportExpanded = false;

  @override
  void initState() {
    super.initState();

    // ✅ GUARANTEE: nothing selected by default
    selectedGoals.clear();
    selectedSports.clear();
    sportPriority.clear();
    goalExpanded = false;
    sportExpanded = false;
    for (var s in sports) {
      sportPriority[s] = null; // no priority by default
    }
  }

  final DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFF375A9A),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top + 80),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== GOALS =====
                      expandableSection(
                        title: "What is my goal?",
                        hint: "Select your goals...",
                        expanded: goalExpanded,
                        onToggle: () {
                          setState(() {
                            goalExpanded = !goalExpanded;
                          });
                        },
                        items: goals,
                        selectedItems: selectedGoals,
                        onRefresh: () => setState(() {}),
                      ),

                      // ===== SPORTS =====
                      expandableSection(
                        title: "What kind of sports I prefer?",
                        hint: "Choose sports...",
                        expanded: sportExpanded,
                        onToggle: () {
                          setState(() {
                            sportExpanded = !sportExpanded;
                          });
                        },
                        items: sports,
                        selectedItems: selectedSports,
                        onRefresh: () => setState(() {}),
                      ),
                      prioritySection(
                        title: "What priorities do you have?",
                        expanded: priorityExpanded,
                        onToggle: () {
                          setState(() {
                            priorityExpanded = !priorityExpanded;
                          });
                        },
                        items: sports,
                        priorityMap: sportPriority,
                      ),

                      const SizedBox(height: 40),

                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const GeneratingRecommendationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF375A9A), // same bg
                            foregroundColor: Colors.white,
                            elevation: 8, // shadow
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 14),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Save & see recommendations"),
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
    );
  }

  Widget expandableSection({
    required String title,
    required String hint,
    required bool expanded,
    required VoidCallback onToggle,
    required List<String> items,
    required List<String> selectedItems,
    required VoidCallback onRefresh, // <-- ADD THIS
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== TITLE =====
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // ===== INPUT BOX =====
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedItems.isEmpty ? hint : selectedItems.join(", "),
                    style: TextStyle(
                      fontSize: 16,
                      color:
                          selectedItems.isEmpty ? Colors.grey : Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),

        // ===== EXPANDED LIST =====
        if (expanded)
          Container(
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: items.map((item) {
                final selected = selectedItems.contains(item);

                return CheckboxListTile(
                  value: selected,
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: const Color(0xFF375A9A),
                  onChanged: (bool? value) {
                    if (value == true) {
                      selectedItems.add(item);
                    } else {
                      selectedItems.remove(item);
                    }
                    onRefresh(); // <-- trigger setState
                  },
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 30),
      ],
    );
  }

  Widget prioritySection({
    required String title,
    required bool expanded,
    required VoidCallback onToggle,
    required List<String> items,
    required Map<String, int?> priorityMap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== TITLE =====
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),

        // ===== INPUT HEADER =====
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Set priority (1 = highest, 5 = lowest)",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),

        // ===== PRIORITY LIST =====
        if (expanded)
          Container(
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: items.map((item) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      // ===== PRIORITY INPUT =====
                      SizedBox(
                        width: 60,
                        child: TextFormField(
                          initialValue: priorityMap[item]?.toString() ?? "",
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          decoration: const InputDecoration(
                            counterText: "",
                            hintText: "1–5",
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (value) {
                            final num = int.tryParse(value);
                            if (num != null && num >= 1 && num <= 5) {
                              setState(() {
                                priorityMap[item] = num;
                              });
                            } else {
                              setState(() {
                                priorityMap[item] = null;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

        const SizedBox(height: 30),
      ],
    );
  }
}
