import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' as hooks;
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_practice/custombutton.dart';
import 'package:redux_practice/enums_and_extensions.dart';
import 'package:redux_practice/reducer_functions.dart';
import 'package:redux_practice/redux_state_class.dart';


class FlutterReduxExample extends hooks.HookWidget {
  const FlutterReduxExample({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = Store(
      mainAppReducer, initialState: const StorageState(items: [], filters: ItemFilters.getAllTexts)
    );
    final controller = hooks.useTextEditingController();
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Redux Demo'), centerTitle: true), 
      body: StoreProvider(
        store: storage,
        child: Column(
          children: [
            Row(
              children: [
                CustomButton(
                  onPressed: () => storage.dispatch(const ChangeFilterAction(ItemFilters.getAllTexts)),
                  text: 'GetAllTexts'
                ),
                CustomButton(
                  onPressed: () => storage.dispatch(const ChangeFilterAction(ItemFilters.getLongTexts)),
                  text: 'GetLongTexts'
                ),
                CustomButton(
                  onPressed: () => storage.dispatch(const ChangeFilterAction(ItemFilters.getShortTexts)),
                  text: 'GetShortTexts'
                ),
              ]
            ),
            TextField(controller: controller,),
            const SizedBox(height: 10),
            Row(
              children: [
                CustomButton(
                  onPressed: () {
                    controller.text.isNotEmpty? storage.dispatch(AddItemAction(controller.text)): {};
                    controller.clear();
                  },
                  text: 'AddItem'
                ),
                CustomButton(
                  onPressed: () {
                    controller.text.isNotEmpty? storage.dispatch(RemoveItemAction(controller.text)): {};
                    controller.clear();
                  },
                  text: 'RemoveItem'
                ),
              ]
            ),
            StoreConnector<StorageState, Iterable<String>>(
              converter: (storage) => storage.state.filteredItems,
              builder: (context, items){
                return Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, listIndex) => ListTile(
                      title: Text(items.elementAt(listIndex))
                    )
                  ),
                );
              }
            )
          ]
        ),
      )
    );
  }
}
