import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart' as ord;

class OrderScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var _isLoading = false;

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
//    setState(() {
//      _isLoading = true;
//    });
//    Future.delayed(Duration.zero).then((_) async {
//      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
//      setState(() {
//        _isLoading = false;
//      });
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    final orderData = Provider.of<Orders>(context);
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Order',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor:
              Colors.grey, //This will change the drawer background to blue.
          //other styles
        ),
        child: AppDrawer(),
      ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An Error Occurred!'),
              );
            } else {
              return Consumer<Orders>(builder: (ctx, orderData, child) => orderData.orders == null ? Center(child: Text('No order at!')) : RefreshIndicator(
                onRefresh: () => _refreshProduct(context),
                child:  ListView.builder(
                  itemBuilder: (ctx, i) => ord.OrderItem(
                    orderData.orders[i],
                  ),
                  itemCount: orderData.orders.length,
                ),)
              );
            }
          }
        },
      ),
    );
  }
}
