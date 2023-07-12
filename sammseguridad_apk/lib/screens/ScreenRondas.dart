import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sammseguridad_apk/page/PageGPS.dart';
import 'package:sammseguridad_apk/widgets/Appbar.dart';
import 'package:sammseguridad_apk/widgets/Drawer.dart';

class ScreenRondas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy', 'es').format(DateTime.now());

    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width + 10,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/FOTO-1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
    padding: EdgeInsets.only(top: 50.0), 
            child: Container(
              padding: EdgeInsets.all(10.0),
              margin: EdgeInsets.all(10.0),
              width: MediaQuery.of(context).size.width - 5,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Registro',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30.0, color: Color(0xFF0040AE)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Propiedades',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25.0, color: Color(0xFF001554)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Urbanización Pacho Salas',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          image: DecorationImage(
                            image: AssetImage('assets/images/mapa.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            '115 propiedades',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0, color: Color(0xff297DE2)),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '3 guardias activos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0, color: Color(0xff297DE2)),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PageGPS(),
                ),
              );
                      },
                      child: Text('Crear nueva ronda'),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),),
          Align(
  alignment: Alignment.topCenter,
  child: Padding(
    padding: const EdgeInsets.only(top: 14.0),
    child: Column(
      children: [
        Flexible(
          child: Text(
            "Fernando Pozo - Supervisor",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          child: Text(
            "1789340274",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 10),
        Flexible(
          child: Text(
            formattedDate,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
),

        ],
      ),
    );
  }
}
