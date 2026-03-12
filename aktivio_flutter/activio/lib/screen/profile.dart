import '../basics/drawer.dart';
import 'data.dart';
import 'main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        if (_profileImage != null) {
          avatarImage = FileImage(_profileImage!);
        }
      });
    }
    await uploadProfile(imageFile: _profileImage!);
  }

  ImageProvider avatarImage = const AssetImage('images/user.jpg');
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@email.com");

  final TextEditingController _ageController =
      TextEditingController(text: "20");

  final TextEditingController _cityController = TextEditingController(text: "");

  final TextEditingController _countryController =
      TextEditingController(text: "");
  String image = "";
  String name = "";
  String email = "";
  String age = "";
  String city = "";
  String country = "";

  Future<void> profile() async {
    final response = await http.post(
      Uri.parse("https://developer25.pythonanywhere.com/profile"),
      //Uri.parse("http://10.0.2.2:5000/profile"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "user_id": Data.user_id.toString(),
        "flutter": "yes",
      },
    );
    final result = jsonDecode(response.body);
    print(result);
    setState(() {
      if (result["prof"][5] != null) {
        image = "https://developer25.pythonanywhere.com/static/" +
            result["prof"][5];
      } else {
        image = "images/users.jpg";
      }

      if (_profileImage != null) {
        avatarImage = FileImage(_profileImage!);
      } else if (result["prof"][5] != null) {
        avatarImage = NetworkImage(image);
      } else {
        avatarImage = const AssetImage('images/user.jpg');
      }
      Data.avatarImage = avatarImage;
      name = result["prof"][0];

      email = result["prof"][1];
      age = result["prof"][2].toString();
      city = result["prof"][3] ?? "";
      country = result["prof"][4] ?? "";
      _nameController.text = name;
      _emailController.text = email;
      _ageController.text = age;
      _cityController.text = city;
      _countryController.text = country;
    });
  }

  Future<void> uploadProfile({
    required File imageFile,
  }) async {
    //final uri = Uri.parse("http://10.0.2.2:5000/edit_action");
    final uri = Uri.parse("https://developer25.pythonanywhere.com/edit_action");

    var request = http.MultipartRequest("POST", uri);
    request.fields["img_url"] = "images/${basename(imageFile.path)}";
    request.fields["flutter"] = "img_yes";
    request.fields["user_id"] = Data.user_id.toString();
    request.files.add(
      await http.MultipartFile.fromPath(
        "img",
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      print("✅ Profile uploaded successfully");
    } else {
      print("❌ Upload failed: ${response.statusCode}");
    }
  }

  Future<void> upload_data_profile(String name, String email, String age,
      String city, String country) async {
    final response = await http.post(
      Uri.parse("https://developer25.pythonanywhere.com/edit_action"),
      //Uri.parse("http://10.0.2.2:5000/edit_action"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        "user_id": Data.user_id.toString(),
        "flutter": "yes",
        "name": name,
        "age": age,
        "email": email,
        "city": city,
        "country": country
      },
    );
    final result = jsonDecode(response.body);
    print(result);
  }

  @override
  void initState() {
    super.initState();
    profile();
  }

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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: _buildAppBar(context),
        body: Stack(
          children: [
            // Background
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF412B6B),
            ),

            // -------- CENTERED PROFILE CARD --------
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildProfileCard(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= APP BAR =================
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                    child:
                        CircleAvatar(radius: 18, backgroundImage: avatarImage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _buildProfileCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // ⭐ important for centering
          children: [
            Stack(
              children: [
                CircleAvatar(radius: 45, backgroundImage: avatarImage),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: _pickImage,
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Color(0xFF412B6B),
                      child: Icon(Icons.edit, size: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _countryController,
              decoration: const InputDecoration(
                labelText: "Country",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await upload_data_profile(
                  _nameController.text,
                  _emailController.text,
                  _ageController.text,
                  _cityController.text,
                  _countryController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Your data is saved")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF412B6B),
              ),
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
