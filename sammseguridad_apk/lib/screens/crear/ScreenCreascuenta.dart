import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScreenCreascuenta extends StatefulWidget {
  @override
  _ScreenCreascuentaState createState() => _ScreenCreascuentaState();
}

class _ScreenCreascuentaState extends State<ScreenCreascuenta> {
  XFile? _imageFile;
  int _currentStep = 0;
  List<int> _pin = [];

  Future getImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
        _currentStep++;
      });
    }
  }

  void confirmPhoto() {
    if (_imageFile != null) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void createPIN() {
    setState(() {
      _currentStep++;
    });
  }

  void submitForm() {
    // Aquí puedes agregar la lógica para enviar el formulario de creación de cuenta
    // por ejemplo, hacer una llamada a una API para registrar la cuenta
  }

  Widget _buildNumberButton(int number) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
        onPressed: () => onNumberSelected(number),
        child: Text(
          number.toString(),
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF001554),
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  void onNumberSelected(int number) {
    setState(() {
      if (_pin.length < 4) {
        _pin.add(number);
      }
      if (_pin.length == 4) {
        createPIN();
      }
    });
  }

  Widget _buildPINIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        if (index < _pin.length) {
          return CircleAvatar(
            radius: 12,
            backgroundColor: Color(0xFF001554),
          );
        }
        return CircleAvatar(
          radius: 12,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        body: Container(
          color: Colors.white,
          child: Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              setState(() {
                if (_currentStep < 3) {
                  _currentStep++;
                } else {
                  submitForm();
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (_currentStep > 0) {
                  _currentStep--;
                }
              });
            },
            steps: [
              Step(
                title: Text('Reconocimiento Facial',
                    style: TextStyle(color: Color(0xFF001554))),
                isActive: _currentStep == 0,
                content: Column(
                  children: [
                    ElevatedButton(
                      onPressed: getImage,
                      child: Text('Tomar Foto',
                          style: TextStyle(color: Colors.white)),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF001554)),
                    ),
                    if (_imageFile != null)
                      Image.file(
                        File(_imageFile!.path),
                        height: 200,
                      ),
                  ],
                ),
              ),
              Step(
                title: Text('Confirmar Foto',
                    style: TextStyle(color: Color(0xFF001554))),
                isActive: _currentStep == 1,
                content: Column(
                  children: [
                    if (_imageFile != null)
                      Image.file(
                        File(_imageFile!.path),
                        height: 200,
                      ),
                    ElevatedButton(
                      onPressed: confirmPhoto,
                      child: Text('Confirmar Foto',
                          style: TextStyle(color: Colors.white)),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF001554)),
                    ),
                  ],
                ),
              ),
              Step(
                title: Text('Crear PIN',
                    style: TextStyle(color: Color(0xFF001554))),
                isActive: _currentStep == 2,
                content: Column(
                  children: [
                    Text(
                      'Ingrese un PIN para su cuenta:',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 20),
                    _buildPINIndicator(),
                    SizedBox(height: 20),
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: List.generate(9, (index) {
                        return _buildNumberButton(index + 1);
                      })
                        ..add(_buildNumberButton(0))
                        ..add(
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_pin.isNotEmpty) {
                                  _pin.removeLast();
                                }
                              });
                            },
                            child: Text(
                              'Borrar',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF001554),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                            ),
                          ),
                        )
                        
                        ..add(
                          ElevatedButton(
                            onPressed: _pin.length == 4 ? createPIN : null,
                            child: Text(
                              'OK',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF001554),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 20),
                            ),
                          ),
                        ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Step(
                title: Text('Crear Cuenta',
                    style: TextStyle(color: Color(0xFF001554))),
                isActive: _currentStep == 3,
                content: Column(
                  children: [
                    Text('Ingrese los datos para crear su cuenta:'),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Nombres completos',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Apellidos completos',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Cédula de identidad',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Correo electrónico',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Número de celular',
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                      ),
                    ),
                    SizedBox(height: 20),
                   
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
