import 'package:flutter/material.dart';

enum Sex{male, female}

// extensionを使ってクラスにメソッドを追加できます。
extension SexString on Sex{
  String get string {
    switch (this) {
      case Sex.male:
        return 'オス';
      case Sex.female:
        return 'メス';
    }
  }
}

@immutable
class Pet{
  const Pet({
    required this.name,
    required this.breed,
    required this.sex,
  });

  final String name;
  final String breed;
  final Sex sex;

  Pet copyWith({String? name, String? breed, Sex? sex}) {
    return Pet(
      name: name?? this.name,
      breed: breed?? this.breed,
      sex: sex?? this.sex,
    );
  }
}
