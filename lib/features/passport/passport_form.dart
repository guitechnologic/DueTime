import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/document_model.dart';
import '../../storage/local_storage.dart';

class PassportFormScreen extends StatefulWidget {
  const PassportFormScreen({super.key});

  @override
  State<PassportFormScreen> createState() => _PassportFormScreenState();
}

class _PassportFormScreenState extends State<PassportFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final numeroCtrl = TextEditingController();
  final paisEmissaoCtrl = TextEditingController();
  final paisOrigemCtrl = TextEditingController();
  final emissaoCtrl = TextEditingController();
  final vencimentoCtrl = TextEditingController();

  DateTime? emissao;
  DateTime? vencimento;

  Future<void> _pickDate(
      TextEditingController ctrl, bool isExpiry) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      ctrl.text = DateFormat('dd/MM/yyyy').format(date);
      if (isExpiry) {
        vencimento = date;
      } else {
        emissao = date;
      }
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate() ||
        emissao == null ||
        vencimento == null) return;

    LocalStorage.add(
      DocumentModel(
        id: Random().nextInt(999999).toString(),
        type: DocumentType.passport,
        title: 'Passaporte',
        holderName: nomeCtrl.text,
        issueDate: emissao!,
        expiryDate: vencimento!,
        extra: {
          'numero': numeroCtrl.text,
          'paisEmissao': paisEmissaoCtrl.text,
          'paisOrigem': paisOrigemCtrl.text,
        },
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passaporte')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(nomeCtrl, 'Nome completo'),
              _field(numeroCtrl, 'Número do passaporte'),
              _field(paisEmissaoCtrl, 'País de emissão'),
              _field(paisOrigemCtrl, 'País de origem'),
              _dateField(emissaoCtrl, 'Data de emissão', false),
              _dateField(vencimentoCtrl, 'Data de vencimento', true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(labelText: label),
        validator: (v) =>
            v == null || v.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _dateField(
      TextEditingController c, String label, bool expiry) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        readOnly: true,
        decoration: InputDecoration(labelText: label),
        onTap: () => _pickDate(c, expiry),
        validator: (v) =>
            v == null || v.isEmpty ? 'Selecione a data' : null,
      ),
    );
  }
}
