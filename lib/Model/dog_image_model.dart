class DogImageModel {
  final int id;

  final String imageUrl;

  DogImageModel({required this.id, required this.imageUrl});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl
    };
  }

  factory DogImageModel.formJson(Map<String, dynamic> map) {
    return DogImageModel(
      id: map['id'],
      imageUrl: map['imageUrl'],
    );
  }

  
}
