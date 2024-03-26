import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/view/global/feed_card.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';
import 'package:meu_novo_aumigo/view/lista.dart';
import 'package:meu_novo_aumigo/view/login/login_page.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => lista(),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
              break;
          }
        },
        unselectedItemColor: Colors.deepOrange,
        selectedItemColor: Colors.deepOrange,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind),
            label: 'Adoção',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Quem Somos',
          ),
        ],
      ),
    );
  }
}
