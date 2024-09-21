import 'package:ecomapp/providers/products_provider.dart';
import 'package:ecomapp/screens/favourites_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Controllers
  TextEditingController searchController = TextEditingController();

  //Booleans
  bool isError = false;
  bool isSearching = false;

  //Lists
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> searchedProducts = [];

  //Others
  FocusNode? searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: isSearching ? 1 : 0,
              duration: const Duration(milliseconds: 700),
              child: isSearching ? searchBar() : Container(),
            ),
          ],
        ),
      ),
    );
  }

  Container searchBar() {
    return Container(
      decoration: BoxDecoration(
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
        onChanged: (value) {},
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
          border: InputBorder.none, // Removes default border
        ),
      ),
    );
  }

  Future<void> loadProducts() async {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final response = await productsProvider.getProducts();

    if (response['message'] != null) {
      setState(() {
        isError = true;
      });
    } else {
      setState(() {
        products = (response['data'] as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        searchedProducts = products;
      });
    }
  }
}
