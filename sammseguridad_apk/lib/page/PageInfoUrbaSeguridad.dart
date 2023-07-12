import 'package:flutter/material.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/Drawer.dart';

class PageInfoUrbaSeguridad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/FOTO-1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(height: 20),
                Text(
                  'Información',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30.0, color: Color(0xFF0040AE)),
                ),
                SizedBox(height: 10),
                Text(
                  'Seguridad',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25.0, color: Color(0xFF001554)),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: AssetImage('assets/images/SAMM.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      children: [
                        Text(
                          'Guardia',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20.0, color: Color(0xff297DE2)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Nombre: Texto',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(0xff297DE2)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Cedula: Texto',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(0xff297DE2)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Telefono: Texto',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(0xff297DE2)),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Estado: Texto',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18.0, color: Color(0xff297DE2)),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
