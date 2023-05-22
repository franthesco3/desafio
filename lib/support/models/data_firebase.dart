class FirebaseData {
  Map<String, Item> items;

  FirebaseData({required this.items});

  factory FirebaseData.fromJson(Map<String, dynamic> json) {
    final items = json.map((key, value) {
      return MapEntry(key, Item.fromJson(value));
    });

    return FirebaseData(items: items);
  }
}

class Item {
  final String image;
  final String title;
  final bool favorite;

  Item({required this.image, required this.title, required this.favorite});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      image: json['image'],
      title: json['title'],
      favorite: json['favorite'],
    );
  }
}
