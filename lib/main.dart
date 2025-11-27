// ---------------------------------------------------------------------------
// APP CLIENTE (USUARIO) - VERSIÓN MAESTRA FINAL
// ---------------------------------------------------------------------------
// OBJETIVO DIDÁCTICO:
// Este archivo demuestra un flujo completo de una app de logística (tipo Uber/Rappi).
// Incluye: Navegación, Gestión de Estado (setState), Modales, Listas y Formularios.

import 'package:flutter/material.dart'; // Librería core de Flutter (Material Design)
import 'package:google_fonts/google_fonts.dart'; // Librería para fuentes modernas
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Iconos vectoriales pro
import 'package:intl/intl.dart'; // Librería para formatos de fecha y moneda
import 'dart:async'; // Librería para funciones asíncronas (Timers)

// ---------------------------------------------------------------------------
// 1. CONFIGURACIÓN GLOBAL DE COLORES Y ESTILOS
// ---------------------------------------------------------------------------
class AppColors {
  static const Color orange = Color(0xFFFF6B35); // Color de énfasis (Botones, Iconos activos)
  static const Color blue = Color(0xFF0F2537);   // Color corporativo (Fondos oscuros, Textos principales)
  static const Color background = Color(0xFFF8F9FA); // Fondo gris muy claro para la app
  static const Color text = Color(0xFF1F2937);   // Color de texto estándar
  static const Color green = Color(0xFF10B981);  // Color para estados de éxito o dinero
}

// Función principal que arranca la aplicación
void main() {
  runApp(const AppCarreosClient());
}

// Widget Raíz (Root): Configura el tema global y la ruta inicial.
class AppCarreosClient extends StatelessWidget {
  const AppCarreosClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppCarreos Usuario',
      debugShowCheckedModeBanner: false, // Oculta la cinta roja de "Debug"
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // Aplica fuente Poppins globalmente
        primaryColor: AppColors.orange,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        // Estilo global para los campos de texto (Inputs)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        // Estilo global para botones principales
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white, // Color del texto del botón
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      home: const AuthScreen(), // Pantalla inicial: Login/Registro
    );
  }
}

