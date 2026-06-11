import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// La liste globale des activités qui va s'actualiser en temps réel
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Enlève la bande "Debug" en haut à droite
      home: AgriSmartLogin(),
    );
  }
}

class AgriSmartLogin extends StatelessWidget {
  const AgriSmartLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800), // Ton vert foncé de fond
      body: SafeArea(
        // Évite que le contenu touche l'encoche de la caméra
        child: SingleChildScrollView(
          // Permet de scroller si le clavier s'ouvre
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // 1. LE TITRE PRINCIPAL (Image 2)
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
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 30),

                // 2. LE BLOC BLANC/CRÈME (Formulaire)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDEE), // Ta couleur crème
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Champ Email
                      const Text(
                        "EMAIL / NOM D'UTILISATEUR",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const TextField(
                        decoration: InputDecoration(
                          hintText: 'Entrer votre email',
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 14),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Champ Mot de passe
                      const Text(
                        "MOTS DE PASSE",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      const TextField(
                        obscureText: true, // Cache le mot de passe (●●●●)
                        decoration: InputDecoration(
                          hintText: 'Entrer votre mots de passe',
                          hintStyle:
                              TextStyle(color: Colors.black26, fontSize: 14),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. CASE À COCHER "RESTER CONNECTÉ"
                Row(
                  children: [
                    Checkbox(
                      value: true, // Coché par défaut pour le style
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

                // 4. BOUTON "SE CONNECTER" (Vert vif)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB46), // Vert clair
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
  // Cette ligne magique change d'écran vers la carte !
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AgriSmartMapScreen()),
  );
},
                  child: const Text(
                    'SE CONNECTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
                const SizedBox(height: 25),

                // 5. SÉPARATEUR "OU"
                const Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white38, indent: 20, endIndent: 10)),
                    Text('Ou', style: TextStyle(color: Colors.white70)),
                    Expanded(child: Divider(color: Colors.white38, indent: 10, endIndent: 20)),
                  ],
                ),
                const SizedBox(height: 25),

                // 6. BOUTON GOOGLE
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB46),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.g_mobiledata,
                      color: Colors.white, size: 30),
                  label: const Text(
                    'continuer avec google',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 30),

                // 7. TEXTE DU BAS (Inscription)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas de compte ? ",
                        style: TextStyle(color: Colors.white60, fontSize: 12)),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Créer-en un gratuitement !",
                        style: TextStyle(
                            color: Color(0xFF66BB46),
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
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
// TRÈS IMPORTANT : TON DEUXIÈME ÉCRAN (IMAGE 3)
// ==========================================
class AgriSmartMapScreen extends StatelessWidget {
  const AgriSmartMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800), // Fond vert foncé pour le haut
      body: SafeArea(
        child: Column(
          children: [
            // 1. BARRE DU HAUT (Titre AgriGUARD)
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
                  const SizedBox(width: 40), // Juste pour équilibrer l'espace
                ],
              ),
            ),

            // 2. LE CONTENEUR PRINCIPAL BLANC (Qui englobe tout le reste)
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
                    // Les Onglets : Parcelle / Carte / Activité
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AgriSmartActivityScreen()),
                            );
                          },
                          child: _buildTabButton("activité", isActive: false),
                        ),
                            _buildTabButton("Carte", isActive: true),
                           GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgriSmartActivityScreen()),
                );
              },
              child: _buildTabButton("activité", isActive: false),
            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 3. LA ZONE DE LA CARTE SATELLITE
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            children: [
                              // En attendant d'installer Google Maps, on met une image ou une couleur
                              // Une vraie image satellite récupérée sur le web pour le design !
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: // À la place de l'image, on pose le vrai composant Google Maps !
                              GoogleMap(
                                initialCameraPosition: const CameraPosition(
                                  target: LatLng(-18.7994, 47.5614), // Coordonnées d'Ambodrabiby / Antananarivo !
                                  zoom: 16.0, // Niveau de zoom pour bien voir les champs
                                ),
                                mapType: MapType.satellite, // Mode SATELLITE comme sur tes maquettes !
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false, // Cache les boutons + et - laids de Google
                              ),
                            ),

                              // Boite d'infos météo (Bienvenue dans AgriGUARD)
                              Positioned(
                                top: 10,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.blue, width: 1.5),
                                  ),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Bienvenue dans AgriGUARD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      SizedBox(height: 4),
                                      Text("📍 Antananarivo, Ambodrabiby", style: TextStyle(fontSize: 10)),
                                      Text("🌡️ Temperature Locale : 25°C", style: TextStyle(fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ),

                              // Bouton "Nouvelle Parcelle" en bas de la carte
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
                                  onPressed: () {
  _ouvrirMenuNouvelleParcelle(context);
},
                                  child: const Text("Nouvelle Parcelle", style: TextStyle(color: Color(0xFF135800), fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 4. TA BARRE DE NAVIGATION EN BAS (Couleur Crème)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      color: const Color(0xFFFFFDEE),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
                _buildNavIcon(Icons.storage),
                _buildNavIcon(Icons.cloud_queue),
                _buildNavIcon(Icons.edit_note),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AgriSmartProfileScreen()),
                    );
                  },
                  child: _buildNavIcon(Icons.person_pin),
                ),
              ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Petit outil pour créer les boutons d'onglets du haut
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

  // Petit outil pour créer les icônes vertes du bas
  Widget _buildNavIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFF135800),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}


