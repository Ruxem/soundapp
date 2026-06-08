import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/command.dart';
import '../providers/file_handler.dart';
import '../viewmodels/command_view_model.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  final List<Command> commands;
  final CommandViewModel viewModel;
  final Color color;

  const CategoryPage({
    super.key,
    required this.title,
    required this.commands,
    required this.viewModel,
    required this.color,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Map<String, Command> customMap;

  @override
  void initState() {
    super.initState();
    customMap = {};
    load();
  }

  String _cleanName(String input) {
    final file = input.split(RegExp(r'[\\/]')).last;
    return file.replaceAll('.mp3', '');
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList("custom_${widget.title}");
    if (data == null) return;
    final map = <String, Command>{};
    for (final item in data) {
      if (item == "null") continue;
      final d = Command.fromJson(item);
      map[d.id] = d;
    }
    setState(() {
      customMap = map;
    });
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      "custom_${widget.title}",
      customMap.values.map((cmd) => cmd.toJson()).toList(),
    );
  }

  Future<void> pickFile(String placeholderId) async {
    final pickedFile = await FileHandler.pickAudioFile();
    if (pickedFile == null) return;

    Uint8List? bytes;
    String fileName;

    if (kIsWeb) {
      bytes = pickedFile.bytes;
      fileName = _cleanName(pickedFile.name);
    } else {
      bytes = null;
      fileName = _cleanName(pickedFile.path!);
    }

    final newCmd = Command(
      id: placeholderId,
      name: fileName,
      type: 99,
      volume: 80,
      level: 1,
      soundFile: kIsWeb ? fileName : pickedFile.path!,
      bytes: bytes,
      isCustom: true,
    );

    setState(() {
      customMap[placeholderId] = newCmd;
    });
    await save();
  }

  void showMenuAt(BuildContext context, Command command, Offset pos) async {
    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;
    final value = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(pos.dx, pos.dy, 0, 0),
        Offset.zero & overlay.size,
      ),
      items: const [
        PopupMenuItem(value: "edit", child: Text("Edit")),
        PopupMenuItem(value: "delete", child: Text("Delete")),
      ],
    );
    if (value == "edit") {
      await pickFile(command.id);
    } else if (value == "delete") {
      setState(() {
        customMap.remove(command.id);
      });
      await save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseCommands = [...widget.commands];

    final nemCommand = Command(
      id: 'nem_button',
      name: 'Nem!',
      type: 0,
      volume: 80,
      level: 1,
      soundFile: 'Nem!.mp3',
    );

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(8, 150, 8, 20),
      itemCount: baseCommands.length + 1,
      itemBuilder: (context, index) {
        if (index == baseCommands.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () => widget.viewModel.execute(nemCommand),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text(
                    "Nem!",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        }

        final base = baseCommands[index];
        final placeholderId = 'plus_${base.id}';
        final leftCmd = customMap[base.id];
        final rightCmd = customMap[placeholderId];

        return Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: leftCmd != null
                      ? () => widget.viewModel.execute(leftCmd)
                      : () => widget.viewModel.execute(base),
                  onSecondaryTapDown: (d) {
                    if (leftCmd != null) {
                      showMenuAt(context, leftCmd, d.globalPosition);
                    } else {
                      showMenuAt(context, base, d.globalPosition);
                    }
                  },
                  onLongPress: () {
                    final box = context.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);
                    if (leftCmd != null) {
                      showMenuAt(context, leftCmd, pos);
                    } else {
                      showMenuAt(context, base, pos);
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: leftCmd != null
                          ? widget.color.withOpacity(0.7)
                          : widget.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        leftCmd != null
                            ? _cleanName(leftCmd.name)
                            : _cleanName(base.name),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: rightCmd != null
                      ? () => widget.viewModel.execute(rightCmd)
                      : () => pickFile(placeholderId),
                  onSecondaryTapDown: rightCmd != null
                      ? (d) => showMenuAt(context, rightCmd, d.globalPosition)
                      : null,
                  onLongPress: rightCmd != null
                      ? () {
                    final box =
                    context.findRenderObject() as RenderBox;
                    final pos = box.localToGlobal(Offset.zero);
                    showMenuAt(context, rightCmd, pos);
                  }
                      : null,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: rightCmd != null
                          ? widget.color.withOpacity(0.7)
                          : widget.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: rightCmd != null
                          ? Text(_cleanName(rightCmd.name))
                          : const Icon(Icons.add),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}