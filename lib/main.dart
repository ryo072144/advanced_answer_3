import 'package:advanced_amswer_3/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Exercise 3',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// 問１：　ラジオボタンを動かすためだけのプロバイダー。
final sexProvider = StateProvider<Sex>((ref) => Sex.female);

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Exercise 3'),
        actions: [

          // 問３：　フィルターの切り替え。
          Consumer(
            builder: (context, ref, _) {
              return PopupMenuButton<Filter>(
                onSelected: (value) => ref.read(filterProvider.state).state=value,
                icon: const Icon(Icons.sort),
                itemBuilder: (BuildContext context) {
                  return [
                    const PopupMenuItem(
                      value: Filter.any,
                      child: Text('条件なし'),
                    ),
                    const PopupMenuItem(
                      value: Filter.male,
                      child: Text('オスのみ'),
                    ),
                    const PopupMenuItem(
                      value: Filter.female,
                      child: Text('メスのみ'),
                    ),
                  ];
                },
              );
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(
          builder: (context, ref, _) {
            final List<Pet> pets = ref.watch(petsFilterProvider);

            // 問２：　リストからの削除を通知する処理。
            ref.listen<List<Pet>>(petsProvider, (List<Pet>? previousPets, List<Pet> newPets){
              if(previousPets==null){// nullチェック
                return;
              }
              // 問２：　リストの数が減っていれば通知。
              if(previousPets.length>newPets.length){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('リストから消去されました'),
                  duration: Duration(milliseconds: 600),
                ));
              }
            });

            return ListView(
              children: pets.map((pet) =>
              // 問２：　GestureDetectorで長押しを感知。
                  GestureDetector(
                    onLongPress: ()=>showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text('リストから消去しますか？'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: (){
                                ref.read(petsProvider.notifier).removePet(pet.name);
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    ),
                    child: Card(
                        child: Text('名前:${pet.name}　品種:${pet.breed}　性別:${pet.sex.string}', style: const TextStyle(fontSize: 20),)
                    ),
                  )
              ).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            String name = '';
            String breed = '';
            return Consumer(
              builder: (context, ref, _) {
                final sex = ref.watch(sexProvider.state);
                return AlertDialog(
                  title: const Text('ペットを追加'),
                  content: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          onChanged: (value){
                            name = value;
                          },
                          decoration: const InputDecoration(labelText: '名前', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          onChanged: (value){
                            breed = value;
                          },
                          decoration: const InputDecoration(labelText: '品種', border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 10,),

                        // 問１：　ラジオボタンのように単純なものはStateProviderを使います。
                        Row(
                          children: [
                            const Spacer(),
                            Radio<Sex>(
                              value: Sex.male,
                              groupValue: sex.state,
                              onChanged: (Sex? value) {
                                sex.state = value!;
                              },
                            ),
                            const Text('オス'),
                            const Spacer(),
                            Radio<Sex>(
                              value: Sex.female,
                              groupValue: sex.state,
                              onChanged: (Sex? value) {
                                sex.state = value!;
                              },
                            ),
                            const Text('メス'),
                            const Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: (){
                        ref.read(petsProvider.notifier).addPet(
                            Pet(name: name, breed: breed, sex: sex.state)
                        );
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
