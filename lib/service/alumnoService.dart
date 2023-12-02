import 'dart:convert';
import 'dart:io';

import 'package:flutter_app_1/models/alumno.dart';

class AlumnoService {
  
  static List<Alumno> listaAlumnos=[];

  static Future<bool> registrarAlumno(Alumno alumno) async {
    alumno.idAlumno=listaAlumnos.length;
    listaAlumnos.add(alumno);
    return true;
  }

  static Future<List<Alumno>> obtenerAlumnos() async {
    return listaAlumnos;
  }

  static Future<Alumno> obtenerAlumno(int idAlumno) async {
    Alumno alumno=listaAlumnos.where((element) => element.idAlumno==idAlumno).first;
    return alumno;
  }

  static Future<bool> actualizarAlumno(Alumno alumno) async {
    bool found = listaAlumnos.contains((element) => element.idAlumno == alumno.idAlumno);
    if(!found)return false;

    listaAlumnos[listaAlumnos.indexWhere((element) => element.idAlumno == alumno.idAlumno)] = alumno;
    return true;
  }

}