// ---------------------------------------------------------------------------
// 2. AUTENTICACIÓN (LOGIN / REGISTRO)
// ---------------------------------------------------------------------------
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Estado local para alternar entre vista de Login y Registro
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue, // Fondo corporativo
      body: SafeArea( // Evita que el contenido choque con la barra de notificaciones
        child: SingleChildScrollView( // Permite scroll en pantallas pequeñas
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(FontAwesomeIcons.truckFast, size: 60, color: AppColors.orange),
              const SizedBox(height: 15),
              Text("AppCarreos", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 40),

              // Switch personalizado (Tabs)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(50)),
                child: Row(
                  children: [
                    _buildTab("Iniciar Sesión", true),
                    _buildTab("Registrarse", false),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Formulario condicional
              if (!_isLogin) ...[
                _buildInput("Nombre Completo", FontAwesomeIcons.user),
                const SizedBox(height: 15),
                _buildInput("Celular", FontAwesomeIcons.phone),
                const SizedBox(height: 15),
              ],
              _buildInput("Correo Electrónico", FontAwesomeIcons.envelope),
              const SizedBox(height: 15),
              _buildInput("Contraseña", FontAwesomeIcons.lock, isPassword: true),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // PushReplacement elimina la pantalla de login del historial para que no puedan volver atrás
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainNavigationScreen()));
                  },
                  child: Text(_isLogin ? "INGRESAR" : "CREAR CUENTA"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construye cada pestaña del switch superior
  Widget _buildTab(String text, bool isLoginTab) {
    final bool isSelected = _isLogin == isLoginTab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isLogin = isLoginTab), // setState redibuja la UI
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: isSelected ? Colors.white : Colors.white60, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: AppColors.orange, size: 18),
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 3. NAVEGACIÓN PRINCIPAL (BOTTOM NAVIGATION BAR)
// ---------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Controla qué pestaña está activa

  // Lista de Pantallas disponibles en la barra inferior
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyShipmentsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla según el índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.boxOpen), label: "Mis Envíos"),
          BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Perfil"),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. HOME SCREEN (INICIO)
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Muestra un modal inferior para cambiar la dirección rápidamente
  void _showLocationPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Cambiar Ubicación de Recogida", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.my_location, color: AppColors.blue),
                title: const Text("Usar ubicación actual"),
                subtitle: const Text("Calle 122 # 15-45"),
                trailing: const Icon(Icons.check, color: AppColors.green),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.grey),
                title: const Text("Casa"),
                subtitle: const Text("Calle 140 # 11-20"),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER INTERACTIVO: Ubicación
              GestureDetector(
                onTap: () => _showLocationPicker(context),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Recoger en", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          Row(
                            children: const [
                              Text("Calle 122 # 15-45", style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
                              Icon(Icons.keyboard_arrow_down, color: AppColors.orange)
                            ],
                          ),
                        ],
                      ),
                      const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: AppColors.blue))
                    ],
                  ),
                ),
              ),

              // BARRA DE BÚSQUEDA (Trigger del flujo principal)
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressSelectionScreen())),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Row(
                    children: [
                      const Icon(FontAwesomeIcons.magnifyingGlass, color: AppColors.blue, size: 24),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("¿A dónde envías?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text("Ingresa el destino de la carga", style: TextStyle(color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text("Destinos Recientes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.blue)),
              ),
              const SizedBox(height: 10),

              // Lista horizontal de destinos recientes
              SizedBox(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _recentPlaceCard(context, "Casa Mamá", "Cedritos"),
                    _recentPlaceCard(context, "Oficina", "Chapinero"),
                    _recentPlaceCard(context, "Bodega", "Zona Ind."),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Banner Promocional
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.blue, Color(0xFF1a3c5a)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Pide un acarreo ya", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 5),
                          Text("Conductores verificados listos para ayudarte.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Icon(FontAwesomeIcons.truckRampBox, color: Colors.white, size: 40)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recentPlaceCard(BuildContext context, String title, String subtitle) {
    return GestureDetector(
      onTap: () {
        // Al tocar un reciente, saltamos directo al input de carga
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ruta seleccionada: $title")));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CargoInputScreen()));
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, color: AppColors.orange),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 5. FLUJO DE SOLICITUD (PASOS 1, 2)
// ---------------------------------------------------------------------------

// PASO 1: DIRECCIÓN
class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ruta del Servicio"), elevation: 0),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                _addressField(Icons.circle, Colors.green, "Recogida", "Calle 122 # 15-45 (Actual)"),
                const Divider(height: 20),
                _addressField(Icons.location_on, AppColors.orange, "Destino", "¿A dónde vamos?"),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.map, size: 100, color: Colors.black12)),
                  Positioned(
                    bottom: 30, left: 20, right: 20,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CargoInputScreen())),
                      child: const Text("CONFIRMAR RUTA"),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _addressField(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        )
      ],
    );
  }
}

// PASO 2: CARGA
class CargoInputScreen extends StatefulWidget {
  const CargoInputScreen({super.key});
  @override
  State<CargoInputScreen> createState() => _CargoInputScreenState();
}

class _CargoInputScreenState extends State<CargoInputScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("¿Qué llevas?"),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.orange,
          indicatorColor: AppColors.orange,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(icon: Icon(FontAwesomeIcons.fileInvoice), text: "Factura"),
            Tab(icon: Icon(FontAwesomeIcons.camera), text: "Fotos"),
            Tab(icon: Icon(FontAwesomeIcons.penToSquare), text: "Manual"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlaceholderTab("Escanea tu factura", "Detectamos los ítems automáticamente", Icons.qr_code_scanner),
          _buildPlaceholderTab("Toma fotos a la carga", "La IA calcula el volumen necesario", Icons.camera_alt),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(hintText: "Describe tu carga (ej. Nevera, cama doble, 4 cajas...)"),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.mic, color: AppColors.orange),
                  title: const Text("Grabar nota de audio"),
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  onTap: () {},
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingConfigScreen())),
                    child: const Text("CONTINUAR"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, String subtitle, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingConfigScreen())),
          child: const Text("ABRIR CÁMARA"),
        )
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 6. PASO 3: CONFIGURACIÓN Y CONFIRMACIÓN
// ---------------------------------------------------------------------------
class BookingConfigScreen extends StatefulWidget {
  const BookingConfigScreen({super.key});
  @override
  State<BookingConfigScreen> createState() => _BookingConfigScreenState();
}

