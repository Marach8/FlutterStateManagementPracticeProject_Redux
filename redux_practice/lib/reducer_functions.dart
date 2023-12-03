import 'package:redux/redux.dart';
import 'package:redux_practice/enums_and_extensions.dart';
import 'package:redux_practice/redux_state_class.dart';



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