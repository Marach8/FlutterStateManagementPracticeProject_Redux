import 'package:flutter/material.dart';
import 'package:redux_practice/enums_and_extensions.dart';

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
