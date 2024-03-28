import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/feed_card.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      drawer: Sidebar(),
      body: ListView(children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FeedCard(
                      imageUrls: [
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                      ],
                      title: 'Card 1',
                      description: 'Description for Card 1',
                    ),
                    FeedCard(
                      imageUrls: [
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                      ],
                      title: 'Card 2',
                      description: 'Description for Card 2',
                    ),
                    FeedCard(
                      imageUrls: [
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                      ],
                      title: 'Card 1',
                      description: 'Description for Card 1',
                    ),
                    FeedCard(
                      imageUrls: [
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                        'https://via.placeholder.com/600x300',
                      ],
                      title: 'Card 2',
                      description: 'Description for Card 2',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
