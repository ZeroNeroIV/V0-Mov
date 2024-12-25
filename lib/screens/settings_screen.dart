// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:m0viewer/services/auth_service.dart';
import 'package:m0viewer/services/theme_service.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(authService.isSignedIn
                ? 'Logged in as ${authService.userDisplayName}'
                : 'Log in with Google'),
            leading: authService.isSignedIn && authService.userPhotoUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(authService.userPhotoUrl!))
                : Icon(Icons.account_circle),
            onTap: () async {
              if (authService.isSignedIn) {
                await authService.signOut();
              } else {
                try {
                  await authService.signInWithGoogle();
                } catch (e) {
                  print('Failed to sign in with Google: $e');
                }
              }
            },
          ),
          ListTile(
            title: Text('Theme'),
            trailing: DropdownButton<AppThemeMode>(
              value: themeService.themeMode,
              onChanged: (AppThemeMode? newValue) {
                if (newValue != null) {
                  themeService.setThemeMode(newValue);
                }
              },
              items: AppThemeMode.values.map((AppThemeMode mode) {
                return DropdownMenuItem<AppThemeMode>(
                  value: mode,
                  child: Text(mode.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text('Display Style'),
            trailing: DropdownButton<DisplayStyle>(
              value: themeService.displayStyle,
              onChanged: (DisplayStyle? newValue) {
                if (newValue != null) {
                  themeService.setDisplayStyle(newValue);
                }
              },
              items: DisplayStyle.values.map((DisplayStyle style) {
                return DropdownMenuItem<DisplayStyle>(
                  value: style,
                  child: Text(style.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          Text('Choose Primary Color'),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: Colors.primaries.map((color) {
              return GestureDetector(
                onTap: () {
                  themeService.setPrimaryColor(color);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border.all(
                      color: themeService.primaryColor == color
                          ? Colors.black
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          Text('Choose Accent Color'),
          SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: [
              ...Colors.accents.map((color) {
                return GestureDetector(
                  onTap: () {
                    themeService.setAccentColor(color);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: themeService.accentColor == color
                            ? Colors.black
                            : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                );
              })
            ],
          ),
        ],
      ),
    );
  }
}
