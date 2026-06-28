import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ==========================================
// CONFIGURATIONS ET NOTIFIERS GLOBAUX
// ==========================================

final ValueNotifier<List<Map<String, dynamic>>> listeActivitesNotifier = ValueNotifier([
  {
    "date": "Hier - 07:00",
    "title": "Irrigation automatisée",
    "description": "Arrosage activé pendant 45 min. Volume d'eau distribué : 120L.",
    "icon": Icons.water_drop,
    "iconColor": Colors.blue,
  },
  {
    "date": "05 Juin 2026",
    "title": "Ajout de fertilisant",
    "description": "Engrais organique appliqué sur la zone de Riz pour booster la croissance.",
    "icon": Icons.yard,
    "iconColor": Colors.green,
  },
  {
    "date": "01 Juin 2026",
    "title": "Création de la Saison",
    "description": "Lancement de la nouvelle saison de culture 'Saison Principale 2026'.",
    "icon": Icons.add_box,
    "iconColor": Colors.black54,
  },
]);

final ValueNotifier<ResultatAnalyseIA> diagnosticIANotifier = ValueNotifier(
  ResultatAnalyseIA(
    maladie: "Sain",
    confiance: 100.0,
    estMalade: false,
  ),
);

class SensorData {
  final double humiditeSol;
  final double reservoirEau;
  final double temperatureAir;
  final bool enLigne;

  SensorData({
    required this.humiditeSol,
    required this.reservoirEau,
    required this.temperatureAir,
    required this.enLigne,
  });
}

class ResultatAnalyseIA {
  final String maladie;
  final double confiance;
  final bool estMalade;

  ResultatAnalyseIA({
    required this.maladie,
    required this.confiance,
    required this.estMalade,
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgriSmartSplashScreen(),
    );
  }
}

