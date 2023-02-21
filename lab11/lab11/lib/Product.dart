import 'package:scoped_model/scoped_model.dart';


class Product extends Model {
  final String name;
  String description;
  int price;
  String image;
  //pozostałe właściwości
  int rating;
  late int id;//pole identyfikatora
  static final columns = ["id", "name", "description", "price", "image", "rating"];//nazwy kolumn
  Map<String, dynamic> toMap() => { "id": id, "name": name, "description": description, "price": price, "image": image, "rating": rating };//serializacja obiektu do JSON.

  Product(this.name, this.description, this.price, this.image, this.rating);

  //Konstruktor fabrykujący
  factory Product.fromMap(Map<String, dynamic> json) {
    return Product(
      json['name'],
      json['description'],
      json['price'],
      json['image'],
      json['rating'],
    );
  }

  void updateRating(int myRating) {
    rating = myRating;
    notifyListeners();
  }

  static List<Product> getProducts() {
    List<Product> items = <Product>[];
    items.add(Product("Pixel", "Pixel is the most feature-full phone ever", 800, "pixel.png", 0));
    items.add(Product("Laptop", "Laptop is most productive development tool", 2000, "laptop.png", 0));
    items.add(Product("Tablet", "Tablet is the most useful device ever for meeting", 1500, "tablet.png", 0));
    items.add(Product("Pendrive", "Pendrive is useful storage medium", 100, "pendrive.png", 0));
    items.add(Product("Floppy Drive", "Floppy drive is useful rescue storage medium", 20, "floppy.png", 0));
//Pozostałe produkty
    return items;
  }


}
