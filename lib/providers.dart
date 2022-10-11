import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

const List<Pet> initialPets = [
  Pet(name: 'むぎ', breed: 'アメリカンショートヘア', sex: Sex.male),
  Pet(name: 'スーザン', breed: 'コーギー', sex: Sex.female),
  Pet(name: '太郎', breed: '柴犬', sex: Sex.male),
  Pet(name: 'プリンセス', breed: 'ペルシャ', sex: Sex.female),
];

// 問３：　フィルターの種類を定義。
enum Filter{any, male, female}

class PetsNotifier extends StateNotifier<List<Pet>> {
  PetsNotifier(): super(initialPets);

  // 問１：　新しいリストオブジェクトを代入することに注意。
  void addPet(Pet pet) {
    state = [...state, pet];
  }

  // 問２：　ペットをリストから削除するメソッド。ここでは名前が同じものを削除していますが、重複しないIDがあるほうが望ましいです。
  void removePet(String name){
    state = [
      for (final pet in state)
        if (pet.name != name) pet,
    ];
  }
}

final petsProvider = StateNotifierProvider<PetsNotifier, List<Pet>>((ref) {
  return PetsNotifier();
});

// 問３：　フィルターを管理するプロバイダー。
final filterProvider = StateProvider<Filter>((ref) => Filter.any);

// 問３：　ペットのリストとフィルターの両方の状態に依存するプロバイダー。
final petsFilterProvider = Provider<List<Pet>>((ref) {

  final pets = ref.watch(petsProvider);
  final filter = ref.watch(filterProvider);

  if(filter == Filter.male){
    return pets.where((pet) =>pet.sex==Sex.male).toList();
  }else if(filter == Filter.female){
    return pets.where((pet) =>pet.sex==Sex.female).toList();
  }else{
    return pets;
  }
});