// ==========================================
// 1. ÉCRAN DE BIENVENUE / SPLASH
// ==========================================
class AgriSmartSplashScreen extends StatelessWidget {
  const AgriSmartSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AgriSmartLogin()),
            );
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'AgriGUARD',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Surveillance Intelligente & Connectée',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 50),
              Icon(Icons.touch_app, color: Colors.white38, size: 30),
              Text('Appuyez pour commencer', style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 2. ÉCRAN DE CONNEXION
// ==========================================
class AgriSmartLogin extends StatefulWidget {
  const AgriSmartLogin({super.key});

  @override
  State<AgriSmartLogin> createState() => _AgriSmartLoginState();
}

class _AgriSmartLoginState extends State<AgriSmartLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _tenterConnexion() {
    if (_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir l'email et le mot de passe !"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'AgriGUARD',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "EMAIL / NOM D'UTILISATEUR",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Entrer votre email',
                          hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "MOTS DE PASSE",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          hintText: 'Entrer votre mots de passe',
                          hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                      activeColor: const Color(0xFF66BB46),
                    ),
                    const Text(
                      'Rester connecté',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB46),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _tenterConnexion,
                  child: const Text(
                    'SE CONNECTER',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 25),

                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white38, indent: 20, endIndent: 10)),
                    Text('Ou', style: TextStyle(color: Colors.white70)),
                    Expanded(child: Divider(color: Colors.white38, indent: 10, endIndent: 20)),
                  ],
                ),
                const SizedBox(height: 25),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB46),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
                    );
                  },
                  icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 30),
                  label: const Text(
                    'continuer avec google',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas de compte ? ", style: TextStyle(color: Colors.white60, fontSize: 12)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Créer-en un gratuitement !",
                        style: TextStyle(color: Color(0xFF66BB46), fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// ==========================================
// 3. TABLEAU DE BORD PRINCIPAL : CARTE (CORRIGÉ)
// ==========================================
class AgriSmartMapScreen extends StatefulWidget {
  const AgriSmartMapScreen({super.key});

  @override
  State<AgriSmartMapScreen> createState() => _AgriSmartMapScreenState();
}

class _AgriSmartMapScreenState extends State<AgriSmartMapScreen> {
  GoogleMapController? _mapController;
  
  // Coordonnées par défaut (Ambodrabiby / Antananarivo)
  LatLng _currentLatLng = const LatLng(-18.7994, 47.5614);
  String _currentLocationName = "Recherche de la position...";
  final double _currentTemperature = 25.0;

  @override
  void initState() {
    super.initState();
    _initRealTimeLocation();
  }

  Future<void> _initRealTimeLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _currentLocationName = "GPS désactivé");
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _currentLocationName = "Permissions refusées");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _currentLocationName = "Permissions bloquées");
        return;
      }

      // Récupération de la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
      );
      
      LatLng nouvellePosition = LatLng(position.latitude, position.longitude);

      // Récupération du nom du lieu (Geocoding) avec sécurité
      String nomLieu = "Antananarivo, Madagascar";
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final pm = placemarks.first;
          nomLieu = "${pm.locality ?? pm.name ?? 'Position actuelle'}";
        }
      } catch (_) {
        // Sécurité si le service de géocodage web/simulateur échoue
        nomLieu = "Position active";
      }

      if (mounted) {
        setState(() {
          _currentLatLng = nouvellePosition;
          _currentLocationName = "📍 $nomLieu";
        });

        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: nouvellePosition, zoom: 16.5),
          ),
        );
      }
    } catch (e) {
      debugPrint("Erreur de localisation : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("rookie's code", style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                      Text("Project", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                  const Text(
                    'AgriGUARD',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AgriSmartActivityScreen()));
                              },
                              child: _buildTabButton("Activité", isActive: false),
                            ),
                            _buildTabButton("Carte", isActive: true),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AgriSmartParcelleScreen()));
                              },
                              child: _buildTabButton("Parcelle", isActive: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: _currentLatLng,
                                    zoom: 16.0,
                                  ),
                                  mapType: MapType.satellite,
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                  zoomControlsEnabled: false,
                                  onMapCreated: (GoogleMapController controller) {
                                    _mapController = controller;
                                  },
                                ),
                              ),

                              // Boite météo - CORRIGÉE ICI
                              Positioned(
                                top: 10,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.blue, width: 1.5),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, // Correction syntaxique appliquée !
                                    children: [
                                      const Text("Bienvenue dans AgriGUARD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                      const SizedBox(height: 4),
                                      Text(_currentLocationName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                                      Text("Localisation active | 🌡️ Temp : ${_currentTemperature.toStringAsFixed(0)}°C", style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 15,
                                left: 50,
                                right: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    side: const BorderSide(color: Color(0xFF135800), width: 2),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  onPressed: () => _ouvrirMenuNouvelleParcelle(context),
                                  child: const Text("Nouvelle Parcelle", style: TextStyle(color: Color(0xFF135800), fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildBottomNavigation(context, selectedIndex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String text, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF135800) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black54,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}




// ==========================================
// 4. LES CAPTEURS IOT DE LA PARCELLE
// ==========================================
class AgriSmartParcelleScreen extends StatelessWidget {
  const AgriSmartParcelleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF135800),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
              );
            },
          ),
          title: const Text("Données IoT Parcelle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFDEE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: StreamBuilder<SensorData>(
              stream: obtenirFluxCapteursESP32(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF135800)));
                }
                
                final data = snapshot.data ?? SensorData(humiditeSol: 0, reservoirEau: 0, temperatureAir: 0, enLigne: false);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.enLigne ? "● SYSTÈME CONNECTÉ (ESP32)" : "○ SYSTÈME HORS LIGNE",
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: data.enLigne ? Colors.green : Colors.red),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildSensorCard("Humidité du Sol", "${data.humiditeSol.toStringAsFixed(0)} %", Icons.waves, Colors.blue)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildSensorCard("Niveau Réservoir", "${data.reservoirEau.toStringAsFixed(0)} L", Icons.opacity, Colors.teal)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(child: _buildSensorCard("Température Air", "${data.temperatureAir.toStringAsFixed(1)} °C", Icons.thermostat, Colors.orange)),
                          const SizedBox(width: 15),
                          Expanded(child: _buildSensorCard("Statut Système", data.enLigne ? "Actif" : "Erreur", Icons.wifi, data.enLigne ? Colors.green : Colors.grey)),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text("VUE D'ENSEMBLE DU CHAMP", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                        ),
                        child: const Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.grass, color: Color(0xFF135800)),
                              title: Text("Culture active : Rizière Alpha", style: TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text("Saison Principale - Croissance stable"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF135800),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const AgriSmartDetailsScreen()));
                        },
                        child: const Text("VOIR L'ANALYSE PATHOLOGIQUE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(context, selectedIndex: 0),
      ),
    );
  }

  Widget _buildSensorCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// ==========================================