class _BookingConfigScreenState extends State<BookingConfigScreen> {
  bool _isImmediate = true;
  int _selectedVehicle = 0;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Variables para el método de pago seleccionado
  String _paymentMethodName = "Visa **** 4242";
  IconData _paymentMethodIcon = FontAwesomeIcons.ccVisa;

  // Funciones de selección de Fecha y Hora
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(data: ThemeData.light().copyWith(primaryColor: AppColors.orange, colorScheme: const ColorScheme.light(primary: AppColors.orange)), child: child!);
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.light().copyWith(primaryColor: AppColors.orange, colorScheme: const ColorScheme.light(primary: AppColors.orange)), child: child!);
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  // Función para abrir la pantalla de selección de método de pago y esperar el resultado
  Future<void> _changePaymentMethod() async {
    // Navigator.push puede retornar un valor si la pantalla siguiente usa Navigator.pop(context, valor)
    final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaymentMethodsScreen(isSelectionMode: true))
    );

    // Si recibimos un resultado (el usuario seleccionó algo), actualizamos el estado
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _paymentMethodName = result['name'];
        _paymentMethodIcon = result['icon'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Servicio")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Tu Ruta", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: const [
              Icon(Icons.circle, size: 12, color: Colors.green), SizedBox(width: 8), Text("Calle 122 # 15-45"),
              SizedBox(width: 15), Icon(Icons.arrow_forward, size: 12, color: Colors.grey), SizedBox(width: 15),
              Icon(Icons.location_on, size: 12, color: AppColors.orange), SizedBox(width: 8), Text("Cra 7 # 72-10"),
            ]),
            const Divider(height: 30),

            // Selector de Tiempo
            const Text("¿Cuándo?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  _timeOption("Ahora mismo", true),
                  _timeOption("Programar", false),
                ],
              ),
            ),

            // Selector de Fecha/Hora si es programado
            if (!_isImmediate) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Column(
                  children: [
                    ListTile(onTap: _pickDate, leading: const Icon(Icons.calendar_month, color: AppColors.orange), title: Text(_selectedDate == null ? "Seleccionar Fecha" : DateFormat('EEE, d MMM').format(_selectedDate!)), trailing: const Icon(Icons.arrow_forward_ios, size: 14)),
                    const Divider(),
                    ListTile(onTap: _pickTime, leading: const Icon(Icons.access_time, color: AppColors.blue), title: Text(_selectedTime == null ? "Seleccionar Hora" : _selectedTime!.format(context)), trailing: const Icon(Icons.arrow_forward_ios, size: 14)),
                  ],
                ),
              )
            ],

            const SizedBox(height: 20),

            // Selector Vehículo
            const Text("Vehículo Sugerido", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _vehicleOption(0, "Van Pequeña", "45.000", FontAwesomeIcons.shuttleVan),
            _vehicleOption(1, "Estacas", "65.000", FontAwesomeIcons.truckPickup),

            const SizedBox(height: 20),

            // SELECCIÓN DE PAGO (Interactiva)
            const Text("Método de Pago", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                leading: Icon(_paymentMethodIcon, color: AppColors.blue, size: 28),
                title: Text(_paymentMethodName, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: TextButton(
                    onPressed: _changePaymentMethod,
                    child: const Text("Cambiar", style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold))
                ),
              ),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (!_isImmediate && (_selectedDate == null || _selectedTime == null)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor selecciona fecha y hora")));
                    return;
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const FindingDriverScreen()));
                },
                child: Text(_isImmediate ? "SOLICITAR AHORA" : "AGENDAR SERVICIO"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _timeOption(String text, bool isImmediateOption) {
    bool selected = _isImmediate == isImmediateOption;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isImmediate = isImmediateOption),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: selected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(8), boxShadow: selected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  Widget _vehicleOption(int index, String name, String price, IconData icon) {
    bool selected = _selectedVehicle == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, border: Border.all(color: selected ? AppColors.orange : Colors.transparent, width: 2), borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.blue),
            const SizedBox(width: 15),
            Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold))),
            Text("\$ $price", style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. PANTALLAS DE PROCESO (BUSCANDO Y TRACKING)
// ---------------------------------------------------------------------------

class FindingDriverScreen extends StatefulWidget {
  const FindingDriverScreen({super.key});
  @override
  State<FindingDriverScreen> createState() => _FindingDriverScreenState();
}

class _FindingDriverScreenState extends State<FindingDriverScreen> {
  @override
  void initState() {
    super.initState();
    // Simula 3 segundos de búsqueda antes de encontrar conductor
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const TrackingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: AppColors.orange),
            SizedBox(height: 20),
            Text("Conectando con conductores...", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Estamos buscando el vehículo ideal", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparente para permitir navegación de regreso al HOME sin cancelar
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            // popUntil: Regresa hasta la primera ruta (Home) simulando minimizar el viaje
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: Text("GOOGLE MAPS VIEW", style: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold))),
          ),
          Center(child: Container(width: 200, height: 4, color: AppColors.orange)),
          Positioned(
            top: 100, right: 20,
            child: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: Icon(Icons.sos, color: Colors.white)),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(width: 40, height: 4, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20)),
                  const Text("Llegada en 8 min", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Conductor en camino a recogida", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const CircleAvatar(radius: 25, backgroundColor: AppColors.background, child: Icon(Icons.person, color: AppColors.blue)),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Carlos R.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("Chevrolet N300 • FNK-123", style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      Column(
                        children: const [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          Text("4.9", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: OutlinedButton.icon(onPressed: (){}, icon: const Icon(Icons.phone), label: const Text("Llamar"))),
                      const SizedBox(width: 15),
                      Expanded(child: ElevatedButton.icon(onPressed: (){}, icon: const Icon(Icons.message), label: const Text("Chat"))),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    child: const Text("Cancelar Servicio", style: TextStyle(color: Colors.red)),
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

// ---------------------------------------------------------------------------
// 8. PERFIL Y CONFIGURACIONES
// ---------------------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mi Perfil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=12")),
            const SizedBox(height: 15),
            const Text("Maria Gonzalez", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("maria@email.com", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            _menuItem(context, "Métodos de Pago", FontAwesomeIcons.creditCard, const PaymentMethodsScreen(isSelectionMode: false)),
            _menuItem(context, "Direcciones Guardadas", FontAwesomeIcons.mapLocation, const SavedAddressesScreen()),
            _menuItem(context, "Centro de Ayuda", FontAwesomeIcons.headset, const HelpScreen()),
            _menuItem(context, "Configuración", FontAwesomeIcons.gear, const SettingsScreen()),

            const SizedBox(height: 20),
            ListTile(
              leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.logout, color: Colors.red, size: 18)),
              title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen())),
            )
          ],
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext context, String title, IconData icon, Widget targetScreen) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen)),
      leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: AppColors.text, size: 18)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. GESTIÓN DE PAGOS Y DIRECCIONES
