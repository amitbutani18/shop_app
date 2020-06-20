import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItems order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.order.products.length * 20.0 + 110, 200) : 95,
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
                style: TextStyle(color: Theme.of(context).colorScheme.primaryVariant),
              ),
              subtitle: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
                style: Theme.of(context).textTheme.bodyText2,
//              DateFormat('DD MM yyyy hh:mm').format(order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.primaryVariant,
                ),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),

              AnimatedContainer(
                padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                height: _expanded ? min(widget.order.products.length * 20.0 + 10, 200) : 0,
                duration: Duration(milliseconds: 300),
                child: ListView(
                  children: widget.order.products
                      .map((prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primaryVariant,
                                    fontSize: 20),
                              ),
                              Text(
                                '${prod.quantity} x \$${prod.price}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),)
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
