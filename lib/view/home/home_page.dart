import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_novo_aumigo/models/adoptions.dart';
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/feed_card.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _selectedAnimalType = "Todos";
  String? _selectedAnimalSize = "Todos";
  String? _selectedCity = "";
  late final QuerySnapshot usersSnapshot;

  final ScrollController _scrollController = ScrollController();
  final int _batchSize = 3;
  bool _loadingMore = false;
  List<QueryDocumentSnapshot>? _adoptions;

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadAdoptions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadAdoptions();
    }
  }

  void _loadUsers() async {
    Query usersQuery = FirebaseFirestore.instance.collection('users');
    usersSnapshot = await usersQuery.get();
  }

  Future<void> _loadAdoptions() async {
    setState(() {
      _loadingMore = true;
    });

    Query adoptionsQuery = FirebaseFirestore.instance.collection('adoptions');
    
    if (_selectedAnimalType != 'Todos') {
      adoptionsQuery =
          adoptionsQuery.where('animalType', isEqualTo: _selectedAnimalType);
    }

    if (_selectedAnimalSize != 'Todos') {
      adoptionsQuery =
          adoptionsQuery.where('size', isEqualTo: _selectedAnimalSize);
    }

    List<String> userIds = [];
    if (_selectedCity != null && _selectedCity!.isNotEmpty) {
      String selectedCityLowerCase = _selectedCity!.toLowerCase();

      if (usersSnapshot.docs.isNotEmpty) {
        List<String> citiesLowerCase = usersSnapshot.docs
            .map((doc) => doc["city"].toString().toLowerCase())
            .toList();

        for (int i = 0; i < usersSnapshot.docs.length; i++) {
          if (citiesLowerCase[i].contains(selectedCityLowerCase)) {
            userIds.add(usersSnapshot.docs[i].id);
          }
        }

        // Aplicar a lista filtrada de IDs de usuários
        if ( userIds.isNotEmpty ) {
          adoptionsQuery = adoptionsQuery.where('userId', whereIn: userIds);
        }
      }
    }

    if ( userIds.isNotEmpty || (_selectedCity == null || _selectedCity!.isEmpty)  ) {
      adoptionsQuery = adoptionsQuery.limit(_batchSize);

      if (_adoptions != null && _adoptions!.isNotEmpty) {
        adoptionsQuery = adoptionsQuery.startAfterDocument(_adoptions!.last);
      }

      adoptionsQuery = adoptionsQuery.where('adopted', isEqualTo: false);

      final QuerySnapshot adoptionsSnapshot = await adoptionsQuery.get();

      setState(() {
        _adoptions ??= [];
        _adoptions!.addAll(adoptionsSnapshot.docs);
        _loadingMore = false;
      });
    }
  }

  void _updateAnimalTypeFilter(String animaltype) {
    setState(() {
      _selectedAnimalType = animaltype;
      _adoptions = [];
    });
    _loadAdoptions();
  }

  void _updateAnimalSizeFilter(String animalSize) {
    setState(() {
      _selectedAnimalSize = animalSize;
      _adoptions = [];
    });
    _loadAdoptions();
  }

  void _updateCityFilter(String city) {
    setState(() {
      _selectedCity = city;
      _adoptions = [];
    });
    _loadAdoptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(showBackButton: false),
      drawer: Sidebar(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: _SliverHeaderDelegate(
              child: Container(
                color: Colors.white, // Cor de fundo dos filtros
                child: Padding(
                  padding: EdgeInsets.only(top: 5, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimalSelector(
                              onAnimalTypeChanged: _updateAnimalTypeFilter,
                            ),
                            Text("Animal"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            SizeSelector(
                              onSizeChanged: _updateAnimalSizeFilter,
                            ),
                            Text("Porte"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 200, // Largura desejada
                              height: 50, // Altura desejada
                              child: TextFormField(
                                onChanged: _updateCityFilter,
                                decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelStyle: TextStyle(color: Colors.black54),
                                  focusedBorder: UnderlineInputBorder(),
                                  enabledBorder: UnderlineInputBorder(),
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                              ),
                            ),
                            Text("Cidade"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            pinned: true,
          ),
          SliverList(
            // Lista de cards
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Adoptions? adoption = _adoptions != null
                    ? Adoptions.fromFirestore(_adoptions![index])
                    : null;
                if (adoption != null) {
                  return FeedCard(
                    adoption: adoption,
                  );
                }
              },
              childCount: _adoptions?.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  double get maxExtent => 90.0; // Adjust this value according to your design

  @override
  double get minExtent => 85.0;

  @override
  bool shouldRebuild(_SliverHeaderDelegate oldDelegate) {
    return false;
  }
}

class AnimalSelector extends StatefulWidget {
  final Function(String) onAnimalTypeChanged;

  AnimalSelector({required this.onAnimalTypeChanged});

  @override
  _AnimalSelectorState createState() => _AnimalSelectorState();
}

class _AnimalSelectorState extends State<AnimalSelector> {
  String _selectedAnimalType = 'Todos'; // Tipo de animal padrão

  Map<String, IconData> animalIcons = {
    'Todos': FontAwesomeIcons.paw,
    'Cachorro': FontAwesomeIcons.dog,
    'Gato': FontAwesomeIcons.cat,
    'Outros': FontAwesomeIcons.fish,
  };

  void _changeAnimalType(String newAnimalType) {
    setState(() {
      _selectedAnimalType = newAnimalType;
    });
    widget.onAnimalTypeChanged(newAnimalType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(animalIcons[_selectedAnimalType]),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: animalIcons.keys.map((String animalType) {
                      return ListTile(
                        leading: Icon(animalIcons[animalType]),
                        title: Text(animalType),
                        onTap: () {
                          _changeAnimalType(animalType);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class SizeSelector extends StatefulWidget {
  final Function(String) onSizeChanged;

  SizeSelector({required this.onSizeChanged});

  @override
  _SizeSelectorState createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String _selectedSize = 'Todos'; // Tipo de animal padrão

  Map<String, IconData> sizeIcons = {
    'Todos': FontAwesomeIcons.bars,
    'Pequeno': FontAwesomeIcons.spider,
    'Médio': FontAwesomeIcons.cat,
    'Grande': FontAwesomeIcons.hippo,
  };

  void _changeSize(String newSize) {
    setState(() {
      _selectedSize = newSize;
    });
    widget.onSizeChanged(newSize);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(sizeIcons[_selectedSize]),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: sizeIcons.keys.map((String animalType) {
                      return ListTile(
                        leading: Icon(sizeIcons[animalType]),
                        title: Text(animalType),
                        onTap: () {
                          _changeSize(animalType);
                          Navigator.of(context).pop();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
