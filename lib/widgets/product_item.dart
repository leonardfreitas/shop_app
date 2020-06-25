import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';

import '../providers/product.dart';
import '../providers/products.dart';
import '../utils/apps_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => (AlertDialog(
                    title: Text(
                      'Você tem certeza?',
                    ),
                    content: Text('Deseja remover esse produto?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: Text('Não'),
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: Text('Sim'),
                      )
                    ],
                  )),
                ).then((value) async {
                  if (value) {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(product.id);
                    } on HttpException catch (error) {
                      scaffold.showSnackBar(SnackBar(
                        content: Text(
                          error.toString(),
                        ),
                      ));
                    }
                  }
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
