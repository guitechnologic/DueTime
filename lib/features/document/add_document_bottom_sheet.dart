import 'package:flutter/material.dart';
import '../passport/passport_form.dart';
import '../nif/nif_form.dart';
import '../cnh/cnh_form.dart';

class AddDocumentBottomSheet extends StatelessWidget {
  const AddDocumentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _item(
            context,
            icon: Icons.flight,
            title: 'Passaporte',
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
          _item(
            context,
            icon: Icons.badge,
            title: 'Cartão de Cidadão (NIF)',
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
          _item(
            context,
            icon: Icons.directions_car,
            title: 'CNH',
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
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
