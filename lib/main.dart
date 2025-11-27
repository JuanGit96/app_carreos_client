// ---------------------------------------------------------------------------
// APP CLIENTE (USUARIO) - VERSIÓN FINAL "SUPER FLUJO" + COMENTARIOS EDUCATIVOS
// ---------------------------------------------------------------------------
// NOTA DIDÁCTICA:
// Hemos unificado el flujo de solicitud. Ahora es lineal:
// 1. Home (Inicio) -> 2. Dirección -> 3. Carga -> 4. Vehículo/Tiempo -> 5. Tracking.
// Esto reduce el abandono del usuario y simplifica la experiencia.

import 'package:flutter/material.dart'; // Librería base de UI de Google
import 'package:google_fonts/google_fonts.dart'; // Fuentes bonitas
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Iconos profesionales
import 'package:intl/intl.dart'; // Utilidades para formatear fechas y dinero
import 'dart:async'; // Para temporizadores (Simulación de búsqueda de conductor)

// ---------------------------------------------------------------------------
// 1. CONFIGURACIÓN GLOBAL
// ---------------------------------------------------------------------------
// Definimos una clase estática para tener los colores centralizados.
// Si mañana quieres cambiar el naranja por rojo, solo lo cambias aquí.
class AppColors {
  static const Color orange = Color(0xFFFF6B35);
  static const Color blue = Color(0xFF0F2537);
  static const Color background = Color(0xFFF8F9FA);
  static const Color text = Color(0xFF1F2937);
  static const Color green = Color(0xFF10B981);
}

// Punto de entrada de la aplicación.
void main() {
  runApp(const AppCarreosClient());
}

// Widget Raíz: Configura el tema, rutas y estilos globales.
class AppCarreosClient extends StatelessWidget {
  const AppCarreosClient({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppCarreos Usuario',
      debugShowCheckedModeBanner: false, // Quita la etiqueta roja de "DEBUG"
      theme: ThemeData(
        // Configuramos la fuente Poppins para toda la app
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: AppColors.orange,
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true, // Usa el nuevo diseño Material 3 de Google
        // Definimos cómo se ven los inputs (cajas de texto) por defecto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        // Definimos el estilo de los botones elevados por defecto
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ),
      home: const AuthScreen(), // La primera pantalla que se muestra
    );
  }
}

