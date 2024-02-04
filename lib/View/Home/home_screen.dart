import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dog_picker/DB%20Bloc/db_bloc.dart';
import 'package:dog_picker/Image%20Bloc/image_pick_bloc.dart';
import 'package:dog_picker/Model/cart_model.dart';
import 'package:dog_picker/Utils/Resources/colors.dart';
import 'package:dog_picker/View/Cart/cart_screen.dart';
import 'package:dog_picker/View/History%20Page/history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int randomThreeDigitNumber = 0;

  List<CartModel> cartList = [];

  void generateRandomNumber() {
    // Generate a random number between 100 and 999
    randomThreeDigitNumber = Random().nextInt(900) + 100;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final imageBloc = BlocProvider.of<ImagePickBloc>(context);
    final dbBloc = BlocProvider.of<DbBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick Image'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cartList: cartList),
                  ));
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HistoryPage(),
                  ));
            },
            icon: const Icon(Icons.history),
          )
        ],
      ),
      body: BlocBuilder<ImagePickBloc, ImagePickState>(
        bloc: imageBloc,
        builder: (context, state) {
          if (state is ImageLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ImageError) {
            return Center(child: Text(state.errorMessage));
          }

          if (state is ImageLoaded) {
            String imageUrl = state.imageUrl;

            dbBloc.add(DbSaveImage(imageUrl: imageUrl));

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, _) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Text(
                    'Price: \$$randomThreeDigitNumber',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add Items to Cart
                      CartModel cart = CartModel(imageUrl: imageUrl, price: randomThreeDigitNumber);

                      if (cartList.isEmpty || !cartList.any((cartItem) => cartItem.imageUrl == cart.imageUrl)) {
                        cartList.add(cart);

                        Fluttertoast.showToast(
                          msg: "Item Added To Cart",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.white,
                          textColor: AppColors.blackColor,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "Item Already Exists",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.white,
                          textColor: AppColors.blackColor,
                        );
                      }
                    },
                    icon: const Icon(Icons.add_shopping_cart_rounded),
                    label: const Text('Add To Cart'),
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          imageBloc.add(FetchImage());
          generateRandomNumber();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
