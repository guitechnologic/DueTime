import 'package:flutter/material.dart';

import '../passport/passport_form.dart';
import '../cnh/cnh_form.dart';
import '../nif/nif_form.dart';

class AddDocumentBottomSheet extends StatelessWidget {
  const AddDocumentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.flight),
            title: const Text('Passaporte'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PassportFormScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.directions_car),
            title: const Text('CNH'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CnhFormScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.badge),
            title: const Text('CitizenCard / Cartão de Cidadão'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NifFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
