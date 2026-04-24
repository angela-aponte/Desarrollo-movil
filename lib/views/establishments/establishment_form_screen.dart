import 'dart:io';

import 'package:desarrollo_movil/models/establishment_model.dart';
import 'package:desarrollo_movil/services/establishment_service.dart';
import 'package:desarrollo_movil/widgets/custom_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EstablishmentFormScreen extends StatefulWidget {
  const EstablishmentFormScreen({super.key, this.id});

  final String? id;

  bool get isEdit => id != null;

  @override
  State<EstablishmentFormScreen> createState() => _EstablishmentFormScreenState();
}

class _EstablishmentFormScreenState extends State<EstablishmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nitCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final EstablishmentService _service = EstablishmentService();

  bool _loading = false;
  bool _loadingInitial = false;
  String? _logoPath;
  String? _currentLogo;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _loadDetail();
    }
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loadingInitial = true;
    });

    final detail = await _service.fetchById(widget.id!);
    if (!mounted) {
      return;
    }

    if (detail != null) {
      _fill(detail);
    }

    setState(() {
      _loadingInitial = false;
    });
  }

  void _fill(EstablishmentModel data) {
    _nameCtrl.text = data.nombre ?? '';
    _nitCtrl.text = data.nit ?? '';
    _addressCtrl.text = data.direccion ?? '';
    _phoneCtrl.text = data.telefono ?? '';
    _currentLogo = data.logo;
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) {
      return;
    }

    setState(() {
      _logoPath = result.files.single.path;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      EstablishmentModel? result;

      if (widget.isEdit) {
        result = await _service.update(
          id: widget.id!,
          nombre: _nameCtrl.text.trim(),
          nit: _nitCtrl.text.trim(),
          direccion: _addressCtrl.text.trim(),
          telefono: _phoneCtrl.text.trim(),
          logoPath: _logoPath,
        );
      } else {
        result = await _service.create(
          nombre: _nameCtrl.text.trim(),
          nit: _nitCtrl.text.trim(),
          direccion: _addressCtrl.text.trim(),
          telefono: _phoneCtrl.text.trim(),
          logoPath: _logoPath,
        );
      }

      if (!mounted) {
        return;
      }

      if (result?.id != null) {
        context.go('/establishments/${result!.id}');
        return;
      }

      context.go('/establishments');
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo guardar: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nitCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Editar Establecimiento' : 'Crear Establecimiento'),
      ),
      drawer: const CustomDrawer(),
      body: _loadingInitial
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nitCtrl,
                    decoration: const InputDecoration(labelText: 'NIT'),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _addressCtrl,
                    decoration: const InputDecoration(labelText: 'Dirección'),
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Teléfono'),
                    validator: _requiredValidator,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _loading ? null : _pickImage,
                    icon: const Icon(Icons.image),
                    label: const Text('Seleccionar logo'),
                  ),
                  const SizedBox(height: 8),
                  if (_logoPath != null) Text('Archivo seleccionado: $_logoPath'),
                  if (_logoPath == null && _currentLogo != null && _currentLogo!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text('Logo actual:'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: Image.network(
                        _currentLogo!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 60),
                      ),
                    ),
                  ],
                  if (_logoPath != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 110,
                      child: Image.file(
                        File(_logoPath!),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 60),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(widget.isEdit ? 'Guardar cambios' : 'Crear establecimiento'),
                  ),
                ],
              ),
            ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }
}
