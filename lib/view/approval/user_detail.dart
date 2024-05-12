import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meu_novo_aumigo/models/user_bd.dart';
import 'package:meu_novo_aumigo/view/approval/approval.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetail extends StatelessWidget {
  final UserBD userBD;
  UserDetail({Key? key, required this.userBD});

  @override
  Widget build(BuildContext context) {
    Future<void> _alterState(String? documentId, String? state) async {
      try {
        if (documentId == null) {
          return;
        }

        await FirebaseFirestore.instance
            .collection('users')
            .doc(documentId)
            .update({'status': state});
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Approval(),
          ),
        );
      } catch (e) {
        print('Error updating data: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Usuário'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 100), // Adjust the values as needed

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              userDetailsRow('Nome', userBD.name),
              userDetailsRow('Email', userBD.email),
              userDetailsRow('CNPJ', userBD.cnpj),
              userDetailsRow('Telefone', userBD.cellphone),
              userDetailsRow('Estado', userBD.state ?? 'Não especificado'),
              userDetailsRow('Cidade', userBD.city ?? 'Não especificado'),
              userDetailsRow('Bairro', userBD.neighborhood),
              userDetailsRow('Rua', userBD.street),
              userDetailsRow('Número', userBD.houseNumber),
              userDetailsRow('Observação', userBD.observation),
              Padding(
                padding: EdgeInsets.zero,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (userBD.instagram_link != null &&
                              userBD.instagram_link != "") {
                            await launch(userBD.instagram_link!);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (userBD.facebook_link != null &&
                              userBD.facebook_link != "") {
                            await launch(userBD.facebook_link!);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (userBD.x_link != null && userBD.x_link != "") {
                            await launch(userBD.x_link!);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          if (userBD.tiktok_link != null &&
                              userBD.tiktok_link != "") {
                            await launch(userBD.tiktok_link!);
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                FontAwesomeIcons.tiktok,
                                color: Colors.deepOrange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            left: 16.0, right: 16.0), // Adjust the values as needed
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: FloatingActionButton(
                heroTag: "approveButton",
                onPressed: () {
                  _alterState(userBD.id, "A");
                },
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_up),
                    SizedBox(height: 4),
                    Text('Aprovar'), // Adicionando o texto "Aprovar"
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: FloatingActionButton(
                heroTag: "disapproveButton",
                onPressed: () {
                  _alterState(userBD.id, "D");
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.thumb_down),
                    SizedBox(height: 4),
                    Text('Reprovar'), // Adicionando o texto "Aprovar"
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userDetailsRow(String label, String value) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Divider(), // Adicionando uma linha abaixo do ListTile
          ],
        ),
      ),
    );
  }
}
