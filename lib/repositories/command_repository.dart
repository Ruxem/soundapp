import '../providers/command.dart';

class CommandRepository {
  static List<Command> getCommands(String category) {
    final List<Command> commands;

    switch (category) {
      case "Home":
        commands = [
          Command(
            id: "home_gyereide",
            name: "Gyere ide!",
            type: 6,
            volume: 80,
            level: 2,
            soundFile: "Gyereide.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "home_sicc",
            name: "Sicc!",
            type: 1,
            volume: 75,
            level: 2,
            soundFile: "Sicc.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "home_helyed",
            name: "Helyed?",
            type: 7,
            volume: 70,
            level: 3,
            soundFile: "Helyed.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "home_keresd",
            name: "Keresd!",
            type: 3,
            volume: 65,
            level: 2,
            soundFile: "Keresd.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "home_hozd",
            name: "Hozd!",
            type: 8,
            volume: 85,
            level: 1,
            soundFile: "Hozd.mp3",
            isCustom: false,
            bytes: null,
          ),
        ];
        break;

      case "City":
        commands = [
          Command(
            id: "city_tapad",
            name: "Tapad!",
            type: 1,
            volume: 80,
            level: 2,
            soundFile: "Tapad.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "city_ul",
            name: "Ül!",
            type: 6,
            volume: 80,
            level: 2,
            soundFile: "Ül.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "city_lazan",
            name: "Lazán",
            type: 8,
            volume: 85,
            level: 1,
            soundFile: "Lazan.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "city_marad",
            name: "Marad!",
            type: 3,
            volume: 65,
            level: 2,
            soundFile: "Marad.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "city_nezzram",
            name: "Nézz rám!",
            type: 7,
            volume: 70,
            level: 3,
            soundFile: "Nézzrám.mp3",
            isCustom: false,
            bytes: null,
          ),
        ];
        break;

      case "Walk":
        commands = [
          Command(
            id: "walk_tapad",
            name: "Tapad!",
            type: 1,
            volume: 80,
            level: 2,
            soundFile: "Tapad.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "walk_lazan",
            name: "Lazán",
            type: 8,
            volume: 85,
            level: 1,
            soundFile: "Lazan.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "walk_ul",
            name: "Ül!",
            type: 6,
            volume: 80,
            level: 2,
            soundFile: "Ül.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "walk_nezzram",
            name: "Nézz rám!",
            type: 7,
            volume: 70,
            level: 3,
            soundFile: "Nézzrám.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "walk_fekszik",
            name: "Fekszik!",
            type: 9,
            volume: 70,
            level: 2,
            soundFile: "Szuper!.mp3",
            isCustom: false,
            bytes: null,
          ),
        ];
        break;

      case "Sports":
        commands = [
          Command(
            id: "sports_tapad",
            name: "Tapad!",
            type: 1,
            volume: 80,
            level: 2,
            soundFile: "Tapad.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "sports_szlalom",
            name: "Szlalom",
            type: 2,
            volume: 75,
            level: 3,
            soundFile: "Szlalom.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "sports_marad",
            name: "Marad!",
            type: 3,
            volume: 70,
            level: 2,
            soundFile: "Marad.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "sports_kerul",
            name: "Kerül",
            type: 4,
            volume: 65,
            level: 1,
            soundFile: "Kerul.mp3",
            isCustom: false,
            bytes: null,
          ),
          Command(
            id: "sports_forog",
            name: "Forog",
            type: 5,
            volume: 85,
            level: 2,
            soundFile: "Forog.mp3",
            isCustom: false,
            bytes: null,
          ),
        ];
        break;

      default:
        commands = [];
    }

    return commands;
  }
}