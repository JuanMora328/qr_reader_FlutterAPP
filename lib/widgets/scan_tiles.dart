import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';

import '../utils/utils.dart';

class ScanTiles extends StatelessWidget {
  
  final String tipo;

  const ScanTiles({ required this.tipo});

  @override
  Widget build(BuildContext context) {
    
    final scanListProvider = Provider.of<ScanListProvider>(context);
    final scans = scanListProvider.scans;

    return ListView.builder(
      itemCount: scans.length,
      itemBuilder: (_ , i) => Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (DismissDirection direction){
          Provider.of<ScanListProvider>(context,listen: false)
            .borrarScanPorId(scans[i]!.id!);
        },
        child: ListTile(
            leading: Icon (
              tipo == 'http'
              ? Icons.link_rounded
              : Icons.map_rounded, 
              color: Theme.of(context).primaryColor 
            ),
            title: Text(scans[i]!.valor),
            subtitle: Text(scans[i]!.id.toString()),
            trailing: const Icon(Icons.keyboard_arrow_right_rounded, color:  Colors.grey),
            onTap: () => launchURL(context, scans[i]!),
            
          ),
      )
      ); 
  }
}