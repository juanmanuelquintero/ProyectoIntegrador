import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario Accesible',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AccessibleFormScreen(),
    );
  }
}

class AccessibleFormScreen extends StatefulWidget {
  @override
  _AccessibleFormScreenState createState() => _AccessibleFormScreenState();
}

class _AccessibleFormScreenState extends State<AccessibleFormScreen> {
  final FlutterTts flutterTts = FlutterTts();
  final _formKey = GlobalKey<FormState>();

  // Controladores
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _mensajeController = TextEditingController();

  String _selectedOption = 'Opción 1';
  bool _aceptoTerminos = false;

  // 🎤 Agregado: instancia de reconocimiento de voz
  late stt.SpeechToText _speech;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initTts();
    _speech = stt.SpeechToText();
  }

  _initTts() async {
    await flutterTts.setLanguage("es-ES");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
  }

  _speak(String text) async {
    if (text.isNotEmpty) {
      await flutterTts.speak(text);
    }
  }

  _readFieldDescription(String fieldName, String description) {
    _speak("Campo $fieldName. $description");
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_aceptoTerminos) {
        _speak("Debe aceptar los términos y condiciones");
        return;
      }
      _speak("Formulario enviado correctamente. Gracias por registrarse");
    } else {
      _speak("Por favor, corrija los errores en el formulario");
    }
  }

  // 🎤 Iniciar dictado
  void _startListening(TextEditingController controller) async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        localeId: "es_ES",
        onResult: (result) {
          setState(() {
            controller.text = result.recognizedWords;
          });
        },
      );
    }
  }

  // 🎤 Detener dictado
  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FORMULARIO ACCESIBLE'),
        actions: [
          IconButton(
            icon: Icon(Icons.volume_up),
            onPressed:
                () => _speak(
                  "Formulario de registro. Complete todos los campos marcados como requeridos",
                ),
            tooltip: 'Leer instrucciones',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Complete el formulario:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.record_voice_over),
                    onPressed:
                        () => _speak(
                          "Formulario de registro. Complete todos los campos marcados con asterisco",
                        ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Campos con micrófono integrado
              _buildTextFieldWithSpeech(
                controller: _nombreController,
                label: 'Nombre completo *',
                hint: 'Ingrese su nombre completo',
                fieldName: 'Nombre completo',
                description: 'Requerido. Escriba su nombre y apellido',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              _buildTextFieldWithSpeech(
                controller: _emailController,
                label: 'Correo electrónico *',
                hint: 'ejemplo@correo.com',
                fieldName: 'Correo electrónico',
                description: 'Requerido. Ingrese un email válido',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su email';
                  }
                  if (!value.contains('@')) {
                    return 'Ingrese un email válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),

              _buildTextFieldWithSpeech(
                controller: _telefonoController,
                label: 'Teléfono',
                hint: '+57 300 123 4567',
                fieldName: 'Teléfono',
                description: 'Opcional. Ingrese su número de contacto',
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 15),

              _buildDropdownWithSpeech(),
              SizedBox(height: 15),

              _buildTextFieldWithSpeech(
                controller: _mensajeController,
                label: 'Mensaje o comentarios',
                hint: 'Escriba su mensaje aquí...',
                fieldName: 'Mensaje',
                description: 'Opcional. Escriba cualquier comentario adicional',
                maxLines: 4,
              ),
              SizedBox(height: 20),

              _buildCheckboxWithSpeech(),
              SizedBox(height: 30),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitForm,
                      icon: Icon(Icons.send),
                      label: Text('ENVIAR FORMULARIO'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed:
                        () => _speak(
                          "Botón enviar formulario. Presione para enviar la información",
                        ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Center(
                child: OutlinedButton.icon(
                  onPressed: () => _readFormSummary(),
                  icon: Icon(Icons.audio_file),
                  label: Text('LEER RESUMEN DEL FORMULARIO'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Micrófono DENTRO del campo (suffixIcon)
  Widget _buildTextFieldWithSpeech({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String fieldName,
    required String description,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            IconButton(
              icon: Icon(Icons.help_outline, size: 18),
              onPressed: () => _readFieldDescription(fieldName, description),
              tooltip: 'Leer descripción',
            ),
          ],
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
            suffixIcon: IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : Colors.grey,
              ),
              onPressed:
                  _isListening
                      ? _stopListening
                      : () => _startListening(controller),
              tooltip: 'Dictar por voz',
            ),
          ),
          onTap: () => _readFieldDescription(fieldName, description),
        ),
      ],
    );
  }

  Widget _buildDropdownWithSpeech() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tipo de consulta *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.help_outline, size: 18),
              onPressed:
                  () => _speak(
                    "Tipo de consulta. Seleccione una opción del menú desplegable",
                  ),
              tooltip: 'Leer descripción',
            ),
          ],
        ),
        SizedBox(height: 5),
        DropdownButtonFormField<String>(
          value: _selectedOption,
          items:
              ['Opción 1', 'Opción 2', 'Opción 3', 'Opción 4'].map((
                String value,
              ) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedOption = newValue!;
            });
            _speak("Seleccionado: $newValue");
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxWithSpeech() {
    return Row(
      children: [
        Checkbox(
          value: _aceptoTerminos,
          onChanged: (bool? value) {
            setState(() {
              _aceptoTerminos = value!;
            });
            _speak(value! ? "Términos aceptados" : "Términos no aceptados");
          },
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _aceptoTerminos = !_aceptoTerminos;
              });
              _speak(
                _aceptoTerminos
                    ? "Términos aceptados"
                    : "Términos no aceptados",
              );
            },
            child: Text(
              'Acepto los términos y condiciones *',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.help_outline, size: 18),
          onPressed:
              () => _speak(
                "Debe aceptar los términos y condiciones para continuar",
              ),
          tooltip: 'Leer descripción',
        ),
      ],
    );
  }

  void _readFormSummary() {
    String summary = """
Resumen del formulario. 
Nombre: ${_nombreController.text.isEmpty ? 'No ingresado' : _nombreController.text}. 
Email: ${_emailController.text.isEmpty ? 'No ingresado' : _emailController.text}. 
Teléfono: ${_telefonoController.text.isEmpty ? 'No ingresado' : _telefonoController.text}. 
Tipo de consulta: $_selectedOption. 
Mensaje: ${_mensajeController.text.isEmpty ? 'No ingresado' : _mensajeController.text}. 
Términos: ${_aceptoTerminos ? 'Aceptados' : 'No aceptados'}.
""";
    _speak(summary);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _emailController.dispose();
    _telefonoController.dispose();
    _mensajeController.dispose();
    flutterTts.stop();
    super.dispose();
  }
}
