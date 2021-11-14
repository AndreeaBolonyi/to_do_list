class MyDate {
  int day = 0;
  int month = 0;
  int year = 0;

  MyDate(int d, int m, int y) {
    day = d;
    month = m;
    year = y;
  }

  @override
  String toString() {
    return "$day.$month.$year";
  }
}