import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../utils/apps_routes.dart';

class ProductsScreen extends StatelessWidget {
  Future<void> _refreshProduct(BuildContext context) {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productItems = products.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestão de produtos'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProduct(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: products.itemsCount,
            itemBuilder: (ctx, i) => Column(
              children: <Widget>[ProductItem(productItems[i]), Divider()],
            ),
          ),
        ),
      ),
    );
  }
}
