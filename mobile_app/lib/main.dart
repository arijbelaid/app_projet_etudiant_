import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Étudiants',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      home: HomePage(),
    );
  }
}

// ========================= MODÈLES =========================
class Etudiant {
  final int id;
  final String cin;
  final String nom;
  final DateTime dateNaissance;
  final String email;
  final int anneePremiereInscription;
  final int departementId;
  final String? departementNom;

  Etudiant({
    required this.id,
    required this.cin,
    required this.nom,
    required this.dateNaissance,
    required this.email,
    required this.anneePremiereInscription,
    required this.departementId,
    this.departementNom,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) => Etudiant(
    id: json['id'],
    cin: json['cin'],
    nom: json['nom'],
    dateNaissance: DateTime.parse(json['dateNaissance']),
    email: json['email'],
    anneePremiereInscription: json['anneePremiereInscription'],
    departementId: json['departementId'],
    departementNom: json['departementNom'],
  );

  Map<String, dynamic> toJson() => {
    'cin': cin,
    'nom': nom,
    'dateNaissance': dateNaissance.toIso8601String().split('T')[0],
    'email': email,
    'anneePremiereInscription': anneePremiereInscription,
    'departementId': departementId,
  };
}

class Departement {
  final int id;
  final String nom;
  Departement({required this.id, required this.nom});
  factory Departement.fromJson(Map<String, dynamic> json) =>
      Departement(id: json['id'], nom: json['nom']);
}

// ========================= SERVICE API =========================
class ApiService {
  static const String baseUrl = 'http://localhost:8080'; // À adapter

  static Future<List<Etudiant>> getEtudiants() async {
    final res = await http.get(Uri.parse('$baseUrl/api/etudiants'));
    if (res.statusCode == 200) {
      List json = jsonDecode(res.body);
      return json.map((e) => Etudiant.fromJson(e)).toList();
    }
    throw Exception('Erreur chargement étudiants');
  }

  static Future<Etudiant> createEtudiant(Etudiant e) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/etudiants'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(e.toJson()),
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Etudiant.fromJson(jsonDecode(res.body));
    throw Exception('Erreur création étudiant');
  }

  static Future<Etudiant> updateEtudiant(int id, Etudiant e) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/etudiants/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(e.toJson()),
    );
    if (res.statusCode == 200) return Etudiant.fromJson(jsonDecode(res.body));
    throw Exception('Erreur modification étudiant');
  }

  static Future<void> deleteEtudiant(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/api/etudiants/$id'));
    if (res.statusCode != 204) throw Exception('Erreur suppression étudiant');
  }

  static Future<List<Departement>> getDepartements() async {
    final res = await http.get(Uri.parse('$baseUrl/api/departements'));
    if (res.statusCode == 200) {
      List json = jsonDecode(res.body);
      return json.map((d) => Departement.fromJson(d)).toList();
    }
    throw Exception('Erreur chargement départements');
  }

  static Future<Departement> createDepartement(String nom) async {
    final res = await http.post(
      Uri.parse('$baseUrl/api/departements'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nom}),
    );
    if (res.statusCode == 201 || res.statusCode == 200)
      return Departement.fromJson(jsonDecode(res.body));
    throw Exception('Erreur création département');
  }

  static Future<Departement> updateDepartement(int id, String nom) async {
    final res = await http.put(
      Uri.parse('$baseUrl/api/departements/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nom}),
    );
    if (res.statusCode == 200) return Departement.fromJson(jsonDecode(res.body));
    throw Exception('Erreur modification département');
  }

  static Future<void> deleteDepartement(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/api/departements/$id'));
    if (res.statusCode != 204) throw Exception('Erreur suppression département');
  }
}

// ========================= PAGE PRINCIPALE (ONGLETS) =========================
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    EtudiantsPage(),
    DepartementsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Étudiants'),
          BottomNavigationBarItem(icon: Icon(Icons.business), label: 'Départements'),
        ],
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.indigo,
      ),
    );
  }
}

// ========================= PAGE ÉTUDIANTS =========================
class EtudiantsPage extends StatefulWidget {
  @override
  _EtudiantsPageState createState() => _EtudiantsPageState();
}

class _EtudiantsPageState extends State<EtudiantsPage> {
  List<Etudiant> _etudiants = [];
  List<Departement> _departements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final etuds = await ApiService.getEtudiants();
      final depts = await ApiService.getDepartements();
      setState(() {
        _etudiants = etuds;
        _departements = depts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar('Erreur: $e');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _openForm({Etudiant? etudiant}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EtudiantForm(etudiant: etudiant, departements: _departements),
      ),
    );
    if (result == true) _loadData();
  }

