import 'package:ecomapp/providers/products_provider.dart';
import 'package:ecomapp/screens/favourites_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => ProductScreenState();
}

class ProductScreenState extends State<ProductScreen> {
  //Maps
  Map<String, dynamic>? product;

  //Booleans
  bool isLoading = true;
  bool isFavourite = false;

  //Strings
  String title = '';
  String price = '';
  String description = '';
  String category = '';
  String image = '';
  //String rating = '';

  static List<String> favourites = [];

  @override
  void initState() {
    super.initState();
    loadProductDetails();

    checkFavourite();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 15, left: 15, right: 15, bottom: 30),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    color: Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 0.001,
                      ),
                      right: BorderSide(
                        color: Colors.black,
                        width: 0.001,
                      ),
                      top: BorderSide(
                        color: Colors.black,
                        width: 0.001,
                      ),
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 8,
                      ),
                    ),
                  ),
                  child: Hero(
                    tag: 'Product ${product!['title']}',
                    child: Container(
                      width: 0.9 * screenWidth,
                      height: 0.9 * screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image: NetworkImage(product!['image']),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 0.7 * screenWidth,
                        child: Text(
                          product!['title'],
                          style: const TextStyle(
                            fontFamily: 'ClashDisplay',
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        child: isFavourite
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavourite = false;
                                  });

                                  removeProductFromFavourites(product!['id']);
                                },
                                icon: const Icon(Icons.favorite),
                                iconSize: 30,
                              )
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    isFavourite = true;
                                  });

                                  addProductToFavourites(product!['id']);
                                },
                                icon: const Icon(Icons.favorite_border),
                                iconSize: 30,
                              ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product!['price']}',
                        style: const TextStyle(
                          fontFamily: 'ClashDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        product!['category'],
                        style: const TextStyle(
                          fontFamily: 'ClashDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'About Product',
                        style: TextStyle(
                          fontFamily: 'ClashDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        product!['description'],
                        style: const TextStyle(
                          //fontFamily: 'ClashDisplay',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Text(
        'NYEH',
        style: TextStyle(
          fontFamily: 'ClashDisplay',
          fontWeight: FontWeight.w500,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: IconButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const FavouritesScreen()));
            },
            icon: const Icon(Icons.favorite_border),
            color: Colors.black,
          ),
        )
      ],
    );
  }

  Future<void> loadProductDetails() async {
    setState(() {
      isLoading = true;
    });
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    product = productsProvider.getProductDetails();
    setState(() {
      isLoading = true;
    });
  }

  Future<void> saveFavouriteProducts(List<String> productIds) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favourite_products', productIds);
  }

  Future<List<String>> getFavouriteProducts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favourite_products') ?? [];
  }

  void addProductToFavourites(String productId) async {
    List<String> favouriteProducts = await getFavouriteProducts();
    if (!favouriteProducts.contains(productId)) {
      favouriteProducts.add(productId);
      await saveFavouriteProducts(favouriteProducts);
    }
  }

  void removeProductFromFavourites(String productId) async {
    List<String> favouriteProducts = await getFavouriteProducts();
    if (favouriteProducts.contains(productId)) {
      favouriteProducts.remove(productId);
      await saveFavouriteProducts(favouriteProducts);
    }
  }

  void checkFavourite() async {
    favourites = await getFavouriteProducts();
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    product = productsProvider.getProductDetails();
    if (favourites.contains(product!['id'])) {
      setState(() {
        isFavourite = true;
      });
    }
  }
}