// ---------------------------------------------------------------------------

// Pantalla Dual: Sirve para gestionar tarjetas (Perfil) y para seleccionar (Booking)
class PaymentMethodsScreen extends StatelessWidget {
  final bool isSelectionMode;
  const PaymentMethodsScreen({super.key, required this.isSelectionMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isSelectionMode ? "Seleccionar Método" : "Métodos de Pago")),
      body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Opción Efectivo
            _paymentOption(context, "Efectivo", FontAwesomeIcons.moneyBill, isSelectionMode),
            const SizedBox(height: 15),
            // Tarjetas guardadas
            _paymentOption(context, "Visa **** 4242", FontAwesomeIcons.ccVisa, isSelectionMode),
            _paymentOption(context, "Mastercard **** 9988", FontAwesomeIcons.ccMastercard, isSelectionMode),

            const SizedBox(height: 20),
            // Botón agregar
            OutlinedButton.icon(
                onPressed: (){
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Funcionalidad para agregar tarjeta")));
                },
                icon: const Icon(Icons.add),
                label: const Text("Agregar Nueva Tarjeta")
            )
          ]
      ),
    );
  }

  Widget _paymentOption(BuildContext context, String name, IconData icon, bool selectable) {
    return GestureDetector(
      onTap: () {
        if (selectable) {
          // Si estamos seleccionando, devolvemos los datos a la pantalla anterior
          Navigator.pop(context, {'name': name, 'icon': icon});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.blue),
            const SizedBox(width: 15),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Spacer(),
            if (selectable) const Icon(Icons.touch_app, color: AppColors.orange, size: 20)
          ],
        ),
      ),
    );
  }
}

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Direcciones")),
      body: ListView(children: const [
        ListTile(leading: Icon(Icons.home), title: Text("Casa"), subtitle: Text("Calle 122 # 15-45")),
        ListTile(leading: Icon(Icons.work), title: Text("Oficina"), subtitle: Text("Cra 7 # 72-10")),
      ]),
      floatingActionButton: FloatingActionButton(onPressed: (){}, backgroundColor: AppColors.orange, child: const Icon(Icons.add, color: Colors.white)),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. AYUDA Y CONFIGURACIÓN (INTERACTIVO)