  Future<void> _deleteEtudiant(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer définitivement cet étudiant ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ApiService.deleteEtudiant(id);
        _loadData();
        _showSnackBar('Étudiant supprimé');
      } catch (e) {
        _showSnackBar('Erreur suppression');
      }
    }
  }

  String _getInitials(String nom) {
    List<String> parts = nom.trim().split(' ');
    if (parts.length >= 2) return parts[0][0] + parts[1][0];
    return nom.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étudiants'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(),
            tooltip: 'Ajouter un étudiant',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _etudiants.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.people_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Aucun étudiant', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Appuyez sur + pour ajouter', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadData,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: _etudiants.length,
          itemBuilder: (ctx, i) {
            final e = _etudiants[i];
            return Card(
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _openForm(etudiant: e),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.indigo.shade100,
                        child: Text(
                          _getInitials(e.nom),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.indigo.shade800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.badge, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('CIN: ${e.cin}', style: TextStyle(color: Colors.grey[600])),
                                const SizedBox(width: 12),
                                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('${e.dateNaissance.year}', style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.business, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  e.departementNom ?? 'Département ${e.departementId}',
                                  style: TextStyle(color: Colors.indigo.shade700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteEtudiant(e.id),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ========================= FORMULAIRE ÉTUDIANT =========================
class EtudiantForm extends StatefulWidget {
  final Etudiant? etudiant;
  final List<Departement> departements;
  const EtudiantForm({this.etudiant, required this.departements});
  @override
  _EtudiantFormState createState() => _EtudiantFormState();
}

class _EtudiantFormState extends State<EtudiantForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cinCtrl, _nomCtrl, _emailCtrl, _anneeCtrl, _dateCtrl;
  late int _selectedDeptId;

  @override
  void initState() {
    super.initState();
    _cinCtrl = TextEditingController(text: widget.etudiant?.cin);
    _nomCtrl = TextEditingController(text: widget.etudiant?.nom);
    _emailCtrl = TextEditingController(text: widget.etudiant?.email);
    _anneeCtrl = TextEditingController(text: widget.etudiant?.anneePremiereInscription.toString());
    _dateCtrl = TextEditingController(text: widget.etudiant?.dateNaissance.toIso8601String().split('T')[0]);
    _selectedDeptId = widget.etudiant?.departementId ?? (widget.departements.isNotEmpty ? widget.departements.first.id : 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.etudiant == null ? 'Nouvel étudiant' : 'Modifier étudiant'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_cinCtrl, 'CIN', Icons.credit_card),
              const SizedBox(height: 16),
              _buildTextField(_nomCtrl, 'Nom complet', Icons.person),
              const SizedBox(height: 16),
              _buildTextField(_emailCtrl, 'Email', Icons.email, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_anneeCtrl, 'Année d\'inscription', Icons.calendar_month, keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(_dateCtrl, 'Date de naissance (YYYY-MM-DD)', Icons.cake),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _selectedDeptId,
                decoration: const InputDecoration(
                  labelText: 'Département',
                  prefixIcon: Icon(Icons.business),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                items: widget.departements.map((d) => DropdownMenuItem(value: d.id, child: Text(d.nom))).toList(),
                onChanged: (v) => setState(() => _selectedDeptId = v!),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 3,
                ),
                child: Text(
                  widget.etudiant == null ? 'Créer l\'étudiant' : 'Enregistrer les modifications',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: ctrl,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
      keyboardType: keyboardType,
      validator: (v) => v == null || v.isEmpty ? 'Champ requis' : null,
    );
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      try {
        final date = DateTime.parse(_dateCtrl.text);
        final etudiant = Etudiant(
          id: widget.etudiant?.id ?? 0,
          cin: _cinCtrl.text,
          nom: _nomCtrl.text,
          dateNaissance: date,
          email: _emailCtrl.text,
          anneePremiereInscription: int.parse(_anneeCtrl.text),
          departementId: _selectedDeptId,
        );
        if (widget.etudiant == null) {
          await ApiService.createEtudiant(etudiant);
        } else {
          await ApiService.updateEtudiant(widget.etudiant!.id, etudiant);
        }
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _cinCtrl.dispose();
    _nomCtrl.dispose();
    _emailCtrl.dispose();
    _anneeCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }
}

// ========================= PAGE DÉPARTEMENTS =========================
class DepartementsPage extends StatefulWidget {
  @override
  _DepartementsPageState createState() => _DepartementsPageState();
}

class _DepartementsPageState extends State<DepartementsPage> {
  List<Departement> _departements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final depts = await ApiService.getDepartements();
      setState(() {
        _departements = depts;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      _showSnackBar('Erreur: $e');
    }
  }

  void _showSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _openForm({Departement? departement}) async {
    final nomCtrl = TextEditingController(text: departement?.nom);
    final isEdit = departement != null;
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Modifier département' : 'Ajouter département'),
        content: TextField(
          controller: nomCtrl,
          decoration: const InputDecoration(
            labelText: 'Nom',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              if (nomCtrl.text.isNotEmpty) {
                try {
                  if (isEdit) {
                    await ApiService.updateDepartement(departement!.id, nomCtrl.text);
                  } else {
                    await ApiService.createDepartement(nomCtrl.text);
                  }
                  Navigator.pop(context, true);
                } catch (e) {
                  _showSnackBar('Erreur: $e');
                  Navigator.pop(context, false);
                }
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (result == true) _loadData();
  }

  Future<void> _deleteDepartement(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Supprimer définitivement ce département ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      try {
        await ApiService.deleteDepartement(id);
        _loadData();
        _showSnackBar('Département supprimé');
      } catch (e) {
        _showSnackBar('Erreur suppression');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Départements'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(),
            tooltip: 'Ajouter un département',
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _departements.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.business_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Aucun département', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            const Text('Appuyez sur + pour ajouter', style: TextStyle(color: Colors.grey)),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _departements.length,
        itemBuilder: (ctx, i) {
          final d = _departements[i];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      d.nom[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.indigo.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d.nom, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('ID: ${d.id}', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () => _openForm(departement: d),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _deleteDepartement(d.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}