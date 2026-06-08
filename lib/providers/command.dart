import 'dart:typed_data';
import 'dart:convert';

class Command {
  final String id;
  final String name;
  final int type;
  final int volume;
  final int level;
  final String soundFile;
  final bool isCustom;
  final Uint8List? bytes;

  Command({
    required this.id,
    required this.name,
    required this.type,
    required this.volume,
    required this.level,
    required this.soundFile,
    this.isCustom = false,
    this.bytes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'volume': volume,
      'level': level,
      'soundFile': soundFile,
      'isCustom': isCustom,
      'bytes': bytes?.toList(),
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Command.fromMap(Map<String, dynamic> map) {
    return Command(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      volume: map['volume'],
      level: map['level'],
      soundFile: map['soundFile'],
      isCustom: map['isCustom'] ?? false,
      bytes: map['bytes'] != null
          ? Uint8List.fromList(List<int>.from(map['bytes']))
          : null,
    );
  }

  factory Command.fromJson(String source) => Command.fromMap(jsonDecode(source));

  Uint8List toByteList() {
    final idBytes = utf8.encode(id);
    final typeBytes = [type];
    final volumeBytes = [volume];
    final levelBytes = [level];
    return Uint8List.fromList([...idBytes, ...typeBytes, ...volumeBytes, ...levelBytes]);
  }
}