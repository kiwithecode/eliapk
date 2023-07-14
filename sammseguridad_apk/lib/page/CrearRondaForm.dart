import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class CrearRondaForm extends StatefulWidget {
  final LatLng position;

  CrearRondaForm({required this.position});

  @override
  _CrearRondaFormState createState() => _CrearRondaFormState();
}

class _CrearRondaFormState extends State<CrearRondaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idRondaController = TextEditingController();
  XFile? _imageFile;

  String token = "";
  late MainProvider _mainProvider;
  late Future<void> _initToken;

  @override
  void initState() {
    super.initState();
    _mainProvider = Provider.of<MainProvider>(context, listen: false);
    _initToken = _initializeToken();
  }

  Future<void> _initializeToken() async {
    final tokenFromPrefs = await _mainProvider.getPreferencesToken();
    token = tokenFromPrefs.toString();
    _mainProvider.updateToken(token);
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final apiService = Provider.of<ApiService>(context, listen: false);

      final imageBytes = await rootBundle.load(_imageFile!.path);
      final base64Image = base64Encode(imageBytes.buffer.asUint8List());

      final result = await apiService.postData(
        '/puntoRonda',
        {
          'coordenadas': {
            'lat': widget.position.latitude,
            'lng': widget.position.longitude,
          },
          'idRonda': _idRondaController.text,
          'foto': base64Image,
        },
        token
      );

      if (result['message'] == 'Punto agregado exitosamente') {
        Navigator.pop(context, {
          'idRonda': _idRondaController.text,
        });
      } else {
        print('Error al agregar punto a la ronda');  // Replace with your error handling code
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = image;
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isObscured = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.blue, fontSize: 20.0),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 10.0),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: Colors.blue),
            ),
            suffixIcon: isObscured
                ? IconButton(
                    icon: Icon(
                      isObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscured = !isObscured;
                      });
                    },
                  )
                : null,
          ),
          obscureText: isObscured,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa un texto';
            }
            return null;
          },
        ),
        SizedBox(height: 10.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Datos de la Ronda')),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField('ID de la Ronda', _idRondaController),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Tomar foto'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Cargar desde galería'),
                  ),
                ],
              ),
              if (_imageFile != null)
                Image.network(_imageFile!.path),
              Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 80),
                    primary: Color(0xFF0040AE),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xFF0040AE), width: 2),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
