import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_novo_aumigo/view/adoption/adoption_page.dart';
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class AdoptionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      drawer: Sidebar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('adoptions')
            .orderBy('adopted')
            .orderBy('name')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Nenhuma adoção encontrada.'),
            );
          }
          return ListView(
            children: [
              ...snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return AdoptionCard(data: data, firebaseId: document.id);
              }).toList(),
              SizedBox(height: 100),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 16),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdoptionForm(
                    adoption: null,
                  ),
                ),
              );
            },
            icon: Icon(Icons.add),
            label: Text("Adicionar"),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AdoptionCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String firebaseId;

  const AdoptionCard({required this.data, required this.firebaseId});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: data['images'].length != 0
              ? NetworkImage(data['images'][0])
              : NetworkImage(""),
        ),
        title: Text(data['name'] != null && data['name'] != ''
            ? data['name']
            : 'Sem nome'),
        subtitle: Text(data['animalType'] +
            ' ' +
            data['sex'] +
            ' ' +
            (data['adopted'] ? '(Adotado)' : '')),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AdoptionForm(adoption: data, firebaseId: firebaseId),
              ),
            );
          },
        ),
      ),
    );
  }
}
