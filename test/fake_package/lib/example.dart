/// a library
library ex;

int function1(String s, bool b) => 5;

double number;

get y => 2;

const String COLOR = 'red';

typedef String processMessage(String msg);

/// Sample class [String]
class Apple {
  static const int n = 5;
  static String string = 'hello';
  String s2;
  int m = 0;

  ///Constructor
  Apple();

  String get s => s2;

  void m1() {}

  void printMsg(String msg, [bool linebreak]) {}

  bool isGreaterThan(int number, {int check:5}) {
    return number > check;
  }
}
/// Extends class [Apple]
class B extends Apple with Cat {

  List<String> list;

  bool get isImplemented => false;

  @override
  void m1() {
    var a = 6;
    var b = a * 9;
  }
}

// Do NOT add a doc comment to C. Testing blank comments.

abstract class Cat {

  bool get isImplemented;
}

class Dog implements Cat, E {

  @override
  bool get isImplemented => true;

  List<Apple> getClassA() {
    return [new Apple()];
  }
}

abstract class E {

}

class CatString extends StringBuffer {

}