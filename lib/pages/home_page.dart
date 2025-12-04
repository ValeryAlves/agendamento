import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../mvvm/viewmodels/login_viewmodel.dart';
import 'agendamento/agendamento_list_page.dart';
import 'cliente/cliente_list_page.dart';
import 'servico/servico_list_page.dart';
import 'pagamento/pagamento_list_page.dart';
import 'funcionario/funcionario_list_page.dart';
import 'dashboard_page.dart';

/// Página inicial do sistema.
/// Possui menu inferior (BottomNavigationBar) + menu lateral (Drawer).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Índice da aba selecionada no BottomNavigationBar
  int _selectedIndex = 0;

  // Lista de páginas exibidas no corpo do Scaffold conforme o índice
  final List<Widget> _pages = [
    const DashboardPage(),        // Página inicial com resumo
    const AgendamentoListPage(),  // Lista de agendamentos
    const ClienteListPage(),      // Lista de clientes
    const ServicoListPage(),      // Lista de serviços
  ];

  /// Atualiza a tela quando o usuário toca em alguma opção do BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Abre páginas que NÃO fazem parte do BottomNavigationBar,
  /// como Funcionários e Forma de Pagamento.
  void _openPage(Widget page) {
    Navigator.pop(context); // Fecha o Drawer antes de abrir a nova página
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  @override
  Widget build(BuildContext context) {
    // Acesso ao ViewModel de Login para realizar logout
    final loginVm = Provider.of<LoginViewModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),

      // --- APP BAR ---
      appBar: AppBar(
        title: const Text('Sistema de Agendamento'),
        centerTitle: true,
        backgroundColor: Colors.pink.shade300,
        actions: [
          // Botão de sair (logout)
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              loginVm.logout(); // Chama método de logout
            },
          ),
        ],
      ),

      // --- CORPO DA TELA ---
      body: SafeArea(
        // Exibe a página correspondente ao índice selecionado
        child: _pages[_selectedIndex],
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Não anima/oculta itens
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey.shade200,
        selectedItemColor: Colors.pink.shade400,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Agendamentos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'Serviços',
          ),
        ],
      ),

      // --- MENU LATERAL (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Cabeçalho do menu
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink.shade300,
              ),
              child: const Text(
                'Menu Principal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Opções que controlam o BottomNavigationBar
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Agendamentos'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clientes'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 2);
              },
            ),

            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Serviços'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 3);
              },
            ),

            // Opções que abrem páginas independentes (não alteram o bottom nav)
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Funcionários'),
              onTap: () => _openPage(const FuncionarioListPage()),
            ),

            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('Formas de Pagamento'),
              onTap: () => _openPage(const PagamentoListPage()),
            ),
          ],
        ),
      ),
    );
  }
}
