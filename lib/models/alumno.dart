
import 'dart:convert';

Alumno alumnoFromJson(String str) => Alumno.fromJson(json.decode(str));
String alumnoToJson(Alumno data) => json.encode(data.toJson());

class Alumno {
  int idAlumno;
  String nombresAlumno;
  String apellidosAlumno;
  int edad;

  Alumno({
    required this.idAlumno,
    required this.nombresAlumno,
    required this.apellidosAlumno,
    required this.edad,
  });

  Map<String, dynamic> toMap() {
    return {
      'idAlumno': idAlumno,
      'nombres': nombresAlumno,
      'apellidos': apellidosAlumno,
      'edad': edad,
    };
  }

  @override
  String toString() {
    return 'Alumno{idAlumno: $idAlumno, nombresAlumno: $nombresAlumno, edad: $edad}';
  }

  factory Alumno.fromJson(Map<String, dynamic> json) => Alumno(
      idAlumno: json["idAlumno"],
      nombresAlumno: json["nombresAlumno"],
      apellidosAlumno: json["apellidosAlumno"],
      edad: json["edad"]);

  Map<String, dynamic> toJson() => {
        "idAlumno": idAlumno,
        "nombresAlumno": nombresAlumno,
        "apellidosAlumno": apellidosAlumno,
        "edad": edad
      };
}
