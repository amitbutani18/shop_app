import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';

import '../providers/cart.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum filterOption {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteOnly = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
//    Future.delayed(Duration.zero).then((_) => Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProduct());
    super.initState();
  }

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProduct();
  }

  @override
  void didChangeDependencies() async {
    try {

      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<ProductsProvider>(context,listen: false).fetchAndSetProduct();
        print('hello');
        setState(() {
          _isLoading = false;
        });
      }
      _isInit = false;
      super.didChangeDependencies();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // ignore: deprecated_member_use
        title: Text(
          'FashionStreet',
          // ignore: deprecated_member_use
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: <Widget>[
          PopupMenuButton(
            color: Theme.of(context).colorScheme.primaryVariant,
            onSelected: (filterOption selectedValue) {
              setState(() {
                if (selectedValue == filterOption.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                // ignore: deprecated_member_use
                child: Text(
                  'Your Favorite',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                value: filterOption.Favorite,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                value: filterOption.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.black54, //This will change the drawer background to blue.
          //other styles
        ),
        child: AppDrawer(),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            )
          : RefreshIndicator(
              onRefresh: () => _refreshProduct(context),
              child: ProductsGrid(_showFavoriteOnly)),
    );
  }
}