// ---------------------------------------------------------------------------
// 2. AUTENTICACIÓN (LOGIN / REGISTRO)
// ---------------------------------------------------------------------------
// StatefulWidget permite que la pantalla cambie (ej: pasar de Login a Registro)
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Variable de estado: Controla qué formulario mostramos
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    // Scaffold es el lienzo básico (fondo, cuerpo, barra superior, etc.)
    return Scaffold(
      backgroundColor: AppColors.blue,
      // SafeArea evita que el contenido quede debajo del notch o la barra de estado
      body: SafeArea(
        child: SingleChildScrollView( // Permite hacer scroll si el teclado tapa contenido
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 40), // Espaciador vertical
              const Icon(FontAwesomeIcons.truckFast, size: 60, color: AppColors.orange),
              const SizedBox(height: 15),
              Text("AppCarreos", style: GoogleFonts.montserrat(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 40),

              // Selector visual de pestañas (Tabs)
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

              // Lógica condicional en la UI: Si NO es login, mostramos campos extra
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

              // Botón ancho completo
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navegación: Reemplazamos la pantalla actual por la principal
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

  // Widget auxiliar para construir las pestañas del switch
  Widget _buildTab(String text, bool isLoginTab) {
    final bool isSelected = _isLogin == isLoginTab;
    return Expanded( // Ocupa el 50% del ancho disponible
      child: GestureDetector( // Detecta toques en la pantalla
        onTap: () => setState(() => _isLogin = isLoginTab), // setState redibuja la pantalla con el nuevo valor
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

  // Widget auxiliar para los campos de texto
  Widget _buildInput(String hint, IconData icon, {bool isPassword = false}) {
    return TextField(
      obscureText: isPassword, // Oculta texto si es contraseña
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
// 3. NAVEGACIÓN PRINCIPAL (BOTTOM BAR)
// ---------------------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Índice de la pestaña activa (0: Home, 1: Envíos, 2: Perfil)

  // Lista de las pantallas que se mostrarán
  final List<Widget> _screens = [
    const HomeScreen(),
    const MyShipmentsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Muestra la pantalla correspondiente al índice
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index), // Actualiza el índice al tocar
        selectedItemColor: AppColors.orange,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Evita animaciones de "zoom" en los iconos
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
// 4. HOME SCREEN - EL PUNTO DE PARTIDA
// ---------------------------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER UBICACIÓN ACTUAL ---
              Padding(
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

              // --- CAJA DE BÚSQUEDA "A DÓNDE VAS?" (TRIGGER PRINCIPAL DEL FLUJO) ---
              GestureDetector(
                onTap: () {
                  // ALERTA UX: Aquí inicia el flujo unificado. Navegamos a la selección de dirección.
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AddressSelectionScreen()));
                },
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

              // --- SECCIÓN DESTINOS RECIENTES ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text("Destinos Recientes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.blue)),
              ),
              const SizedBox(height: 10),

              // ListView horizontal para scroll lateral de tarjetas
              // FIX: Aumentamos height de 100 a 120 para evitar RenderFlex overflow
              SizedBox(
                height: 120, // Antes era 100, esto causaba el error si la fuente era grande
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _recentPlaceCard("Casa Mamá", "Cedritos"),
                    _recentPlaceCard("Oficina", "Chapinero"),
                    _recentPlaceCard("Bodega", "Zona Ind."),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // --- BANNER PROMO ---
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

  Widget _recentPlaceCard(String title, String subtitle) {
    return Container(
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
    );
  }
}

// ---------------------------------------------------------------------------
// 5. FLUJO PASO 1: SELECCIÓN DE DIRECCIÓN
// ---------------------------------------------------------------------------
class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ruta del Servicio"), elevation: 0),
      body: Column(
        children: [
          // Inputs de Origen y Destino
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

          // Mapa Simulado de fondo
          Expanded( // Expanded ocupa todo el espacio vertical restante
            child: Container(
              color: Colors.grey[200],
              width: double.infinity,
              child: Stack( // Stack permite apilar widgets uno encima de otro (capas)
                children: [
                  const Center(child: Icon(Icons.map, size: 100, color: Colors.black12)),
                  Positioned( // Botón flotante posicionado manualmente
                    bottom: 30, left: 20, right: 20,
                    child: ElevatedButton(
                      onPressed: () {
                        // PASO SIGUIENTE: Definir qué llevamos
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CargoInputScreen()));
                      },
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

// ---------------------------------------------------------------------------
// 6. FLUJO PASO 2: INPUT DE CARGA (UNIFICADO)
// ---------------------------------------------------------------------------
class CargoInputScreen extends StatefulWidget {
  const CargoInputScreen({super.key});
  @override
  State<CargoInputScreen> createState() => _CargoInputScreenState();
}

class _CargoInputScreenState extends State<CargoInputScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController; // Controlador para animar las pestañas

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
          // OPCIÓN 1: FACTURA
          _buildPlaceholderTab("Escanea tu factura", "Detectamos los ítems automáticamente", Icons.qr_code_scanner),
          // OPCIÓN 2: FOTOS
          _buildPlaceholderTab("Toma fotos a la carga", "La IA calcula el volumen necesario", Icons.camera_alt),
          // OPCIÓN 3: MANUAL (Input real)
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
                  onTap: () {}, // Simular grabación
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // PASO SIGUIENTE: Configurar vehículo y tiempo
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingConfigScreen()));
                    },
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
          onPressed: () {
            // Simulamos que escaneó y pasa al siguiente
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingConfigScreen()));
          },
          child: const Text("ABRIR CÁMARA"),
        )
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 7. FLUJO PASO 3: CONFIGURACIÓN (VEHÍCULO + TIEMPO)
// ---------------------------------------------------------------------------
class BookingConfigScreen extends StatefulWidget {
  const BookingConfigScreen({super.key});
  @override
  State<BookingConfigScreen> createState() => _BookingConfigScreenState();
}

class _BookingConfigScreenState extends State<BookingConfigScreen> {
  bool _isImmediate = true; // Controla si es "Ahora" o "Programado"
  int _selectedVehicle = 0; // Índice del vehículo seleccionado

  // Variables para guardar fecha y hora seleccionada
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Función para abrir el selector de Fecha de Android/iOS
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

  // Función para abrir el selector de Hora de Android/iOS
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirmar Servicio")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- RESUMEN DE RUTA ---
            const Text("Tu Ruta", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(children: const [
              Icon(Icons.circle, size: 12, color: Colors.green), SizedBox(width: 8), Text("Calle 122 # 15-45"),
              SizedBox(width: 15), Icon(Icons.arrow_forward, size: 12, color: Colors.grey), SizedBox(width: 15),
              Icon(Icons.location_on, size: 12, color: AppColors.orange), SizedBox(width: 8), Text("Cra 7 # 72-10"),
            ]),
            const Divider(height: 30),

            // --- SELECTOR DE TIEMPO ---
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

            // --- UI CONDICIONAL: SOLO APARECE SI SELECCIONAS "PROGRAMAR" ---
            if (!_isImmediate) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    // Selector de Fecha
                    ListTile(
                      onTap: _pickDate,
                      leading: const Icon(Icons.calendar_month, color: AppColors.orange),
                      title: Text(_selectedDate == null ? "Seleccionar Fecha" : DateFormat('EEE, d MMM').format(_selectedDate!)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                    const Divider(),
                    // Selector de Hora
                    ListTile(
                      onTap: _pickTime,
                      leading: const Icon(Icons.access_time, color: AppColors.blue),
                      title: Text(_selectedTime == null ? "Seleccionar Hora" : _selectedTime!.format(context)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    ),
                  ],
                ),
              )
            ],

            const SizedBox(height: 20),

            // --- SELECTOR DE VEHÍCULO ---
            const Text("Vehículo Sugerido", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _vehicleOption(0, "Van Pequeña", "45.000", FontAwesomeIcons.shuttleVan),
            _vehicleOption(1, "Estacas", "65.000", FontAwesomeIcons.truckPickup),

            const SizedBox(height: 20),

            // --- PAGO ---
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(FontAwesomeIcons.ccVisa, color: AppColors.blue),
              title: const Text("Visa **** 4242"),
              trailing: const Text("Cambiar", style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Si es programado y no ha elegido fecha, mostramos error
                  if (!_isImmediate && (_selectedDate == null || _selectedTime == null)) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Por favor selecciona fecha y hora")));
                    return;
                  }

                  // PASO SIGUIENTE: INICIAR BÚSQUEDA
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

  // Widget auxiliar para las opciones de tiempo
  Widget _timeOption(String text, bool isImmediateOption) {
    bool selected = _isImmediate == isImmediateOption;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _isImmediate = isImmediateOption),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              boxShadow: selected ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : null
          ),
          child: Text(text, textAlign: TextAlign.center, style: TextStyle(fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        ),
      ),
    );
  }

  // Widget auxiliar para las tarjetas de vehículo
  Widget _vehicleOption(int index, String name, String price, IconData icon) {
    bool selected = _selectedVehicle == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: selected ? AppColors.orange : Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10)
        ),
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
// 8. PANTALLA DE "BUSCANDO CONDUCTOR" (INTERMEDIA)
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
    // Simulamos 3 segundos de búsqueda y pasamos al mapa automáticamente
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
            CircularProgressIndicator(color: AppColors.orange), // Animación de carga
            SizedBox(height: 20),
            Text("Conectando con conductores...", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            Text("Estamos buscando el vehículo ideal", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 9. PANTALLA DE TRACKING (MAPA)
// ---------------------------------------------------------------------------
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack( // Stack permite poner el mapa al fondo y tarjetas encima
        children: [
          // MAPA DE FONDO (Simulado)
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            height: double.infinity,
            child: const Center(child: Text("GOOGLE MAPS VIEW", style: TextStyle(color: Colors.grey, fontSize: 24, fontWeight: FontWeight.bold))),
          ),

          // RUTA DIBUJADA
          Center(child: Container(width: 200, height: 4, color: AppColors.orange)),

          // BOTÓN FLOTANTE SOS
          Positioned(
            top: 50, right: 20,
            child: CircleAvatar(backgroundColor: Colors.red, radius: 25, child: Icon(Icons.sos, color: Colors.white)),
          ),

          // TARJETA INFERIOR DE ESTADO
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Barra pequeña para indicar que se puede deslizar
                  Container(width: 40, height: 4, color: Colors.grey[300], margin: const EdgeInsets.only(bottom: 20)),

                  const Text("Llegada en 8 min", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Conductor en camino a recogida", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 20),

                  // Info Conductor
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

                  // Botones Llamar/Chat
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
// 10. PANTALLAS DE PERFIL Y CONFIGURACIÓN
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

            // Opciones del menú
            _menuItem(context, "Métodos de Pago", FontAwesomeIcons.creditCard, const PaymentMethodsScreen()),
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
// 11. PANTALLA: MIS ENVÍOS (HISTORIAL CON DATOS DUMMY)
// ---------------------------------------------------------------------------
class MyShipmentsScreen extends StatelessWidget {
  const MyShipmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Envíos")),
      // ListView permite una lista de elementos que se puede scrollear
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("En Curso", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.blue)),
          const SizedBox(height: 10),
          // Envío activo
          _shipmentCard("Mueble TV y Sillas", "Llegando al destino", AppColors.green, true),

          const SizedBox(height: 30),
          const Text("Historial", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.blue)),
          const SizedBox(height: 10),
          // Envíos pasados
          _shipmentCard("Nevera Samsung", "Finalizado • Ayer", Colors.grey, false),
          _shipmentCard("Cajas Oficina", "Finalizado • 20 Nov", Colors.grey, false),
          _shipmentCard("Sofá Cama", "Cancelado • 15 Nov", Colors.red, false),
        ],
      ),
    );
  }

  // Widget auxiliar para las tarjetas de envío
  Widget _shipmentCard(String title, String status, Color statusColor, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isActive ? Border.all(color: AppColors.orange, width: 1.5) : null,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          // Icono circular
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(50)),
            child: Icon(FontAwesomeIcons.box, color: isActive ? AppColors.orange : Colors.grey, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
        ],
      ),
    );
  }
}

