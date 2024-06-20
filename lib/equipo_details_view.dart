import 'package:flutter/material.dart';

import 'equipo.dart';
import 'equipo_database.dart';

class EquipoDetailsView extends StatefulWidget {
  const EquipoDetailsView({super.key, this.equipoId});
  final int? equipoId;

  @override
  State<EquipoDetailsView> createState() => _EquipoDetailsViewState();
}

class _EquipoDetailsViewState extends State<EquipoDetailsView> {
  EquipoDatabase equipoDatabase = EquipoDatabase.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController foundingYearController = TextEditingController();
  DateTime? lastCampDate;
  late EquipoModel equipo;
  bool isLoading = false;
  bool isNewEquipo = false;

  @override
  void initState() {
    refreshEquipos();
    super.initState();
  }

  refreshEquipos() {
    if (widget.equipoId == null) {
      setState(() {
        isNewEquipo = true;
      });
      return;
    }
    equipoDatabase.read(widget.equipoId!).then((value) {
      setState(() {
        equipo = value;
        nameController.text = equipo.name;
        foundingYearController.text = equipo.foundingYear.toString();
        lastCampDate = equipo.lastCampDate;
      });
    });
  }

  createEquipo() {
    setState(() {
      isLoading = true;
    });
    final model = EquipoModel(
      name: nameController.text,
      foundingYear: int.parse(foundingYearController.text),
      lastCampDate: lastCampDate ?? DateTime.now(),
    );
    if (isNewEquipo) {
      equipoDatabase.create(model);
    } else {
      model.id = equipo.id;
      equipoDatabase.update(model);
    }
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  deleteEquipo() {
    equipoDatabase.delete(equipo.id!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNewEquipo ? 'New Equipo' : 'Edit Equipo'),
        actions: [
          if (!isNewEquipo)
            IconButton(
              onPressed: deleteEquipo,
              icon: const Icon(Icons.delete),
            ),
          IconButton(
            onPressed: createEquipo,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    controller: foundingYearController,
                    decoration: const InputDecoration(labelText: 'Founding Year'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: lastCampDate ?? DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        setState(() {
                          lastCampDate = date;
                        });
                      }
                    },
                    child: Text(
                      lastCampDate == null
                          ? 'Select Last Camp Date'
                          : 'Last Camp Date: ${lastCampDate!.toLocal()}'.split(' ')[0],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
