import 'package:ecomapp/providers/products_provider.dart';
import 'package:ecomapp/screens/favourites_screen.dart';
import 'package:ecomapp/screens/product_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controllers
  TextEditingController searchController = TextEditingController();

  //Booleans
  bool isAlwaysLoading = true;
  bool isError = false;
  bool isSearching = false;
  bool isLoading = true;

  //Lists
  List<dynamic> products = [];
  List<dynamic> searchedProducts = [];

  //Others
  FocusNode? searchFocus = FocusNode();

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
      appBar: appbar(context),
      body: Padding(
        padding:
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: isSearching ? 1 : 0,
              duration: const Duration(milliseconds: 1500),
              child: isSearching ? searchBar() : Container(),
            ),
            isSearching
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            Expanded(
              child:
                  isLoading ? fakeGrids(screenWidth) : actualGrids(screenWidth),
            ),
          ],
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
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: IconButton(
            onPressed: () {
              setState(() {
                HapticFeedback.selectionClick();
                searchController.text = '';
                searchedProducts = products;
                isSearching = !isSearching;
              });
            },
            icon: isSearching
                ? const Icon(
                    (Icons.close),
                  )
                : const Icon(Icons.search)),
      ),
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

  Container searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        border: const Border(
          top: BorderSide(
            color: Colors.black,
            width: 0.75,
          ),
          right: BorderSide(
            color: Colors.black,
            width: 0.75,
          ),
          bottom: BorderSide(
            color: Colors.black,
            width: 4, // No border
          ),
          left: BorderSide(
            color: Colors.black,
            width: 0.75, // No border
          ),
        ),
      ),
      child: TextField(
        autofocus: true,
        cursorColor: Colors.black,
        cursorWidth: 1.5,
        cursorHeight: 20,
        cursorOpacityAnimates: true,
        controller: searchController,
        keyboardAppearance: Brightness.dark,
        focusNode: searchFocus,
        keyboardType: TextInputType.name,
        onChanged: (value) {
          _searchItems(value);
        },
        style: const TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontFamily: 'ClashDisplay',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        decoration: const InputDecoration(
          fillColor: Color(0xFF808080),
          contentPadding:
              EdgeInsets.only(top: 12, bottom: 12, left: 15, right: 15),
          hintText: 'Search by Name',
          hintStyle: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            fontFamily: 'ClashDisplay',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  GridView actualGrids(double screenWidth) {
    return GridView.builder(
        padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
        itemCount: searchedProducts.length,
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
                searchedProducts[index]['title'].toString(),
                searchedProducts[index]['price'].toString(),
                searchedProducts[index]['description'].toString(),
                searchedProducts[index]['category'].toString(),
                searchedProducts[index]['image'].toString(),
                searchedProducts[index]['rating'].toString(),
                searchedProducts[index]['isFavourite'] ?? false,
              );

              isSearching = false;

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
                    Hero(
                      tag: 'Product ${searchedProducts[index]['title']}',
                      child: Container(
                        width: 0.35 * screenWidth,
                        height: 0.35 * screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image:
                                NetworkImage(searchedProducts[index]['image']),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchedProducts[index]['title'].split(' ')[0] +
                              ' ' +
                              searchedProducts[index]['title'].split(' ')[1] +
                              ' ' +
                              searchedProducts[index]['title'].split(' ')[2],
                          style: const TextStyle(
                            fontFamily: 'ClashDisplay',
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          '\$${searchedProducts[index]['price'].toString()}',
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
        });
  }

  GridView fakeGrids(double screenWidth) {
    return GridView.builder(
        padding: const EdgeInsets.only(top: 10, left: 0, right: 0),
        itemCount: 8,
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
        });
  }

  void _searchItems(String query) {
    List<dynamic> filteredProducts = products.where((item) {
      return item['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      searchedProducts = filteredProducts;
    });
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
        searchedProducts = products;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
