import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/dummy_data.dart';
import 'package:shopping_list_app/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  void _addItem(){
    Navigator.of(context).push(MaterialPageRoute(builder:(ctx)=>NewItem()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body:ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context,index) {
          title: Text(groceryItems[index].name);
          leading:Container(
            width: 25,
            height: 25,
            color: groceryItems[index].category.color,
          );
          trailing:Text(groceryItems[index].quantity.toString());
          },)
    );
  }
}
