import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  const CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(context: context,
        builder: (ctx) => AlertDialog(title: Text('Are You Sure?'),
        content: Text('Do Yoy want to remove item from the cart?'),
        elevation: 6,
        actions: <Widget>[
          FlatButton(child: Text('No',style: TextStyle(color: Colors.green),),onPressed: () {Navigator.of(context).pop(false);},),
          FlatButton(child: Text('Yes',style: TextStyle(color: Colors.redAccent),),onPressed: () {Navigator.of(context).pop(true);},)
        ],),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).colorScheme.onPrimary,
            width: 1,
          ),
          boxShadow: [
            new BoxShadow(
              color: Theme.of(context).colorScheme.onPrimary,
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Card(
          color: Theme.of(context).colorScheme.primaryVariant,
//        shape: RoundedRectangleBorder(side: BorderSide(color: ),),
//        margin: ,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
            child: ListTile(
              leading: Chip(
                avatar: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryVariant,
                  child: Text('\$',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold)),
                ),
                label: Text(
                  '$price',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontSize: 18),
                ),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
//          leading: Chip(
//            label: Text(
//              '\$$price',
//              style: TextStyle(
//                  color: Theme.of(context).colorScheme.primaryVariant,
//                  fontWeight: FontWeight.normal,
//                  fontSize: 18),
//            ),
//            backgroundColor: Theme.of(context).colorScheme.secondary,
//          ),
              title: Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              subtitle: Text('Total: \$${(price * quantity)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary)),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
    );
  }
}
