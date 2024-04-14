import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meu_novo_aumigo/models/adoptions.dart';
import 'package:meu_novo_aumigo/view/global/feed_card_detail.dart';

class FeedCard extends StatelessWidget {
  final Adoptions adoption;

  FeedCard({
    required this.adoption,
  });

  void _navigateToDetailScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeedCardDetail(adoption: adoption),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToDetailScreen(context);
      },
      child: Card(
        color: Color.fromARGB(255, 255, 255, 255),
        shadowColor: Color(0xFFb85b20),
        elevation: 5,
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 200, // adjust the height of the carousel
                  child: CarouselSlider(
                    options: CarouselOptions(
                      aspectRatio: MediaQuery.of(context).size.width /
                          200, // Use width of screen divided by height of carousel
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      pauseAutoPlayOnTouch: true,
                    ),
                    items: adoption.images?.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(
                                10), // adjust the value as necessary
                            child: Image.network(
                              url,
                              fit: BoxFit
                                  .cover, // Cover the entire area without distortion
                              width: MediaQuery.of(context)
                                  .size
                                  .width, // Use width of screen
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                            10), // BorderRadius no canto superior esquerdo// BorderRadius no canto inferior esquerdo
                        bottomRight: Radius.circular(
                            10), // BorderRadius no canto inferior direito
                      ),
                    ),
                    child: Text(
                      adoption.name ?? "",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange, // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 8, bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: adoption.getAnimalTypeIcon(),
                        ),
                        Text(adoption.animalType)
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(FontAwesomeIcons.weightHanging, size: 16),
                        ),
                        Text(adoption.weight ?? "")
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(FontAwesomeIcons.venusMars, size: 16),
                        ),
                        Text(adoption.sex)
                      ],
                    ),
                  ),
                  SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            FontAwesomeIcons.calendar,
                            size: 16,
                          ),
                        ),
                        Text(adoption.age ?? "")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4, left: 24, right: 16, bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      adoption.description != null &&
                              adoption.description!.length > 100
                          ? '${adoption.description!.substring(0, 100)}...'
                          : adoption.description ?? "",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
