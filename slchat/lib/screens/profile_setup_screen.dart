import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;

  bool blockAIContent = true;
  bool blockAdultMedia = true;
  bool kidSafeMode = false;
  bool verifiedOnly = false;

  bool _isSaving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

 
 
 void _onContinue() async {
  if (_nameController.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Please enter your display name")),
    );
    return;
  }

  setState(() => _isSaving = true);

  // Simulate saving process
  await Future.delayed(const Duration(seconds: 2));

  // Save locally that setup is complete
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isProfileSetup', true);
  await prefs.setString('displayName', _nameController.text.trim());

  setState(() => _isSaving = false);

  // ✅ Navigate to HomeScreen and remove previous pages
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const HomeScreen()),
    (route) => false,
  );
}


  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF3D5AFE);
    const background = Color(0xFFF6F7FB);
    const textPrimary = Color(0xFF0A0A0A);
    const textSecondary = Color(0xFF707070);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Profile Setup",
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Profile image
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primary.withOpacity(0.1),
                      backgroundImage:
                          _selectedImage != null ? FileImage(_selectedImage!) : null,
                      child: _selectedImage == null
                          ? const Icon(Icons.camera_alt_outlined,
                              size: 36, color: primary)
                          : null,
                    ),
                    if (_selectedImage != null)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(Icons.edit, size: 16, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Set up your public profile",
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),

              // Name field
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: "Display Name",
                  hintText: "Enter your name",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: primary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Privacy preferences
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Privacy Preferences",
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),

                    SwitchListTile(
                      activeColor: primary,
                      title: const Text("Block AI-generated content"),
                      subtitle:
                          const Text("Filter messages and media created by AI"),
                      value: blockAIContent,
                      onChanged: (v) => setState(() => blockAIContent = v),
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primary,
                      title: const Text("Block adult / pornographic media"),
                      subtitle:
                          const Text("Protect yourself from sensitive content"),
                      value: blockAdultMedia,
                      onChanged: (v) => setState(() => blockAdultMedia = v),
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primary,
                      title: const Text("Child-safe mode"),
                      subtitle:
                          const Text("Ideal for kids or family devices"),
                      value: kidSafeMode,
                      onChanged: (v) => setState(() => kidSafeMode = v),
                    ),
                    const Divider(),
                    SwitchListTile(
                      activeColor: primary,
                      title: const Text("Allow only verified users to message me"),
                      subtitle:
                          const Text("Block unknown or unverified senders"),
                      value: verifiedOnly,
                      onChanged: (v) => setState(() => verifiedOnly = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Continue button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSaving ? null : _onContinue,
                  child: _isSaving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "Finish Setup",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
