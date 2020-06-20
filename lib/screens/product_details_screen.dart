import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/product-details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductsProvider>(context).findById(productId);
//    print(args);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title,style: Theme.of(context).textTheme.bodyText1,),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Hero(
              tag: loadedProduct.id,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(loadedProduct.imageUrl,fit: BoxFit.cover,),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text('\$${loadedProduct.price}',style: Theme.of(context).textTheme.bodyText1,),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(loadedProduct.description,style: Theme.of(context).textTheme.bodyText2,textAlign: TextAlign.center,softWrap: true,),
            )
          ],
        ),
      )
    );
  }
}
