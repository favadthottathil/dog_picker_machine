import 'package:dog_picker/Model/dog_image_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseController {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _databaseInit();

    return _database!;
  }

  Future<Database> _databaseInit() async {
    try {
      final dbPath = await getDatabasesPath();

      String path = join(dbPath, 'database.db');

      var db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute(
        'CREATE TABLE dog_images(id INTEGER PRIMARY KEY, imageUrl TEXT)',
      );
    } catch (e) {
      throw '$e';
    }
  }

  Future<void> saveDogImages(String imageUrl) async {
    try {
      final db = await database;

      List<DogImageModel> imageUrls = await getDogImages();

      for (var dogImageModel in imageUrls) {
        if (dogImageModel.imageUrl == imageUrl) {
          return;
        }
      }

      final dogImage = DogImageModel(id: DateTime.now().millisecondsSinceEpoch, imageUrl: imageUrl);

      await db.transaction((txn) async {
        txn.insert(
          'dog_images',
          dogImage.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      });
    } catch (e) {
      throw '$e';
    }
  }

  Future<List<DogImageModel>> getDogImages() async {
    try {
      final db = await database;

      final List<Map<String, dynamic>> data = await db.query('dog_images');

      return List.generate(data.length, (index) => DogImageModel.formJson(data[index]));
    } catch (e) {
      throw '$e';
    }
  }
}
