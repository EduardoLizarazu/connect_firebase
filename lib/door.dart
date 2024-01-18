import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoorStateWidget extends StatelessWidget {
  const DoorStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estado de la Puerta'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('group').doc('zJcb2Ks87S5RTcs6Twfq')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          bool isOpened = snapshot.data!['door'] == 1;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isOpened
                    ? Image.asset(
                  'assets/door_open.png',
                  width: 200.0,
                  height: 200.0,
                )
                    : Image.asset(
                  'assets/door_close.png',
                  width: 200.0,
                  height: 200.0,
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    updateDoorState(isOpened ? 0 : 1);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      isOpened ? Colors.red : Colors.green,
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(200.0, 50.0),
                    ),
                  ),
                  child: Text(
                    isOpened ? 'Cerrar puerta' : 'Abrir puerta',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> updateDoorState(int newState) async {
  try {
    CollectionReference groupCollection = FirebaseFirestore.instance.collection('group');
    DocumentReference documentRef = groupCollection.doc('zJcb2Ks87S5RTcs6Twfq');

    await documentRef.update({'door': newState});

    print('Campo "door" actualizado correctamente.');
  } catch (e) {
    print('Error al actualizar el campo "door": $e');
  }
}