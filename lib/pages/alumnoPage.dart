import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_1/models/alumno.dart';
import 'package:flutter_app_1/service/alumnoService.dart';

class AlumnoPage extends StatefulWidget {
  const AlumnoPage({super.key, required this.title});

  final String title;

  @override
  State<AlumnoPage> createState() => _AlumnoPageState();
}

class _AlumnoPageState extends State<AlumnoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: _crearAppBar(widget.title),
      ),
    );
  }

  _crearAppBar(String titulo) {
    return Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [Tab(icon: Icon(Icons.list)), Tab(icon: Icon(Icons.person))]
        ),
        title: Text(titulo)
      ),
      body: const TabBarView(
        children: [
          ListaAlumno(),
          FormularioAlumno(),
        ],
      ),
    );
  }
}

// Create a List widget.
class ListaAlumno extends StatefulWidget {
  const ListaAlumno({super.key});

  @override
  ListaAlumnoState createState() {
    return ListaAlumnoState();
  }
}

class ListaAlumnoState extends State<ListaAlumno> {
  // final alumnoService = AlumnoService();
  @override
  Widget build(BuildContext context) {
    return _crearListado();
  }

  _crearListado() {
    return FutureBuilder(
      future: AlumnoService.obtenerAlumnos(),
      builder: (BuildContext context, AsyncSnapshot<List<Alumno>> snapshot) {
        // WHILE THE CALL IS BEING MADE AKA LOADING
        if (ConnectionState.active != null && !snapshot.hasData) {
          return Center(child: Text('Loading'));
        }

        // WHEN THE CALL IS DONE BUT HAPPENS TO HAVE AN ERROR
        if (ConnectionState.done != null && snapshot.hasError) {
          return Center(child: Text("Error"));
        }

        final alumnos = snapshot.data;
        print(alumnos);
        return ListView.builder(
          itemCount: alumnos?.length,
          itemBuilder: (context, index) {
            return _crearItem(context, alumnos![index]);
          },
        );
      },
    );
  }

  _crearItem(BuildContext context, Alumno alumno) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(Icons.delete),
      ),
      child: ListTile(
        title: Text('${alumno.nombresAlumno}'),
        subtitle: Text(alumno.apellidosAlumno),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(alumno.nombresAlumno[0]),
        ),
        onTap: () =>
            Navigator.pushNamed(context, 'producto', arguments: alumno),
      ),
      onDismissed: (direccion) {
        print(alumno.idAlumno);
      },
    );
  }
}

// Create a Form widget.
class FormularioAlumno extends StatefulWidget {
  const FormularioAlumno({super.key, this.idAlumno});
  final int? idAlumno;

  @override
  FormularioAlumnoState createState() {
    return FormularioAlumnoState();
  }
}

class FormularioAlumnoState extends State<FormularioAlumno> {
  final _formKey = GlobalKey<FormState>();
  // final alumnoService =  AlumnoService();
  Alumno alumno =
      Alumno(idAlumno: 0, nombresAlumno: '', apellidosAlumno: '', edad: 0);

  @override
  Widget build(BuildContext context) {
    final Alumno? alumnoData =
        ModalRoute.of(context)!.settings.arguments as Alumno?;

    if (alumnoData != null) {
      alumno = alumnoData;
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _agregarImagen(),
              _crearNombre(),
              _crearApellido(),
              _crearEdad(),
              _crearBotonRegistrar()
            ],
          ),
        ));
  }

  _agregarImagen() {
    return const Image(
      image: AssetImage('assets/images/user.png'),
      height: 200,
      width: 200,
    );
  }

  _crearNombre() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Nombre',
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          if (value.contains("@")) {
            return "Nombre no válido";
          }
        },
        onSaved: (String? value) => alumno.nombresAlumno = value!,
      ),
    );
  }

  _crearApellido() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Apellidos',
        ),
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          if (value.contains("@")) {
            return "Apellidos no válido";
          }
        },
        onSaved: (String? value) => alumno.apellidosAlumno = value!,
      ),
    );
  }

  _crearEdad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextFormField(
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Edad',
        ),
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        validator: (value) {
          if (value == null || value == "") {
            return 'no válido';
          }
          int valor = int.parse(value);
          if (valor > 100 || valor < 1) {
            return "Edad no válido";
          }
        },
        onSaved: (String? value) => alumno.edad = int.parse(value!),
      ),
    );
  }

  _crearBotonRegistrar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      child: ElevatedButton(
        onPressed: () {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrando')),
          );

          _formKey.currentState!.save();

          print(alumno.nombresAlumno);
          print(alumno.apellidosAlumno);
          print(alumno.edad);

          AlumnoService.registrarAlumno(alumno);

          _formKey.currentState!.reset();
        },
        child: const Text('Registrar'),
      ),
    );
  }
}