// 5. NOUVELLE SAISON / FORMULAIRE
// ==========================================
class AgriSmartFormScreen extends StatefulWidget {
  const AgriSmartFormScreen({super.key});

  @override
  State<AgriSmartFormScreen> createState() => _AgriSmartFormScreenState();
}

class _AgriSmartFormScreenState extends State<AgriSmartFormScreen> {
  final TextEditingController _cultureController = TextEditingController();
  final TextEditingController _varieteController = TextEditingController();
  final TextEditingController _superficieController = TextEditingController();

  @override
  void dispose() {
    _cultureController.dispose();
    _varieteController.dispose();
    _superficieController.dispose();
    super.dispose();
  }

  void _validerEtEnregistrer() {
    if (_cultureController.text.trim().isEmpty || _varieteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez renseigner au moins la Culture et la Variété !"),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Nouvelle plantation '${_cultureController.text}' enregistrée avec succès !"),
          backgroundColor: const Color(0xFF135800),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Nouvelle plantation", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15),
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDEE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("AJOUTER UN NOUVEAU CHAMP", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                const SizedBox(height: 20),
                
                const Text("CULTURE ACTIVE", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                TextField(
                  controller: _cultureController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Riz, Pomme de terre, Maïs',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                const Text("VARIÉTÉ", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                TextField(
                  controller: _varieteController,
                  decoration: const InputDecoration(
                    hintText: 'Ex: Alpha, Variété locale Tsipala',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                const Text("SUPERFICIE (HA) / EMPLACEMENT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54)),
                TextField(
                  controller: _superficieController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Ex: 1.2',
                    hintStyle: TextStyle(color: Colors.black26, fontSize: 14),
                    border: UnderlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 40),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF135800),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: _validerEtEnregistrer,
                  child: const Text("ENREGISTRER LA PLANTE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. ÉTAT DE LA PARCELLE & RAPPORT IA
// ==========================================
class AgriSmartDetailsScreen extends StatelessWidget {
  const AgriSmartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Rapport de Diagnostic", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<ResultatAnalyseIA>(
          valueListenable: diagnosticIANotifier,
          builder: (context, resultat, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Parcelle : Zone Alpha", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                      Icon(
                        resultat.estMalade ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                        color: resultat.estMalade ? Colors.orange : Colors.greenAccent,
                        size: 30,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFDEE),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("STATUT DE LA PLANTE (IA)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                          const SizedBox(height: 10),
                          Text(
                            resultat.estMalade ? resultat.maladie : "Plante Saine / Aucun danger",
                            style: TextStyle(
                              fontSize: 22, 
                              fontWeight: FontWeight.bold, 
                              color: resultat.estMalade ? Colors.red[800] : Colors.green[800],
                            ),
                          ),
                          if (resultat.estMalade) ...[
                            Text("Indice de confiance : ${resultat.confiance.toStringAsFixed(1)}%", style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black45)),
                            const SizedBox(height: 20),

                            _buildReportSectionTitle("CAUSES DE LA PATHOLOGIE"),
                            _buildReportContentText("Le mildiou est causé par un micro-organisme oomycète (champignon parasitaire) qui se développe très rapidement lors de conditions climatiques humides et chaudes."),
                            
                            const SizedBox(height: 15),

                            _buildReportSectionTitle("CONSÉQUENCES SUR LA FERME"),
                            _buildReportContentText("Flétrissement accéléré des feuilles, apparition de taches brunes et destruction potentielle de la récolte si elle n'est pas traitée d'ici 48 heures. Réduction de 40% du rendement global."),
                            
                            const SizedBox(height: 15),

                            _buildReportSectionTitle("MÉTHODES DE PRÉVENTION & REMÈDES"),
                            _buildActionItem("• Espacer les plantations pour permettre une bonne ventilation."),
                            _buildActionItem("• Réduire l'irrigation en soirée pour limiter l'excès d'humidité foliaire."),
                            _buildActionItem("• Appliquer un traitement biologique préventif à base de cuivre."),
                          ] else ...[
                            const SizedBox(height: 30),
                            Center(
                              child: Column(
                                children: [
                                  Icon(Icons.gpp_good, size: 80, color: Colors.green[300]),
                                  const SizedBox(height: 15),
                                  const Text(
                                    "Les analyses TensorFlow Lite indiquent que vos cultures se portent bien.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 14, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          
                          const SizedBox(height: 35),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF135800),
                              minimumSize: const Size(double.infinity, 52),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const AgriSmartCameraScreen()));
                            },
                            icon: const Icon(Icons.camera_alt, color: Colors.white),
                            label: const Text("LANCER UN NOUVEAU SCAN PHOTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildReportSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
    );
  }

  Widget _buildReportContentText(String content) {
    return Text(content, style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.35));
  }

  Widget _buildActionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500)),
    );
  }
}

// ==========================================
// 7. SCANNER PHOTO IA
// ==========================================
class AgriSmartCameraScreen extends StatefulWidget {
  const AgriSmartCameraScreen({super.key});

  @override
  State<AgriSmartCameraScreen> createState() => _AgriSmartCameraScreenState();
}

class _AgriSmartCameraScreenState extends State<AgriSmartCameraScreen> {
  bool _enTrainDAnalyser = false;

  void _lancerAnalyseIA() async {
    setState(() {
      _enTrainDAnalyser = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    diagnosticIANotifier.value = ResultatAnalyseIA(
      maladie: "Mildiou (Phytophthora)",
      confiance: 87.5,
      estMalade: true,
    );

    listeActivitesNotifier.value = [
      {
        "date": "Aujourd'hui - À l'instant",
        "title": "Scan IA : Mildiou détecté",
        "description": "Feuille analysée avec succès. Alerte Mildiou confirmée à 87%.",
        "icon": Icons.warning_amber_rounded,
        "iconColor": Colors.orange,
      },
      ...listeActivitesNotifier.value,
    ];

    if (mounted) {
      setState(() {
        _enTrainDAnalyser = false;
      });
      
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Analyse TensorFlow Lite terminée !'),
          backgroundColor: Color(0xFF135800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1592417817098-8f3d6eb19675?q=80&w=1000',
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _enTrainDAnalyser ? Colors.orange : const Color(0xFF66BB46), 
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _enTrainDAnalyser 
                    ? const Center(child: CircularProgressIndicator(color: Colors.orange))
                    : const SizedBox(),
              ),
            ),

            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _enTrainDAnalyser 
                      ? "Analyse de la pathologie en cours par l'IA..." 
                      : "Cadrez la feuille malade dans le rectangle",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: _enTrainDAnalyser ? null : () => Navigator.pop(context),
                    ),
                  ),
                  
                  GestureDetector(
                    onTap: _enTrainDAnalyser ? null : _lancerAnalyseIA,
                    child: CircleAvatar(
                      backgroundColor: _enTrainDAnalyser ? Colors.grey : Colors.white,
                      radius: 35,
                      child: Icon(
                        _enTrainDAnalyser ? Icons.hourglass_top : Icons.camera, 
                        color: Colors.black, 
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 8. HISTORIQUE ET ACTIVITÉS DYNAMIQUE
// ==========================================
class AgriSmartActivityScreen extends StatelessWidget {
  const AgriSmartActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF135800),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
              );
            },
          ),
          title: const Text("Journal d'activité", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFDEE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: ValueListenableBuilder<List<Map<String, dynamic>>>(
              valueListenable: listeActivitesNotifier,
              builder: (context, activites, child) {
                return ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: activites.length,
                  itemBuilder: (context, index) {
                    final item = activites[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: (item['iconColor'] as Color).withOpacity(0.1),
                            radius: 22,
                            child: Icon(item['icon'] as IconData, color: item['iconColor'] as Color, size: 22),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['date'] as String,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black38),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['title'] as String,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item['description'] as String,
                                  style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(context, selectedIndex: 2),
      ),
    );
  }
}

// ==========================================
// 9. PROFIL UTILISATEUR
// ==========================================
class AgriSmartProfileScreen extends StatelessWidget {
  const AgriSmartProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF135800),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
              );
            },
          ),
          title: const Text("Mon Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Color(0xFF135800)),
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                "TAFIKINIAINA Nancy Romus",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const Text(
                "nancy.romus@example.com",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFFDEE),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("STATISTIQUES AGRICOLES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                        const SizedBox(height: 15),
                        _buildStatRow("Parcelles managées", "1 Active"),
                        _buildStatRow("Scans IA effectués", "${listeActivitesNotifier.value.length}"),
                        _buildStatRow("Statut du compte", "Premium"),
                        const SizedBox(height: 30),
                        const Divider(),
                        const SizedBox(height: 10),
                        Card(
                          color: Colors.red[50],
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text("Se déconnecter", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const AgriSmartLogin()),
                                (route) => false,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavigation(context, selectedIndex: 3),
      ),
    );
  }

