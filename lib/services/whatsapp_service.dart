import 'package:url_launcher/url_launcher.dart';

class WhatsappService {
  static Future<void> redirectToWhatsApp(
      String message, String phoneNumber) async {
    final String encodedMessage = Uri.encodeComponent(message);
    final String whatsappUrl =
        'https://wa.me/$phoneNumber/?text=$encodedMessage';

    try {
      await launch(whatsappUrl);
    } catch (error) {
      throw 'Erro ao abrir o WhatsApp: $error';
    }
  }
}