// ---------------------------------------------------------------------------

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _currentLanguage = "Español";

  // Modal para cambiar idioma
  void _showLanguageDialog() {
    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: const Text("Seleccionar Idioma"),
          children: [
            SimpleDialogOption(onPressed: () { setState(() => _currentLanguage = "Español"); Navigator.pop(context); }, child: const Text("Español")),
            SimpleDialogOption(onPressed: () { setState(() => _currentLanguage = "English"); Navigator.pop(context); }, child: const Text("English")),
            SimpleDialogOption(onPressed: () { setState(() => _currentLanguage = "Português"); Navigator.pop(context); }, child: const Text("Português")),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: ListView(children: [
        ListTile(title: const Text("Notificaciones Push"), trailing: const Icon(Icons.toggle_on, color: Colors.green, size: 30)),
        ListTile(
          title: const Text("Idioma"),
          trailing: Text("$_currentLanguage >", style: const TextStyle(color: Colors.grey)),
          onTap: _showLanguageDialog, // Abre el modal
        ),
        ListTile(title: const Text("Eliminar Cuenta"), textColor: Colors.red, onTap: (){}),
      ]),
    );
  }
}

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Centro de Ayuda")),
      body: ListView(children: [
        ListTile(
          title: const Text("Reportar un problema"),
          leading: const Icon(Icons.report_problem, color: Colors.orange),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportProblemScreen())),
        ),
        ListTile(
          title: const Text("Preguntas Frecuentes"),
          leading: const Icon(Icons.question_answer, color: AppColors.blue),
          trailing: const Icon(Icons.arrow_forward_ios, size: 14),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FAQScreen())),
        ),
      ]),
    );
  }
}

class ReportProblemScreen extends StatelessWidget {
  const ReportProblemScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reportar Problema")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Cuéntanos qué sucedió con tu servicio", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const TextField(maxLines: 5, decoration: InputDecoration(hintText: "Describe aquí el incidente...", alignLabelWithHint: true)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reporte enviado.")));
                  Navigator.pop(context);
                },
                child: const Text("ENVIAR REPORTE"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Preguntas Frecuentes")),
      body: ListView(
        children: const [
          ExpansionTile(title: Text("¿Mi carga está asegurada?"), children: [Padding(padding: EdgeInsets.all(15.0), child: Text("Sí, todos los envíos realizados a través de la app cuentan con una póliza básica."))]),
          ExpansionTile(title: Text("¿Cómo calculan la tarifa?"), children: [Padding(padding: EdgeInsets.all(15.0), child: Text("Basado en km, tiempo y tipo de vehículo."))]),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11. MIS ENVÍOS
// ---------------------------------------------------------------------------
class MyShipmentsScreen extends StatelessWidget {
  const MyShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Envíos")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("En Curso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.blue)),
          const SizedBox(height: 10),
          _shipmentCard(context, "Mueble TV y Sillas", "Llegando al destino", AppColors.green, true, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const TrackingScreen()));
          }),
          const SizedBox(height: 30),
          const Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.blue)),
          const SizedBox(height: 10),
          _shipmentCard(context, "Nevera Samsung", "Finalizado • Ayer", Colors.grey, false, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ShipmentDetailScreen()));
          }),
        ],
      ),
    );
  }

  Widget _shipmentCard(BuildContext context, String title, String status, Color statusColor, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: isActive ? Border.all(color: AppColors.orange, width: 1.5) : null, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(50)), child: Icon(FontAwesomeIcons.box, color: isActive ? AppColors.orange : Colors.grey, size: 20)),
          const SizedBox(width: 15),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12))])),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
        ]),
      ),
    );
  }
}

class ShipmentDetailScreen extends StatelessWidget {
  const ShipmentDetailScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalles del Envío")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Icon(Icons.check_circle, color: AppColors.green, size: 80),
          const SizedBox(height: 10),
          const Text("Finalizado con Éxito", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const Text("\$ 55.000 COP", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.blue)),
          const Divider(height: 40),
          // Aquí irían más detalles (filas de información)
        ]),
      ),
    );
  }
}
