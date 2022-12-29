import 'package:coza_admin/banner_screen.dart';
import 'package:coza_admin/banner_upload_screen.dart';
import 'package:coza_admin/products_upload_screen.dart';
import 'package:coza_admin/items_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
      ),
      body: Column(children: [
        ListTile(
          title: const Text('Add products'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const ProductsScreen()),
            ),
          ),
        ),
        ListTile(
          title: const Text('Add Banner'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => const BannerUploadScreen()),
            ),
          ),
        ),
        ListTile(
          title: const Text('View Products'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => ItemsScreen()),
            ),
          ),
        ),
        ListTile(
          title: const Text('View Banners'),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: ((context) => BannerScreen()),
            ),
          ),
        ),
      ]),
    );
  }
}