//creer la fonction magique du menu



// Cette fonction ouvre le volet coulissant depuis le bas (Image 11)
  void _ouvrirMenuNouvelleParcelle(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFFFDEE), // Ta couleur crème
      isScrollControlled: true, // Permet au menu de bien s'adapter à la taille
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)), // Bords arrondis en haut
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // S'adapte à la taille du contenu
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // La petite barre grise tout en haut du menu pour glisser
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Option 1 : Nouvelle plantation
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
  Navigator.pop(context); // 1. On ferme d'abord le volet coulissant du bas
  
  // 2. On ouvre le nouvel écran de formulaire !
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const AgriSmartFormScreen()),
  );
},
                child: const Text(
                  "Nouvelle plantation",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 12),

              // Option 2 : Plantation existante
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                Navigator.pop(context); // Ferme le volet du bas
                
                // Ouvre la page de diagnostic !
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AgriSmartDetailsScreen()),
                );
              },
                child: const Text(
                  "Plantation existante",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              const SizedBox(height: 12),

              // Bouton Annuler
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Annuler",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  //4 ème  page 

  // ==========================================
// TROISIÈME ÉCRAN : FORMULAIRE DE SAISON (IMAGE 6)
// ==========================================
class AgriSmartFormScreen extends StatelessWidget {
  const AgriSmartFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800), // Fond vert foncé
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Permet de revenir en arrière
        ),
        title: const Text("Nouvelle Saison", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Bloc formulaire Crème
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFDEE),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormFieldTitle("NOM DE LA SAISON"),
                      const TextField(decoration: InputDecoration(hintText: "Saison principale 2026")),
                      
                      const SizedBox(height: 20),
                      _buildFormFieldTitle("CULTURE"),
                      const TextField(decoration: InputDecoration(hintText: "Ex: Riz, Tomate...")),
                      
                      const SizedBox(height: 20),
                      _buildFormFieldTitle("DATE DE PLANTATION"),
                      const TextField(decoration: InputDecoration(hintText: "JJ / MM / AAAA")),
                      
                      const SizedBox(height: 20),
                      _buildFormFieldTitle("DATE DE RÉCOLTE PRÉVUE"),
                      const TextField(decoration: InputDecoration(hintText: "JJ / MM / AAAA")),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Bouton de validation vert clair
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB46),
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () {
                    // Ferme le formulaire et revient à la carte
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Saison enregistrée avec succès !')),
                    );
                  },
                  child: const Text("ENREGISTRER", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Petit outil pour le style des étiquettes du formulaire
  Widget _buildFormFieldTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black54),
    );
  }
}




// Nouveau design pour tes icônes du bas
  Widget _buildNavIcon(IconData icon, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF135800) : Colors.transparent, // Fond vert uniquement si sélectionné
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon, 
        color: isSelected ? Colors.white : const Color(0xFF135800).withOpacity(0.6), 
        size: 28
      ),
    );
  }



// ==========================================
// QUATRIÈME ÉCRAN : DIAGNOSTIC & SANTÉ (IMAGE 4 / 7)
// ==========================================
class AgriSmartDetailsScreen extends StatelessWidget {
  const AgriSmartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF135800), // Fond vert foncé
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("État de la Parcelle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. En-tête avec résumé rapide
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Parcelle : Zone Alpha",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.check_circle, color: Color(0xFF66BB46), size: 30), // Icône santé OK
                ],
              ),
            ),

            // 2. Grand panneau Crème pour les détails
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: const Color(0xFFFFFDEE), // Couleur crème
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ANALYSE DE PATHOLOGIE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 15),

                      // Bloc Alerte / Maladie détectée (Simulé comme sur tes rapports)
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.orange[100],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 30),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Attention détectée", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                  Text("Symptômes légers de mildiou sur les feuilles inférieures.", style: TextStyle(fontSize: 12, color: Colors.black)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),

                      // Section Recommandations
                      const Text("ACTIONS RECOMMANDÉES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                      const SizedBox(height: 10),
                      _buildActionItem("1. Réduire l'irrigation en soirée pour limiter l'humidité."),
                      _buildActionItem("2. Appliquer un traitement biologique préventif."),
                      _buildActionItem("3. Inspecter la zone Sud-Est d'ici 48 heures."),
                      
                      const SizedBox(height: 40),

                      // Bouton pour lancer un nouveau scan IA (TensorFlow Lite)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF135800),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                       onPressed: () {
                      // Ouvre l'interface de l'appareil photo
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AgriSmartCameraScreen()),
                      );
                    },
                        icon: const Icon(Icons.camera_alt, color: Colors.white),
                        label: const Text("LANCER UN SCAN PHOTO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Petit outil pour afficher les lignes d'action
  Widget _buildActionItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
      ),
    );
  }
}





