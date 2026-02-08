import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Жүйеге кіріңіз',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AuthScreen()),
                      );
                    },
                    child: const Text('Кіру'),
                  ),
                ],
              ),
            );
          }

          final user = auth.user!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // User Avatar
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 32),

                // Menu Items
                _MenuItem(
                  icon: Icons.receipt_long,
                  title: 'Тапсырыстар',
                  onTap: () {
                    // TODO: Navigate to orders
                  },
                ),
                _MenuItem(
                  icon: Icons.location_on,
                  title: 'Мекенжайлар',
                  onTap: () {
                    // TODO: Navigate to addresses
                  },
                ),
                _MenuItem(
                  icon: Icons.credit_card,
                  title: 'Төлем әдістері',
                  onTap: () {
                    // TODO: Navigate to payment methods
                  },
                ),
                _MenuItem(
                  icon: Icons.settings,
                  title: 'Баптаулар',
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                _MenuItem(
                  icon: Icons.help,
                  title: 'Көмек',
                  onTap: () {
                    // TODO: Navigate to help
                  },
                ),
                const Divider(height: 32),
                _MenuItem(
                  icon: Icons.logout,
                  title: 'Шығу',
                  isDestructive: true,
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Шығу'),
                        content: const Text('Шынымен шығғыңыз келе ме?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Жоқ'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Иә'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await auth.signOut();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red : null;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: onTap,
    );
  }
}
