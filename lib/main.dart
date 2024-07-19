import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TotalCounter(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  // Create a list of GlobalKeys for the ShoppingItem states
  final List<GlobalKey<_ShoppingItemState>> _shoppingItemKeys = [
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
    GlobalKey<_ShoppingItemState>(),
  ];

  void _clearAll() {
    // Clear total price
    Provider.of<TotalCounter>(context, listen: false).clearTotal();
    // Clear count in all ShoppingItems
    for (var key in _shoppingItemKeys) {
      key.currentState?.clearCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Shopping Cart"),
          backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ShoppingItem(key: _shoppingItemKeys[0], title: "iPad", price: 19000),
                  const SizedBox(height: 0),
                  ShoppingItem(key: _shoppingItemKeys[1], title: "iPad mini", price: 23000),
                  const SizedBox(height: 0),
                  ShoppingItem(key: _shoppingItemKeys[2], title: "iPad Air", price: 29000),
                  const SizedBox(height: 0),
                  ShoppingItem(key: _shoppingItemKeys[3], title: "iPad Pro", price: 39000),
                  const SizedBox(height: 0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Consumer<TotalCounter>(
                    builder: (context, totalCounter, child) {
                      final formattedTotal = NumberFormat('#,##0', 'en_US').format(totalCounter.total);
                      return Text(
                        'Total: $formattedTotal BATH',
                        style: const TextStyle(fontSize: 28),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _clearAll,
                    child: const Text('Clear', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      textStyle: const TextStyle(fontSize: 28),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingItem extends StatefulWidget {
  final String title;
  final int price;

  const ShoppingItem({required Key key, required this.title, required this.price}) : super(key: key);

  @override
  State<ShoppingItem> createState() => _ShoppingItemState();
}

class _ShoppingItemState extends State<ShoppingItem> {
  int count = 0;

  void _increment() {
    setState(() {
      count++;
      Provider.of<TotalCounter>(context, listen: false).addPrice(widget.price);
    });
  }

  void _decrement() {
    if (count > 0) {
      setState(() {
        count--;
        Provider.of<TotalCounter>(context, listen: false).subtractPrice(widget.price);
      });
    }
  }

  void clearCount() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat('#,##0', 'en_US').format(widget.price);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${widget.title} ($formattedPrice฿)',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _decrement,
                icon: const Icon(Icons.remove, color: Colors.black),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                count.toString(),
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: _increment,
                icon: const Icon(Icons.add, color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TotalCounter extends ChangeNotifier {
  int _total = 0;

  int get total => _total;

  void addPrice(int price) {
    _total += price;
    notifyListeners();
  }

  void subtractPrice(int price) {
    if (_total >= price) {
      _total -= price;
    }
    notifyListeners();
  }

  void clearTotal() {
    _total = 0;
    notifyListeners();
  }
}