// ==========================================
// CINQUIÈME ÉCRAN : SCANNER PHOTO IA (SIMULATION)
// ==========================================
class AgriSmartCameraScreen extends StatelessWidget {
  const AgriSmartCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fond noir pour simuler l'appareil photo
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Fond : On simule le viseur de la caméra avec une image de feuille malade
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.network(
                'https://images.unsplash.com/photo-1592417817098-8f3d6eb19675?q=80&w=1000', // Image de feuille en gros plan
                fit: BoxFit.cover,
              ),
            ),

            // 2. Overlay de ciblage (Le rectangle de focus de l'IA)
            Center(
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF66BB46), width: 3), // Cadre vert
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            // 3. Texte indicatif en haut
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
                child: const Text(
                  "Cadrez la feuille malade dans le rectangle",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),

            // 4. Barre d'action en bas (Bouton retour et bouton de capture)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Bouton Retour
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    radius: 25,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  // Gros bouton de capture blanc
                  // Gros bouton de capture blanc mis à jour
                  GestureDetector(
                    onTap: () {
                      // 1. On ajoute dynamiquement la détection IA en haut de la liste
                      listeActivitesNotifier.value = [
                        {
                          "date": "Aujourd'hui - À l'instant",
                          "title": "Scan IA : Mildiou détecté",
                          "description": "Feuille de tomate analysée. Alerte Mildiou confirmée à 87%. Traitement requis.",
                          "icon": Icons.warning_amber_rounded,
                          "iconColor": Colors.orange,
                        },
                        ...listeActivitesNotifier.value, // On garde les anciennes activités en dessous
                      ];

                      // 2. On ferme l'appareil photo
                      Navigator.pop(context);

                      // 3. Petite notification de confirmation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Analyse terminée ! Journal mis à jour.'),
                          backgroundColor: Color(0xFF135800),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: Icon(Icons.camera, color: Colors.black, size: 30),
                      ),
                    ),
                  ),
                  
                  // Espace vide pour équilibrer le Row
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
// SIXIÈME ÉCRAN : HISTORIQUE ET ACTIVITÉS DYNAMIQUE
// ==========================================
class AgriSmartActivityScreen extends StatelessWidget {
  const AgriSmartActivityScreen({super.key});

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
        title: const Text("Journal d'Activité", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 15),
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFFFFFDEE),
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: ValueListenableBuilder<List<Map<String, dynamic>>>(
            valueListenable: listeActivitesNotifier,
            builder: (context, activites, child) {
              return ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: activites.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                      child: Text(
                        "SUIVI DES DERNIÈRES ACTIONS",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    );
                  }
                  
                  final item = activites[index - 1];
                  return _buildTimelineItem(
                    date: item["date"],
                    title: item["title"],
                    description: item["description"],
                    icon: item["icon"],
                    iconColor: item["iconColor"],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String date,
    required String title,
    required String description,
    required IconData icon,
    required Color iconColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              backgroundColor: iconColor.withOpacity(0.15),
              radius: 20,
              child: Icon(icon, color: iconColor, size: 20),
            ),
            Container(
              width: 2,
              height: 60,
              color: Colors.grey[300],
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.3)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}

// ==========================================
// SEPTIÈME ÉCRAN : PROFIL UTILISATEUR
// ==========================================
class AgriSmartProfileScreen extends StatelessWidget {
  const AgriSmartProfileScreen({super.key});

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
        title: const Text("Mon Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFFFFDEE),
              child: Icon(Icons.person, size: 60, color: Color(0xFF135800)),
            ),
            const SizedBox(height: 15),
            const Text(
              "Nom d'utilisateur:id",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Text(
              "ID:etiquette de travaille",
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFDEE),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    const Text("STATISTIQUES DE LA FERME", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
                    const SizedBox(height: 10),
                    _buildStatRow("Parcelles totales", "id parecelle entrer"),
                    _buildStatRow("Alertes résolues", "id analyse ia"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Divider(),
                    ),
                    const Text("COMPTE & SÉCURITÉ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
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
          ],
        ),
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

