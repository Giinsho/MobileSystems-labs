import 'dart:io';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Database.dart';
import 'Product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  // HttpOverrides.global = MyHttpOverrides();
  // runApp(MyApp(products: fetchProducts()));
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp(products: SQLiteDbProvider.db.getAllProducts()));

}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host,
          int port) => true;
  }
}


List<Product> parseProducts(String responseBody) {

//dekodowanie danych JSON do obiektu Dart Map. Po zdekodowaniu danych JSON zostaną one rzutowane na List<Product> przy użyciu fromMap klasy Product.

  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Product>((json) => Product.fromMap(json)).toList();
}

Future<List<Product>> fetchProducts() async {
  final uri = Uri.parse('https:terlikowski.ii.uph.edu.pl/products.json');
  final response = await http.get(uri);
  if (response.statusCode == 200) {
    print("response.statusCode ${response.statusCode}");
    return parseProducts(response.body);
  } else {
    throw Exception('Unable to fetch products from the REST API');
  }
}


class MyApp extends StatelessWidget {
  final Future<List<Product>> products;
  MyApp({Key? key, required this.products}) : super(key: key);
  // This widget is the root of your application.
  @override Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: MyHomePage(title: 'Product home page',products: products,),);
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title, required this.products}) : super(key: key);
  final String title;
  final Future<List<Product>> products;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(title: Text("Product Navigation")),
        body: Center(
          child: FutureBuilder<List<Product>>(
            future: products,
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ProductBoxList(
                  products: snapshot.requireData) // return the ListView widget
                  : Center(child: CircularProgressIndicator());
            },
          ),
        ));
  }

//final products = Product.getProducts();

  // @override Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(title: Text(this.title),),
  //     body: ListView.builder(
  //       itemCount: products.length,
  //       itemBuilder: (context, index) {
  //         return GestureDetector(
  //           child: ProductBox(product: products[index]),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => ProductDetailsPage(product: products[index]),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //
  //     )
  //
  //
  //   );
  //
  //
  // }
}

class ProductBoxList extends StatelessWidget {
  final List<Product> products;

  ProductBoxList({Key? key, required this.products});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ProductBox(product: products[index]),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProductDetailsPage(product: products[index]),
              ),
            );
          },
        );
      },
    );
  }
}


class ProductBox extends StatelessWidget {
  ProductBox({Key? key, required this.product}) : super(key: key);

  final Product product;

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2),
        height: 120,
        child: Card(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Image.memory(base64Decode(this.product.image)),
                  //Image.asset("assets/appimages/" + product.image),
                  Expanded(
                      child: Container(
                          padding: EdgeInsets.all(5),
                          child: ScopedModel<Product>(
                          model: this.product,
    child: Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
    Text(this.product.name,
    style:
    TextStyle(fontWeight: FontWeight.bold)),
    Text(this.product.description),
    Text("Price: " + this.product.price.toString()),
    ScopedModelDescendant<Product>(
        builder: (context, child, item) {
          return RatingBox(product: item);
        })
    ],
    ))

    ))

                ])));
  }
}

class RatingBox extends StatelessWidget {

  RatingBox({Key? key, required this.product}) : super(key: key);

  final Product product;
  @override
  _ProductDetailsPageState createState() => new _ProductDetailsPageState(product);
//Funkcja build wcześniej była w _RatingBoxState
  @override
  Widget build(BuildContext context) {
    double _size = 20;
    print(product.rating);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (Icon(product.rating >= 1 ? Icons.star : Icons.star_border,
                size: _size)),
            color: Colors.red[500],
            iconSize: _size,
            onPressed: () => {product.updateRating(1)},
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (Icon(product.rating >= 2 ? Icons.star : Icons.star_border,
                size: _size)),
            color: Colors.green[500],
            iconSize: _size,
            onPressed: () => {product.updateRating(2)},
          ),
        ),
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (Icon(product.rating >= 3 ? Icons.star : Icons.star_border,
                size: _size)),
            color: Colors.yellow[500],
            iconSize: _size,
            onPressed: () => {product.updateRating(3)},
          ),
        ),
      ],
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({Key? key, required this.product}) : super(key: key);
  final Product product;

  @override
  State<StatefulWidget> createState() => new _ProductDetailsPageState(product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.product.name),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.memory(base64Decode(this.product.image)),
                //Image.asset("assets/appimages/" + this.product.image) ,
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(this.product.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(this.product.description),
                            Text("Price: " + this.product.price.toString()),
                            RatingBox(product:product),
                          ],
                        )))
              ]),
        ),
      ),
    );
  }
}

class _ProductDetailsPageState extends State<ProductDetailsPage> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final Product product;

  _ProductDetailsPageState(this.product);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(milliseconds: 350), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return MyAnimatedWidget(child: Scaffold(
      appBar: AppBar(
        title: Text(this.product.name),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.memory(base64Decode(this.product.image)),
                //Image.asset("assets/appimages/" + this.product.image),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(this.product.name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(this.product.description),
                            Text("Price: " + this.product.price.toString()),
                            RatingBox(product:product),
                          ],
                        )))
              ]),
        ),
      ),
    ) , animation: animation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}





class MyAnimatedWidget extends StatelessWidget {
  MyAnimatedWidget({required this.child, required this.animation});

  final Widget child;//widżet podrzędny, na którym będzie wykonana animacja
  final Animation<double> animation;//obiekt animacji

  Widget build(BuildContext context) => Center(
  child: AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Container(
        child: Opacity(opacity: animation.value, child: child),
      ),
      child: child),
  );
}

