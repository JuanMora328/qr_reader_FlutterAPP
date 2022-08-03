import 'package:flutter/material.dart';

import 'package:qr_reader/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> launchURL(BuildContext context, ScanModel scan) async {
  final url = scan.valor;

  if(scan.tipo == 'http') {
    //abrir el sitio web
    if (await canLaunchUrl(Uri.parse(url))) {

      await launchUrl(Uri.parse(url));

    } else {
        throw 'Could not launch $url';
      }

  } else {
      Navigator.pushNamed(context, 'mapa', arguments: scan);
    }

  
}