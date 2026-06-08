import 'package:flutter/material.dart';
import 'package:sound_app/pages/category_page.dart';
import 'package:sound_app/widgets/category_list.dart';
import 'package:sound_app/pages/settings_page.dart';
import 'package:sound_app/viewmodels/command_view_model.dart';
import 'package:sound_app/providers/bluetooth_controller.dart';
import 'package:sound_app/repositories/command_repository.dart';

class HomePage extends StatefulWidget {
  final BluetoothController btController;

  const HomePage({super.key, required this.btController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CommandViewModel viewModel;

  String selectedCategory = "Home";

  @override
  void initState() {
    super.initState();

    viewModel = CommandViewModel(
      btController: widget.btController,
    );
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case "City":
        return Colors.blue;
      case "Walk":
        return Colors.green;
      case "Sports":
        return Colors.indigo;
      case "Home":
        return Colors.orange;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SettingsPage(btController: widget.btController),
            ),
          );
        },
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.settings, color: Colors.black),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/wip_kutyanyakorv.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: CategoryList(
                        selectedCategory: selectedCategory,
                        onCategorySelected: (category) {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    flex: 1,
                    child: CategoryPage(
                      title: selectedCategory,
                      key: ValueKey(selectedCategory),
                      commands:
                      CommandRepository.getCommands(selectedCategory),
                      color: getCategoryColor(selectedCategory),
                      viewModel: viewModel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }
}