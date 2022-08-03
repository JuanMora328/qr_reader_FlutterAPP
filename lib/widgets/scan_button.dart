import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/utils/utils.dart';

class ScanButton extends StatelessWidget {

  void displayDialog ( BuildContext context ){
    showCupertinoDialog(
      barrierDismissible: false,
      context: context, 
      builder: ( context ) {
        return CupertinoAlertDialog(
          title: const Text('LINK NO PERMITIDO'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('El link insertado es una dirección o localización'),
              SizedBox( height: 10)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),               
              child: const Text('Regresar', style: TextStyle( color: Colors.red ),)
              )   
          ],
        );
      }
    );    
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 0,
      child: const Icon(Icons.filter_center_focus),
      onPressed: () async {

        String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#3D8BEF','Cancelar',false, ScanMode.QR);

        if(barcodeScanRes == '-1' || barcodeScanRes.contains('WIFI')) {
          return displayDialog(context); //Retornamos la alerta creada.
        } 

        final scanlistProvider = Provider.of<ScanListProvider>(context, listen: false);

        final nuevoScan = await scanlistProvider.nuevoScan(barcodeScanRes);

        launchURL(context, nuevoScan);

      }
    );
  }
}