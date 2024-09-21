import 'package:ecomapp/providers/products_provider.dart';
import 'package:ecomapp/screens/product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override

  //Lists
  //List<String> favourites = ProductScreenState.favourites;
  List<dynamic> products = [];
  List<dynamic> favouriteProducts = [];
  List<String> favourites = [];

  bool isLoading = false;
  bool isError = false;
  bool isAlwaysLoading = true;
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontFamily: 'ClashDisplay',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Center(
          child: Column(
            children: [
              isLoading ? fakeGrids(screenWidth) : actualGrids(screenWidth),
            ],
          ),
        ),
      ),
    );
  }

  Expanded fakeGrids(double screenWidth) {
    return Expanded(
      child: GridView.builder(
          padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1 / 1.3),
          itemBuilder: (context, index) {
            return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Skeletonizer(
                  effect: const ShimmerEffect(
                      baseColor: Color.fromARGB(255, 230, 230, 230),
                      highlightColor: Color.fromARGB(255, 210, 210, 210),
                      duration: Duration(milliseconds: 1200),
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  containersColor: const Color.fromARGB(255, 35, 35, 35),
                  ignoreContainers: false,
                  enabled: isAlwaysLoading,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 0.35 * screenWidth,
                        height: 0.35 * screenWidth,
                        decoration: const BoxDecoration(
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://i.sstatic.net/mwFzF.png',
                            ),
                          ),
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Men's T-Shirt Wear",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            'Full Price',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ],
                  ),
                ));
          }),
    );
  }

  Expanded actualGrids(double screenWidth) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
        itemCount: favouriteProducts.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1 / 1.3),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              final productsProvider =
                  Provider.of<ProductsProvider>(context, listen: false);
              productsProvider.setProductDetails(
                favouriteProducts[index]['id'].toString(),
                favouriteProducts[index]['title'].toString(),
                favouriteProducts[index]['price'].toString(),
                favouriteProducts[index]['description'].toString(),
                favouriteProducts[index]['category'].toString(),
                favouriteProducts[index]['image'].toString(),
                favouriteProducts[index]['rating'].toString(),
                favouriteProducts[index]['isFavourite'] ?? false,
              );

              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => ProductScreen(),
                ),
              );
            },
            child: Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 3, bottom: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 0.35 * screenWidth,
                      height: 0.35 * screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                          image:
                              NetworkImage(favouriteProducts[index]['image']),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          favouriteProducts[index]['title'].split(' ')[0] +
                              ' ' +
                              favouriteProducts[index]['title'].split(' ')[1] +
                              ' ' +
                              favouriteProducts[index]['title'].split(' ')[2],
                          style: const TextStyle(
                            fontFamily: 'ClashDisplay',
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\$${favouriteProducts[index]['price'].toString()}',
                          style: const TextStyle(
                            fontFamily: 'ClashDisplay',
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Future<void> loadProducts() async {
    setState(() {
      isLoading = true;
    });
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final response = await productsProvider.getProducts();
    if (response[0]['message'] != null) {
      setState(() {
        isError = true;
      });
    } else {
      setState(() {
        products = response;

        filterItems(products);
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void filterItems(List<dynamic> Products) async {
    favourites = await getFavouriteProducts();

    List<dynamic> filteredProducts = Products.where((item) {
      return favourites.contains(item['id'].toString()); //
    }).toList();

    setState(() {
      favouriteProducts = filteredProducts;
    });
  }

  Future<List<String>> getFavouriteProducts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favourite_products') ?? [];
  }
}
