enum ItemFilters {getAllTexts, getLongTexts, getShortTexts}


extension RemoveOrAddItem<T> on Iterable<T> {
  Iterable<T> operator +(T other) => followedBy([other]);
  Iterable<T> operator -(T other) => where((element) => element != other);
}
