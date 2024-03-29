import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meu_novo_aumigo/models/user_bd.dart';
import 'package:meu_novo_aumigo/view/approval/user_detail.dart';
import 'package:meu_novo_aumigo/view/global/bottom_navigation.dart';
import 'package:meu_novo_aumigo/view/global/sidebar.dart';
import 'package:meu_novo_aumigo/view/global/topbar.dart';

class Approval extends StatefulWidget {
  Approval({Key? key}) : super(key: key);

  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  late Stream<List<UserBD>> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: "institution")
        .orderBy('status', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => UserBD.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      drawer: Sidebar(),
      body: StreamBuilder<List<UserBD>>(
        stream: _userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erro: ${snapshot.error}'),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Sem usuários para aprovação"),
            );
          } else {
            List<UserBD> userBDList = snapshot.data!;
            return ListView.builder(
              itemCount: userBDList.length,
              itemBuilder: (context, index) {
                UserBD user = userBDList[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(
                        user.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        user.email,
                        style: TextStyle(fontSize: 14),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            user.isStatusWaitingApproval()
                                ? Icons.error
                                : (user.isStatusDisapproved()
                                    ? Icons.cancel
                                    : Icons.check_circle),
                            color: user.isStatusWaitingApproval()
                                ? Colors.red
                                : (user.isStatusDisapproved()
                                    ? Colors.red
                                    : Colors.green),
                          ),
                          SizedBox(width: 5), // Espaço entre o ícone e o texto
                          Text(
                            user.isStatusWaitingApproval()
                                ? 'Aguardando Aprovação'
                                : (user.isStatusDisapproved()
                                    ? 'Reprovado'
                                    : 'Aprovado'),
                            style: TextStyle(
                              color: user.isStatusWaitingApproval()
                                  ? Colors.red
                                  : (user.isStatusDisapproved()
                                      ? Colors.red
                                      : Colors.green),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDetail(
                              userBD: user,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(), // Adicionando uma linha abaixo do ListTile
                  ],
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