// --- DUMMY SCREENS EXTRA (Sin cambios mayores) ---

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Métodos de Pago")),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        _cardTile("Visa", "**** 4242", true),
        _cardTile("Mastercard", "**** 9988", false),
        const SizedBox(height: 20),
        OutlinedButton(onPressed: (){}, child: const Text("Agregar Tarjeta"))
      ]),
    );
  }
  Widget _cardTile(String type, String num, bool def) => ListTile(leading: const Icon(FontAwesomeIcons.ccVisa, size: 30), title: Text("$type $num"), trailing: def ? const Icon(Icons.check, color: Colors.green) : null);
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

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ayuda")),
      body: ListView(children: const [
        ListTile(title: Text("Reportar un problema con un viaje"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        ListTile(title: Text("Preguntas Frecuentes"), trailing: Icon(Icons.arrow_forward_ios, size: 14)),
        ListTile(title: Text("Línea de emergencia"), trailing: Icon(Icons.phone, color: Colors.red)),
      ]),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración")),
      body: ListView(children: const [
        ListTile(title: Text("Notificaciones Push"), trailing: Icon(Icons.toggle_on, color: Colors.green, size: 30)),
        ListTile(title: Text("Idioma"), trailing: Text("Español >")),
        ListTile(title: Text("Eliminar Cuenta"), textColor: Colors.red),
      ]),
    );
  }
}