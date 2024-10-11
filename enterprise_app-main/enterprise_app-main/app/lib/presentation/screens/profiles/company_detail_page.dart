import 'package:flutter/material.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyId;

  const CompanyDetailPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Empresa'),
      ),
      body: Center(
        child: Text('Mostrar detalles de la empresa con ID: $companyId'),
      ),
    );
  }
}
