import 'package:flutter/material.dart';

import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- Colors ---
    const primary = Color(0xFF3D5AFE); // Indigo blue
    const background = Color(0xFFF6F7FB); // Light lavender
    const fabPink = Color(0xFFFF66C4); // Accent
    const textPrimary = Color(0xFF0A0A0A);
    const textSecondary = Color(0xFF707070);
    const success = Color(0xFF5BE3A4); // Online dot green

    // --- Chat list data (typed properly) ---
    final List<Map<String, dynamic>> chats = [
      {
        "name": "Shane Martinez",
        "message": "On my way home but I needed to stop by the book store...",
        "time": "5 min",
        "unread": 1,
        "online": true,
        "avatar": "https://randomuser.me/api/portraits/men/31.jpg",
      },
      {
        "name": "Katie Keller",
        "message": "I'm watching Friends. What are you doing?",
        "time": "15 min",
        "unread": 0,
        "online": true,
        "avatar": "https://randomuser.me/api/portraits/women/44.jpg",
      },
      {
        "name": "Stephen Mann",
        "message": "I'm working now. I'm making a deposit for our company.",
        "time": "1 hour",
        "unread": 0,
        "online": false,
        "avatar": "https://randomuser.me/api/portraits/men/76.jpg",
      },
      {
        "name": "Melvin Pratt",
        "message": "Great seeing you. I'll talk to you later.",
        "time": "5 hour",
        "unread": 0,
        "online": false,
        "avatar": "https://randomuser.me/api/portraits/men/64.jpg",
      },
    ];

    // --- Scaffold ---
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          "Messages",
          style: TextStyle(
            color: textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: textPrimary, size: 26),
            onPressed: () {},
          ),
        ],
      ),

      // --- Chat List ---
      body: ListView.builder(
        itemCount: chats.length,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemBuilder: (context, index) {
          final chat = chats[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

              // Avatar + online dot
              leading: Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage:
                        NetworkImage(chat["avatar"] as String), // fixed typing
                  ),
                  if (chat["online"] == true)
                    Positioned(
                      bottom: 3,
                      right: 3,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: success,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),

              // Name + message
              title: Text(
                chat["name"] as String,
                style: const TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Text(
                chat["message"] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: textSecondary, fontSize: 14),
              ),

              // Time + unread bubble
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chat["time"] as String,
                    style: const TextStyle(color: textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 6),
                  if ((chat["unread"] as int) > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        (chat["unread"] as int).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // Tap -> chat details (to be added later)
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      name: chat["name"] as String,
                      avatarUrl: chat["avatar"] as String,
                    ),
                  ),
                );
              },

            ),
          );
        },
      ),

      // --- Bottom Navigation ---
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.chat_bubble_outline, color: primary, size: 26),
            Icon(Icons.person_outline, color: textSecondary, size: 26),
            Icon(Icons.settings_outlined, color: textSecondary, size: 26),
          ],
        ),
      ),

      // --- Floating Action Button ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabPink,
        onPressed: () {},
        child: const Icon(Icons.add, size: 30, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
