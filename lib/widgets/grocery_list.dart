import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
   List<GroceryItem> _groceryItems = [];
   var _isLoading = true;
   String ? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async{
    final url = Uri.https('shopping-list-8843d-default-rtdb.firebaseio.com',
          'shopping_list.json');
      final response = await http.get(url);
       if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data. Please try again later.';
      });
    }
      final Map<String, dynamic> listData= json.decode(response.body);
      final List<GroceryItem> _loadedItems = [];
      for( final item in listData.entries){
         final category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value['category'])
          .value;
        _loadedItems.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ));
      }
      setState(() {
        _groceryItems=_loadedItems;
        _isLoading=false;
      });
  }
  void _addItem() async {
     final newItem = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewItem()));

        _loadItems();

        if(newItem==null){
          return ;
        }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

   void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child:Text('No items yet. Add some!'));

    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }

    if(_groceryItems.isNotEmpty){
      content =  ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) => Dismissible(
            onDismissed: (direction) {
            _removeItem(_groceryItems[index]);
          },
          key: ValueKey(_groceryItems[index].id),
            child: ListTile(
              title: Text(_groceryItems[index].name),
              leading: Container(
                width: 24,
                height: 24,
                color: _groceryItems[index].category.color,
              ),
              trailing: Text(_groceryItems[index].quantity.toString()),
            ),
          ),
        );
    }

     if (_error != null) {
      content = Center(child: Text(_error!));
    }

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
        body:content
        );
  }
}
