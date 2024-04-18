import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;

  const TopBar({Key? key, this.showBackButton = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (showBackButton)
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            Expanded(
              flex: showBackButton ? 1 : 2,
              child: Container(
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.contain,
                  height: 45,
                ),
              ),
            ),
            if (showBackButton)
              SizedBox(width: 50)
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey,
          height: 0.3,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
