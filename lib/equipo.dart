class EquipoFields {
  static const List<String> values = [
    id,
    name,
    foundingYear,
    lastCampDate,
  ];
  static const String tableName = 'equipos';
  static const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  static const String textType = 'TEXT NOT NULL';
  static const String intType = 'INTEGER NOT NULL';
  static const String dateType = 'TEXT NOT NULL';
  static const String id = '_id';
  static const String name = 'name';
  static const String foundingYear = 'founding_year';
  static const String lastCampDate = 'last_camp_date';
}

class EquipoModel {
  int? id;
  final String name;
  final int foundingYear;
  final DateTime lastCampDate;

  EquipoModel({
    this.id,
    required this.name,
    required this.foundingYear,
    required this.lastCampDate,
  });

  Map<String, Object?> toJson() => {
        EquipoFields.id: id,
        EquipoFields.name: name,
        EquipoFields.foundingYear: foundingYear,
        EquipoFields.lastCampDate: lastCampDate.toIso8601String(),
      };

  factory EquipoModel.fromJson(Map<String, Object?> json) => EquipoModel(
        id: json[EquipoFields.id] as int?,
        name: json[EquipoFields.name] as String,
        foundingYear: json[EquipoFields.foundingYear] as int,
        lastCampDate: DateTime.parse(json[EquipoFields.lastCampDate] as String),
      );

  EquipoModel copy({
    int? id,
    String? name,
    int? foundingYear,
    DateTime? lastCampDate,
  }) =>
      EquipoModel(
        id: id ?? this.id,
        name: name ?? this.name,
        foundingYear: foundingYear ?? this.foundingYear,
        lastCampDate: lastCampDate ?? this.lastCampDate,
      );
}