  Widget _buildStatRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.analytics, color: Color(0xFF135800)),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black87)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF135800))),
        ],
      ),
    );
  }
}

// ==========================================
// COMPOSANTS RÉUTILISABLES & MODALES
// ==========================================

void _ouvrirMenuNouvelleParcelle(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFFFFFDEE),
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(10))),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AgriSmartFormScreen()));
              },
              child: const Text("Nouvelle plantation", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AgriSmartDetailsScreen()));
              },
              child: const Text("Plantation existante", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildBottomNavigation(BuildContext context, {required int selectedIndex}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 10),
    color: const Color(0xFFFFFDEE),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () {
            if (selectedIndex != 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartParcelleScreen()),
              );
            }
          },
          child: _buildNavIcon(Icons.storage, isSelected: selectedIndex == 0),
        ),
        GestureDetector(
          onTap: () {
            if (selectedIndex != 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
              );
            }
          },
          child: _buildNavIcon(Icons.cloud_queue, isSelected: selectedIndex == 1),
        ),
        GestureDetector(
          onTap: () {
            if (selectedIndex != 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartActivityScreen()),
              );
            }
          },
          child: _buildNavIcon(Icons.edit_note, isSelected: selectedIndex == 2),
        ),
        GestureDetector(
          onTap: () {
            if (selectedIndex != 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AgriSmartProfileScreen()),
              );
            }
          },
          child: _buildNavIcon(Icons.person_pin, isSelected: selectedIndex == 3),
        ),
      ],
    ),
  );
}

Widget _buildNavIcon(IconData icon, {bool isSelected = false}) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: isSelected ? const Color(0xFF135800) : Colors.transparent,
      shape: BoxShape.circle,
    ),
    child: Icon(
      icon,
      color: isSelected ? Colors.white : const Color(0xFF135800).withOpacity(0.6),
      size: 28,
    ),
  );
}

Stream<SensorData> obtenirFluxCapteursESP32() {
  return Stream.periodic(const Duration(seconds: 2), (count) {
    return SensorData(
      humiditeSol: 45.0 + (count % 5),
      reservoirEau: 80.0 - (count * 0.1),
      temperatureAir: 25.0 + (count % 2 == 0 ? 0.5 : -0.2),
      enLigne: true,
    );
  });
}