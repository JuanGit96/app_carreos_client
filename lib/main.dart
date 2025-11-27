// IMPORTANTE: Lee los comentarios. He explicado cada decisión de diseño y lógica.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:async'; // Necesario para simular tiempos de espera (Timer/Future)

// ---------------------------------------------------------------------------
// 1. CONFIGURACIÓN Y TEMA (BRANDING)
// ---------------------------------------------------------------------------
// Definimos los colores de tu marca aquí para usarlos en toda la app.
class AppColors {
  static const Color orange = Color(0xFFFF6B35); // Tu naranja vibrante
  static const Color blue = Color(0xFF0F2537);   // Tu azul oscuro corporativo
  static const Color background = Color(0xFFF3F4F6); // Gris claro de fondo
  static const Color text = Color(0xFF1F2937);
}

// Punto de entrada principal de Flutter
void main() {
  runApp(const AppCarreosClient());
}

class AppCarreosClient extends StatelessWidget {
  const AppCarreosClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppCarreos Usuario',
      debugShowCheckedModeBanner: false, // Quitamos la etiqueta "Debug"
      theme: ThemeData(
        // Configuramos Google Fonts globalmente
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: AppColors.orange,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        // Personalizamos los botones elevados por defecto
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      // Iniciamos en la pantalla de Login
      home: const LoginScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// 2. PANTALLA DE LOGIN (Simulada)
// ---------------------------------------------------------------------------
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue, // Fondo azul para impacto visual
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo simulado con Icono
              const Icon(FontAwesomeIcons.truckFast, size: 80, color: AppColors.orange),
              const SizedBox(height: 20),
              Text(
                "AppCarreos",
                style: GoogleFonts.montserrat(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tu carga segura y a tiempo",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 60),

              // Campo de texto dummy
              _buildInput("Email", FontAwesomeIcons.envelope),
              const SizedBox(height: 20),
              _buildInput("Contraseña", FontAwesomeIcons.lock, isPassword: true),

              const SizedBox(height: 40),

              // Botón de acción principal
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // NAVEGACIÓN: PushReplacement destruye la pantalla de login
                    // para que el usuario no pueda volver atrás con el botón 'back'.
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  },
                  child: const Text("INICIAR SESIÓN", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper para no repetir código en los inputs
  Widget _buildInput(String hint, IconData icon, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
          prefixIcon: Icon(icon, color: AppColors.orange),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. HOME SCREEN (Dashboard del Usuario)
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Hola, Alejandro 👋", style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.bell, color: AppColors.blue),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner promocional
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.blue, Color(0xFF1a3c5a)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("¿Compraste algo grande?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 5),
                        Text("Escanea tu factura y pide tu acarreo ya.", style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(FontAwesomeIcons.camera, color: Colors.white),
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("¿Qué deseas mover hoy?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.blue)),
            const SizedBox(height: 20),

            // Grid de opciones
            Row(
              children: [
                _buildOptionCard(context, "Escanear\nFactura", FontAwesomeIcons.fileInvoice, true),
                const SizedBox(width: 15),
                _buildOptionCard(context, "Foto a\nObjetos", FontAwesomeIcons.camera, false),
                const SizedBox(width: 15),
                _buildOptionCard(context, "Ingreso\nManual", FontAwesomeIcons.keyboard, false),
              ],
            ),

            const SizedBox(height: 30),
            const Text("Actividad Reciente", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.blue)),
            const SizedBox(height: 15),

            // Lista dummy de historial
            _buildHistoryItem("Mueble TV a Cedritos", "Completado", "Hace 2 días"),
            _buildHistoryItem("Nevera a Soacha", "Completado", "Hace 1 semana"),
          ],
        ),
      ),
      // Barra de navegación inferior dummy
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.boxOpen), label: "Mis Envíos"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Perfil"),
        ],
      ),
    );
  }

  Widget _buildOptionCard(BuildContext context, String title, IconData icon, bool isPrimary) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Si tocan cualquier opción, vamos al flujo de pedir servicio
          // Aquí simulamos que van a la "Cámara IA"
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AiScannerScreen()));
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            color: isPrimary ? AppColors.orange : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: isPrimary ? Colors.white : AppColors.blue),
              const SizedBox(height: 10),
              Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: isPrimary ? Colors.white : AppColors.text,
                      fontWeight: FontWeight.bold
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String status, String date) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
            child: const Icon(FontAwesomeIcons.box, color: AppColors.blue, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(status, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. ESCÁNER IA (Simulación)
// ---------------------------------------------------------------------------
// StatefulWidget necesario porque la pantalla cambia (Analizando -> Resultado)
class AiScannerScreen extends StatefulWidget {
  const AiScannerScreen({super.key});

  @override
  State<AiScannerScreen> createState() => _AiScannerScreenState();
}

class _AiScannerScreenState extends State<AiScannerScreen> {
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    // Simulamos el proceso de escaneo automático al entrar
    _startSimulation();
  }

  void _startSimulation() async {
    setState(() => _isAnalyzing = true);
    await Future.delayed(const Duration(seconds: 3)); // Espera 3 segundos
    if (mounted) {
      // Navega a resultados
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VehicleSelectionScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Imagen de fondo (Simula la cámara)
          // Usamos un container gris por si no hay imagen
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[800],
            child: const Center(
              child: Icon(FontAwesomeIcons.image, color: Colors.white24, size: 100),
            ),
          ),

          // 2. Overlay de escaneo (La línea verde que sube y baja)
          // Nota: En una app real usaríamos animaciones, aquí es estático por simplicidad
          Center(
            child: Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.orange, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isAnalyzing)
                    const CircularProgressIndicator(color: AppColors.orange),
                  const SizedBox(height: 20),
                  Text(
                    _isAnalyzing ? "Analizando Factura..." : "Enfoca la factura",
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),

          // 3. Botón cerrar
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. SELECCIÓN DE VEHÍCULO
// ---------------------------------------------------------------------------
class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int _selectedVehicleIndex = -1; // -1 significa ninguno seleccionado

  // Datos dummy de vehículos
  final List<Map<String, dynamic>> vehicles = [
    {
      "name": "Van Pequeña",
      "desc": "Ideal para 2-3 muebles",
      "price": 45000,
      "time": "5 min",
      "icon": FontAwesomeIcons.shuttleVan,
      "recommendation": "RECOMENDADO POR IA" // Etiqueta especial
    },
    {
      "name": "Camioneta Estacas",
      "desc": "Cargas altas y neveras",
      "price": 65000,
      "time": "12 min",
      "icon": FontAwesomeIcons.truckPickup,
      "recommendation": null
    },
    {
      "name": "Furgón Mediano",
      "desc": "Mudanza apartaestudio",
      "price": 120000,
      "time": "20 min",
      "icon": FontAwesomeIcons.truck,
      "recommendation": null
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Selecciona tu Vehículo")),
      body: Column(
        children: [
          // Resumen de lo detectado
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.green.withOpacity(0.1),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 10),
                Expanded(child: Text("Detectamos: 1x Mesa TV, 2x Sillas de Barra. Peso est: 25kg")),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                final isSelected = _selectedVehicleIndex == index;

                return GestureDetector(
                  onTap: () => setState(() => _selectedVehicleIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: isSelected ? AppColors.orange : Colors.transparent,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
                    ),
                    child: Row(
                      children: [
                        // Icono del vehículo
                        Container(
                          width: 60, height: 60,
                          decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Icon(vehicle['icon'], color: AppColors.blue, size: 30),
                        ),
                        const SizedBox(width: 15),
                        // Detalles
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (vehicle['recommendation'] != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(color: AppColors.orange, borderRadius: BorderRadius.circular(4)),
                                  child: Text(vehicle['recommendation'], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ),
                              Text(vehicle['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(vehicle['desc'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                        // Precio
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(NumberFormat.currency(symbol: '\$', decimalDigits: 0).format(vehicle['price']), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(vehicle['time'], style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Panel inferior de confirmación
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))]
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Método de Pago"),
                    Row(
                      children: const [
                        Icon(FontAwesomeIcons.ccVisa, size: 20),
                        SizedBox(width: 5),
                        Text("**** 4242"),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // Solo habilitamos el botón si hay selección
                    onPressed: _selectedVehicleIndex == -1 ? null : () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackingScreen()));
                    },
                    child: const Text("PEDIR ACARREO", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. TRACKING SCREEN (Seguimiento)
// ---------------------------------------------------------------------------
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Mapa Dummy (Fondo)
          Container(
            color: Colors.grey[300],
            child: const Center(child: Text("MAPA GOOGLE MAPS", style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold))),
          ),

          // 2. Ruta Dummy (Línea)
          Center(child: Container(width: 200, height: 2, color: AppColors.orange)),

          // 3. Tarjeta de estado inferior
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barra de "agarrar"
                  Container(width: 40, height: 4, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20)),

                  // Tiempo
                  const Text("Llegada en 12 min", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("El conductor va hacia el punto de recogida", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Info Conductor
                  Row(
                    children: [
                      const CircleAvatar(backgroundColor: AppColors.background, radius: 25, child: Icon(FontAwesomeIcons.user, color: AppColors.blue)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Carlos Rodríguez", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Chevrolet N300 • Furgón", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          Icon(Icons.star, color: Colors.amber),
                          Text("4.9", style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botones de acción
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone),
                          label: const Text("Llamar"),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.message),
                          label: const Text("Chat"),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
