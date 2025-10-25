import 'package:flutter/material.dart';
import '../widgets/accessible_button.dart';
import '../utils/accessibility_utils.dart';
import 'package:flutter/services.dart'; // Para vibración táctil

class AccessibleFormScreen extends StatefulWidget {
  const AccessibleFormScreen({super.key});

  @override
  State<AccessibleFormScreen> createState() => _AccessibleFormScreenState();
}

class _AccessibleFormScreenState extends State<AccessibleFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController(); // ✅ Nuevo campo dirección

  bool _isLoading = false;
  double _fontSize = 16.0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        HapticFeedback.mediumImpact(); // ✅ Vibración de confirmación
        AccessibilityUtils.showAccessibleSnackBar(
          context,
          'Formulario enviado correctamente',
        );
      }
    } else {
      // Vibración fuerte si hay errores
      HapticFeedback.heavyImpact(); // ✅ Feedback táctil de error
      AccessibilityUtils.showAccessibleSnackBar(
        context,
        'Por favor, complete correctamente todos los campos',
      );
    }
  }

  void _increaseFontSize() {
    setState(() {
      _fontSize += 2.0;
      if (_fontSize > 24.0) _fontSize = 24.0;
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize -= 2.0;
      if (_fontSize < 14.0) _fontSize = 14.0;
    });
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear(); // Limpiar campo dirección
    AccessibilityUtils.showAccessibleSnackBar(context, 'Formulario limpiado');
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Semantics(
          header: true,
          child: const Text('Formulario Accesible'),
        ),
        actions: [
          IconButton(
            onPressed: _increaseFontSize,
            icon: const Icon(Icons.zoom_in),
            tooltip: 'Aumentar tamaño de texto',
          ),
          IconButton(
            onPressed: _decreaseFontSize,
            icon: const Icon(Icons.zoom_out),
            tooltip: 'Disminuir tamaño de texto',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Semantics(
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Semantics(
                  header: true,
                  child: const Text(
                    'Complete sus datos',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),

                // ✅ Campo de Nombre
                _buildTextField(
                  controller: _nameController,
                  label: 'Nombre Completo',
                  hint: 'Ingrese su nombre y apellido',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su nombre';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ✅ Campo de Correo
                _buildTextField(
                  controller: _emailController,
                  label: 'Correo Electrónico',
                  hint: 'ejemplo@correo.com',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su correo';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Ingrese un correo válido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ✅ Campo de Teléfono
                _buildTextField(
                  controller: _phoneController,
                  label: 'Teléfono',
                  hint: 'Ingrese su número de teléfono',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su teléfono';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ✅ Campo de Dirección (nuevo)
                _buildTextField(
                  controller: _addressController,
                  label: 'Dirección',
                  hint: 'Ingrese su dirección completa',
                  icon: Icons.home,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su dirección';
                    }
                    if (value.length < 10) {
                      return 'La dirección debe tener al menos 10 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                // ✅ Botón de Enviar
                AccessibleButton(
                  onPressed: _isLoading ? null : _submitForm,
                  text: _isLoading ? 'Enviando...' : 'Enviar Formulario',
                  icon: _isLoading ? Icons.hourglass_top : Icons.send,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: _fontSize,
                ),

                const SizedBox(height: 16),

                // Información de accesibilidad
                Semantics(
                  container: true,
                  label:
                      'Información de accesibilidad. Esta aplicación incluye características '
                      'para usuarios con discapacidades visuales y motoras.',
                  child: Card(
                    color: Colors.grey[100],
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Semantics(
                            header: true,
                            child: Text(
                              'Características Accesibles:',
                              style: TextStyle(
                                fontSize: _fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildFeatureItem('✓ Tamaño de texto ajustable'),
                          _buildFeatureItem('✓ Navegación por voz compatible'),
                          _buildFeatureItem('✓ Alto contraste disponible'),
                          _buildFeatureItem('✓ Etiquetas descriptivas'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Botón flotante para limpiar formulario
      floatingActionButton: Semantics(
        button: true,
        label: 'Limpiar formulario',
        child: FloatingActionButton(
          onPressed: _clearForm,
          tooltip: 'Limpiar formulario',
          backgroundColor: Colors.orange,
          child: const Icon(Icons.cleaning_services),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    required String? Function(String?) validator,
  }) {
    return Semantics(
      textField: true,
      label: label,
      hint: hint,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        keyboardType: keyboardType,
        style: TextStyle(fontSize: _fontSize),
        validator: validator,
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Semantics(
      container: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          text,
          style: TextStyle(fontSize: _fontSize - 2),
        ),
      ),
    );
  }
}
