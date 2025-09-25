import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(
          "Cài đặt",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: CupertinoColors.label, // chữ đậm, rõ trên nền trắng
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 10),
            const CupertinoListTile(
              leading: Icon(CupertinoIcons.settings, color: CupertinoColors.systemGrey),
              title: Text(
                "Cài đặt ứng dụng",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1),
            // Dark Mode
            StatefulBuilder(
              builder: (context, setState) {
                bool isDark = false;
                return CupertinoListTile(
                  leading: const Icon(CupertinoIcons.moon_stars, color: CupertinoColors.systemGrey),
                  title: const Text(
                    "Chế độ tối",
                    style: TextStyle(color: CupertinoColors.label),
                  ),
                  trailing: CupertinoSwitch(
                    value: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                        // TODO: lưu theme vào SharedPreferences
                      });
                    },
                  ),
                );
              },
            ),
            const Divider(height: 1, thickness: 1),
            // Thông báo
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.bell, color: CupertinoColors.systemGrey),
              title: const Text(
                "Thông báo",
                style: TextStyle(color: CupertinoColors.label),
              ),
              trailing: const Icon(CupertinoIcons.forward, size: 16),
              onTap: () {
                // mở trang cấu hình thông báo
              },
            ),
            const Divider(height: 1, thickness: 1),
            // Thông tin ứng dụng
            CupertinoListTile(
              leading: const Icon(CupertinoIcons.info, color: CupertinoColors.systemGrey),
              title: const Text(
                "Thông tin ứng dụng",
                style: TextStyle(color: CupertinoColors.label),
              ),
              subtitle: const Text(
                "Phiên bản 1.0.0",
                style: TextStyle(color: CupertinoColors.systemGrey),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
