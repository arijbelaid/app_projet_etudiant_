import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ==================== MODÈLE ÉTUDIANT ====================
class Etudiant {
  final int id;
  final String cin;
  final String nom;
  final DateTime dateNaissance;

  Etudiant({
    required this.id,
    required this.cin,
    required this.nom,
    required this.dateNaissance,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: json['id'],
      cin: json['cin'],
      nom: json['nom'],
      dateNaissance: DateTime.parse(json['dateNaissance']),
    );
  }
}

// ==================== SERVICE API ====================
class ApiService {
  // ⚠️ Remplace par l’IP de ta machine (ipconfig / ifconfig)
  // Ne pas utiliser localhost ou 127.0.0.1 (l'émulateur/telephone ne le verra pas)
  static const String baseUrl = 'http://localhost:8080/api/etudiants';
  Future<List<Etudiant>> fetchEtudiants() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((e) => Etudiant.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement des étudiants (code: ${response.statusCode})');
    }
  }
}

// ==================== ÉCRAN PRINCIPAL ====================
class ListeEtudiants extends StatefulWidget {
  @override
  _ListeEtudiantsState createState() => _ListeEtudiantsState();
}

class _ListeEtudiantsState extends State<ListeEtudiants> {
  late Future<List<Etudiant>> futureEtudiants;

  @override
  void initState() {
    super.initState();
    futureEtudiants = ApiService().fetchEtudiants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des étudiants'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Etudiant>>(
        future: futureEtudiants,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Erreur: ${snapshot.error}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureEtudiants = ApiService().fetchEtudiants();
                      });
                    },
                    child: Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Aucun étudiant trouvé'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final etudiant = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(etudiant.nom[0].toUpperCase()),
                  ),
                  title: Text(
                    etudiant.nom,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('CIN: ${etudiant.cin}'),
                  trailing: Text(
                    '${etudiant.dateNaissance.day}/${etudiant.dateNaissance.month}/${etudiant.dateNaissance.year}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==================== POINT D'ENTRÉE ====================
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Étudiants',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListeEtudiants(),
    );
  }
}