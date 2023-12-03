import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' hide Reducer;
import 'package:redux/redux.dart';


class FlutterReduxExample extends HookWidget {
  const FlutterReduxExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



enum ItemFilters {getAllTexts, getLongTexts, getShortTexts}

extension RemoveOrAddItem<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((element) => element != other);
}


Iterable<String> addItemReducer(Iterable<String> initialItem, AddItemAction action) =>
initialItem + action.item;
Iterable<String> removeItemReducer(Iterable<String> initialItem, RemoveItemAction action) =>
initialItem - action.item;


Reducer<Iterable<String>> itemReducer = combineReducers<Iterable<String>>([
  TypedReducer<Iterable<String>, AddItemAction>(addItemReducer),
  TypedReducer<Iterable<String>, RemoveItemAction>(removeItemReducer)
]);

ItemFilters itemFilterReducer(StorageState oldState, Action action){
  if(action is ChangeFilterAction){return action.filter;} else{return oldState.filters;}
}

StorageState mainAppReducer(StorageState oldState, action) => StorageState(
  items: itemReducer(oldState.items, action), filters: itemFilterReducer(oldState, action)
);



@immutable
class StorageState{
  final Iterable<String> items; final ItemFilters filters;

  const StorageState({required this.items, required this.filters});

  Iterable<String> get filteredItems{
    switch(filters){
      case ItemFilters.getAllTexts: return items;
      case ItemFilters.getLongTexts: return items.where((element) => element.length >= 10);
      case ItemFilters.getShortTexts: return items.where((element) => element.length <= 3);
    }
  }
}


@immutable
abstract class Action{
  const Action();
}

@immutable 
abstract class ItemAction extends Action{
  final String item;
  const ItemAction(this.item);
}

@immutable 
class AddItemAction extends ItemAction{
  const AddItemAction(String item): super(item);
}

@immutable 
class RemoveItemAction extends ItemAction{
  const RemoveItemAction(String item): super(item);
}


@immutable
class ChangeFilterAction extends Action{
  final ItemFilters filter;
  const ChangeFilterAction(this.filter);
}
