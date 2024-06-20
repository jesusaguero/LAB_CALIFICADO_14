import 'package:flutter/material.dart';

import 'equipo.dart';
import 'equipo_database.dart';
import 'equipo_details_view.dart';

class EquiposView extends StatefulWidget {
  const EquiposView({super.key});

  @override
  State<EquiposView> createState() => _EquiposViewState();
}

class _EquiposViewState extends State<EquiposView> {
  EquipoDatabase equipoDatabase = EquipoDatabase.instance;
  List<EquipoModel> equipos = [];

  @override
  void initState() {
    refreshEquipos();
    super.initState();
  }

  @override
  dispose() {
    //close the database
    equipoDatabase.close();
    super.dispose();
  }

  ///Gets all the equipos from the database and updates the state
  refreshEquipos() {
    equipoDatabase.readAll().then((value) {
      setState(() {
        equipos = value;
      });
    });
  }

  ///Navigates to the EquipoDetailsView and refreshes the equipos after the navigation
  goToEquipoDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EquipoDetailsView(equipoId: id)),
    );
    refreshEquipos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipos'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Center(
        child: equipos.isEmpty
            ? const Text('No Equipos yet')
            : ListView.builder(
                itemCount: equipos.length,
                itemBuilder: (context, index) {
                  final equipo = equipos[index];
                  return GestureDetector(
                    onTap: () => goToEquipoDetailsView(id: equipo.id),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                equipo.lastCampDate.toString().split(' ')[0],
                              ),
                              Text(
                                equipo.name,
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToEquipoDetailsView(),
        tooltip: 'Create Equipo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
