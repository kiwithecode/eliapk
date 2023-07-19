import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:sammseguridad_apk/provider/mainprovider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

const _buttonColor = Color(0xFF0040AE);

class CrearRondaForm extends StatefulWidget {
  final LatLng position;

  CrearRondaForm({required this.position});

  @override
  _CrearRondaFormState createState() => _CrearRondaFormState();
}

class _CrearRondaFormState extends State<CrearRondaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _idRondaController = TextEditingController();
  final _picker = ImagePicker();
  File? _imageFile;
  String _direccionLabel = "";

  @override
  void initState() {
    super.initState();
    _setInitialAddress();
  }

  Future<void> _setInitialAddress() async {
    try {
      final placemarks = await placemarkFromCoordinates(
        widget.position.latitude,
        widget.position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        setState(() {
          _direccionLabel = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].join(', ');
        });
      }
    } on Exception {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al obtener la dirección inicial'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final mainProvider = Provider.of<MainProvider>(context, listen: false);
        final apiService = Provider.of<ApiService>(context, listen: false);

        String? dataToken = await mainProvider.getPreferencesToken();
        if (dataToken == null) throw Exception("Error al obtener el token");

        String token = dataToken;
        mainProvider.updateToken(token);

        // Convierte la imagen en un MultipartFile
        final imageUploadRequest = http.MultipartRequest(
            'POST', Uri.parse(apiService.getServiceUrl('rondas/puntoRonda')));

        // Aquí es donde agregas el token a los encabezados
        imageUploadRequest.headers.addAll({
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer $token',
        });

        if (_imageFile != null) {
          final file = await http.MultipartFile.fromPath(
            'picture',
            _imageFile!.path,
            contentType: MediaType('image', 'jpeg'),
          );
          imageUploadRequest.files.add(file);
        }

        imageUploadRequest.fields['coordenadas'] = jsonEncode({
          'lat': widget.position.latitude,
          'lng': widget.position.longitude,
        });

        imageUploadRequest.fields['idRonda'] = _idRondaController.text;

        final streamedResponse = await imageUploadRequest.send();
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          Navigator.pop(context, {
            'idRonda': _idRondaController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Punto agregado exitosamente'),
            backgroundColor: Colors.green,
          ));
        } else {
          throw Exception("Error al agregar el punto");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('$e'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _setImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) {
        throw Exception('No se seleccionó ninguna imagen.');
      }

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('$e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  ElevatedButton _buildElevatedButton(
      {required VoidCallback onPressed,
      required String label,
      required Icon icon}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: _buttonColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: _buttonColor, width: 2),
          borderRadius: BorderRadius.circular(0.0),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isObscured = false}) {
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
      appBar: AppBar(
        title: Text('Datos de la Ronda'),
        backgroundColor: _buttonColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTextField('ID Ronda', _idRondaController),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Dirección',
                  style: TextStyle(color: Colors.blue, fontSize: 20.0),
                ),
              ),
              Text(_direccionLabel),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildElevatedButton(
                      onPressed: () => _setImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt),
                      label: 'Tomar Foto',
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    flex: 5,
                    child: _buildElevatedButton(
                      onPressed: () => _setImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library_outlined),
                      label: 'Galeria',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Image.file(
                    _imageFile!,
                    height: 200, // Set as needed
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 10.0),
              ElevatedButton(
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
                  primary: _buttonColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: _buttonColor, width: 2),
                    borderRadius: BorderRadius.circular(0.0),
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
