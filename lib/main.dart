import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Shopping List',
    home: new ShoppingList(
      products: <Product>[
        new Product(name: 'Eggs'),
        new Product(name: 'Eggs'),
        new Product(name: 'Flour'),
        new Product(name: 'Chosolate chips'),
      ],
    ),
  ));
}

class Product {
  Product({this.name});

  final String name;
}

typedef void CartChangedCallback(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({Product product, this.inCart, this.onToggleCart}):
    product = product,
    super(key: new ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onToggleCart;

  Color _getColor(BuildContext context) {
    return inCart ? Colors.grey : Theme.of(context).primaryColor;
  }

  TextStyle _getTextStyle() {
    return inCart ? new TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    ) : null;
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      onTap: () {
        print('pressing ${product.name} with id ${key}');
        onToggleCart(product, inCart);
      },
      leading: new CircleAvatar(
        backgroundColor: _getColor(context),
        child: new Text(product.name.substring(0, 1)),
      ),
      title: new Text(product.name, style: _getTextStyle()),
    );
  }
}

class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}): super(key: key);

  final List<Product> products;

  @override
  ShoppingListState createState() {
    return new ShoppingListState();
  }
}

class ShoppingListState extends State<ShoppingList> {
  var _shoppingCart = new Set<Product>();

  void _onToggleCart(Product product, bool inCart) {
    setState(() {
      if (inCart) {
        _shoppingCart.remove(product);
      } else {
        _shoppingCart.add(product);
      }
    });
  }

  Widget buildFloatingButton(BuildContext context) {
    List<Widget> widgets = <Widget>[
      new FloatingActionButton(
        onPressed: () {
          print('press shopping cart');
          setState(() {
            _shoppingCart.clear();
          });
        },
        tooltip: 'Shopping Cart',
        child: new Icon(Icons.shopping_cart),
      ),
    ];

    if (_shoppingCart.length > 0) {
      widgets.add(
        new Positioned(
          right: 0.0,
          top: 0.0,
          child: new Container(
            padding: new EdgeInsets.all(0.0),
            width: 24.0,
            height: 24.0,
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(12.0),
              color: Colors.red,
            ),
            child: new Center(
              child: new Text(_shoppingCart.length.toString()),
            ),
          ),
        ),
      );
    }

    return new Stack(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Shopping List'),
      ),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return new ShoppingListItem(
            product: product,
            onToggleCart: _onToggleCart,
            inCart: _shoppingCart.contains(product),
          );
        }).toList(),
      ),
      floatingActionButton: buildFloatingButton(context),
    );
  }
}
