import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/utils/constants.dart';

import '../widgets/add_product_widget.dart';
import '../widgets/weather_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Product> futureProductList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.antiFlashWhite,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "My Product App",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    WeatherInfo(),
                  ],
                ),
                _list(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            context: context,
            builder: (_) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddProductWidget(
                height: MediaQuery.of(context).size.height * 0.9,
                width: MediaQuery.of(context).size.width,
                onProductAdded: (Product newProduct) {
                  if (newProduct.title != null &&
                      newProduct.title!.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('New Product: ${newProduct.title} added'),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _list() {
    return FutureBuilder<List<Product>>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 35, bottom: 10),
                  child: Text(
                    snapshot.data!.length.toString() + " results",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0x80142328),
                    ),
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 1.3),
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _tile(snapshot.data![index]);
                  },
                ),
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Widget _tile(Product product) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.thumbnail != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.network(
                      product.thumbnail!,
                      fit: BoxFit.fill,
                      height: 125,
                    ),
                  )
                : Container(),
            Container(
              padding: const EdgeInsets.only(top: 10, right: 10, bottom: 3),
              child: Text(
                product.title ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff142328),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: const BoxDecoration(
                color: Constants.grey,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                product.brand ?? '',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0x80142328),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                product.price != null ? product.price.toString() + "€" : '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.pacificBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Product>> fetchProducts() async {
    print('fetching data');
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/products.json");
    print('data fetched');
    print(data);
    return (jsonDecode(data)['products'] as List)
        .map((data) => Product.fromJson(data))
        .toList();
  }
}
