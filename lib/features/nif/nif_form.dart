import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../models/document_model.dart';
import '../../storage/local_storage.dart';

class NifFormScreen extends StatefulWidget {
  final DocumentModel? document;

  const NifFormScreen({super.key, this.document});

  @override
  State<NifFormScreen> createState() => _NifFormScreenState();
}

class _NifFormScreenState extends State<NifFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeCtrl = TextEditingController();
  final nascimentoCtrl = TextEditingController();
  final validadeCtrl = TextEditingController();
  final ccCtrl = TextEditingController();
  final nifCtrl = TextEditingController();
  final nissCtrl = TextEditingController();
  final snsCtrl = TextEditingController();

  DateTime? nascimento;
  DateTime? validade;
  String? sexo;

  bool get isEditing => widget.document != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final doc = widget.document!;

      nomeCtrl.text = doc.holderName;
      nascimento = doc.issueDate;
      validade = doc.expiryDate;

      nascimentoCtrl.text =
          DateFormat('dd/MM/yyyy').format(doc.issueDate);
      validadeCtrl.text =
          DateFormat('dd/MM/yyyy').format(doc.expiryDate);

      sexo = doc.extra['sexo'];
      ccCtrl.text = doc.extra['numeroCartao'] ?? '';
      nifCtrl.text = doc.extra['nif'] ?? '';
      snsCtrl.text = doc.extra['sns'] ?? '';
      nissCtrl.text = doc.extra['niss'] ?? '';
    }
  }

  // =========================
  // UTILITÁRIOS
  // =========================

  String _capitalizeWords(String text) {
    final words = text.split(' ');
    return words
        .map((w) =>
            w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  DateTime? _parseDate(String value) {
    try {
      return DateFormat('dd/MM/yyyy').parseStrict(value);
    } catch (_) {
      return null;
    }
  }

  // =========================
  // VALIDAÇÕES
  // =========================

  String? _validateNIF(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'NIF deve conter exatamente 9 dígitos\nEx: 123456789';
    }
    return null;
  }

  String? _validateSNS(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d{9}$').hasMatch(value)) {
      return 'SNS deve conter exatamente 9 dígitos\nEx: 123456789';
    }
    return null;
  }

  String? _validateNISS(String? value) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d{11}$').hasMatch(value)) {
      return 'NISS deve conter exatamente 11 dígitos\nEx: 12345678901';
    }
    return null;
  }

  String? _validateCC(String? value) {
    if (value == null || value.isEmpty) return null;

    final regex = RegExp(r'^\d{8}[A-Z]{2}\d{2}$');

    if (!regex.hasMatch(value)) {
      return 'Formato correto: 8 números + 2 letras + 2 números\nEx: 12345678AB12';
    }

    return null;
  }

  // =========================
  // SALVAR
  // =========================

  Future<void> _save() async {
    nascimento = _parseDate(nascimentoCtrl.text);
    validade = _parseDate(validadeCtrl.text);

    if (!_formKey.currentState!.validate() ||
        nascimento == null ||
        validade == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verifique os campos obrigatórios'),
        ),
      );
      return;
    }

    final doc = DocumentModel(
      id: isEditing
          ? widget.document!.id
          : Random().nextInt(999999).toString(),
      type: DocumentType.nif,
      title: 'Cartão do Cidadão',
      holderName: _capitalizeWords(nomeCtrl.text),
      issueDate: nascimento!,
      expiryDate: validade!,
      extra: {
        'sexo': sexo,
        'numeroCartao': ccCtrl.text.isEmpty ? null : ccCtrl.text,
        'nif': nifCtrl.text.isEmpty ? null : nifCtrl.text,
        'sns': snsCtrl.text.isEmpty ? null : snsCtrl.text,
        'niss': nissCtrl.text.isEmpty ? null : nissCtrl.text,
      },
    );

    await LocalStorage.save(doc);
    Navigator.pop(context, true);
  }

  // =========================
  // UI
  // =========================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isEditing ? 'Editar Cartão do Cidadão' : 'Cartão do Cidadão'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _field(nomeCtrl, 'Nome', capitalize: true),
              _sexoDropdown(),
              _dateField(nascimentoCtrl, 'Data de nascimento'),
              _dateField(validadeCtrl, 'Data de validade'),
              _ccField(),
              _optionalNumberField(
                  nifCtrl, 'NIF (9 dígitos)', 9, _validateNIF),
              _optionalNumberField(
                  snsCtrl, 'Nº SNS (9 dígitos)', 9, _validateSNS),
              _optionalNumberField(
                  nissCtrl, 'NISS (11 dígitos)', 11, _validateNISS),
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

  // =========================
  // COMPONENTES
  // =========================

  Widget _field(TextEditingController c, String label,
      {bool capitalize = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        onChanged: capitalize
            ? (v) {
                final newText = _capitalizeWords(v);
                c.value = TextEditingValue(
                  text: newText,
                  selection:
                      TextSelection.collapsed(offset: newText.length),
                );
              }
            : null,
        decoration: InputDecoration(labelText: label),
        validator: (v) =>
            v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _optionalNumberField(
    TextEditingController c,
    String label,
    int maxLength,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(maxLength),
        ],
        decoration: InputDecoration(
          labelText: label,
          counterText: '',
        ),
        validator: validator,
      ),
    );
  }

  Widget _ccField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ccCtrl,
        textCapitalization: TextCapitalization.characters,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]')),
          LengthLimitingTextInputFormatter(12),
          UpperCaseTextFormatter(), // 🔥 força maiúsculo automático
        ],
        decoration: const InputDecoration(
          labelText: 'Nº Cartão do Cidadão',
          hintText: 'Ex: 12345678AB12',
        ),
        validator: _validateCC,
      ),
    );
  }

  Widget _dateField(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(8),
          TextInputFormatter.withFunction((oldValue, newValue) {
            final text = newValue.text;
            var result = '';

            for (int i = 0; i < text.length; i++) {
              if (i == 2 || i == 4) result += '/';
              result += text[i];
            }

            return TextEditingValue(
              text: result,
              selection:
                  TextSelection.collapsed(offset: result.length),
            );
          }),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: 'DD/MM/AAAA',
        ),
        validator: (v) =>
            v == null || _parseDate(v) == null ? 'Data inválida' : null,
      ),
    );
  }

  Widget _sexoDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: sexo,
        decoration: const InputDecoration(labelText: 'Sexo'),
        items: const [
          DropdownMenuItem(value: 'Masculino', child: Text('Masculino')),
          DropdownMenuItem(value: 'Feminino', child: Text('Feminino')),
          DropdownMenuItem(
            value: 'Prefiro não declarar',
            child: Text('Prefiro não declarar'),
          ),
        ],
        onChanged: (v) => setState(() => sexo = v),
      ),
    );
  }
}

// 🔥 FORMATADOR PERSONALIZADO PARA MAIÚSCULO AUTOMÁTICO
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
