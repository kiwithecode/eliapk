import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sammseguridad_apk/services/ApiService.dart';
import 'package:geocoding/geocoding.dart';

class CrearRondaForm extends StatefulWidget {
  final LatLng position;

  CrearRondaForm({required this.position});

  @override
  _CrearRondaFormState createState() => _CrearRondaFormState();
}

class _CrearRondaFormState extends State<CrearRondaForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _observacionesController =
      TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

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
          _direccionController.text = [
            place.street,
            place.subLocality,
            place.locality,
            place.administrativeArea,
            place.country,
          ].join(', ');
        });
      }
    } on Exception {
      // Handle exception
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      // Get ApiService from the provider
      final apiService = Provider.of<ApiService>(context, listen: false);

      final result = await apiService.postData(
          '/crearRonda',
          {
            'coordenadas': {
              'lat': widget.position.latitude,
              'lng': widget.position.longitude,
            },
            'observaciones': _observacionesController.text,
            'estado': _estadoController.text,
            'direccion': _direccionController.text,
          },
          "" // add token here
          );

      if (result['message'] == 'Ronda creada exitosamente') {
        Navigator.pop(context, {
          'observaciones': _observacionesController.text,
          'estado': _estadoController.text,
          'direccion': _direccionController.text,
        });
      } else {
        print(
            'Error al crear la ronda'); // Replace with your error handling code
      }
    }
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
              _buildTextField('Observaciones', _observacionesController),
              _buildTextField('Estado', _estadoController),
              _buildTextField('Dirección', _direccionController),
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
