import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meu_novo_aumigo/models/adoptions.dart';
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/feed_card.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(showBackButton: false),
      drawer: Sidebar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('adoptions').snapshots(),
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return FeedCard(adoption: Adoptions.fromFirestore(document));
            }).toList(),
          );
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
