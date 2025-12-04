import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'mvvm/viewmodels/login_viewmodel.dart';
import 'mvvm/viewmodels/cliente_viewmodel.dart';
import 'mvvm/viewmodels/funcionario_viewmodel.dart';
import 'mvvm/viewmodels/servico_viewmodel.dart';
import 'mvvm/viewmodels/pagamento_viewmodel.dart';
import 'mvvm/viewmodels/agendamento_viewmodel.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ------------------------------------------------------
  // Suporte SQLite para desktop (Linux/Windows) — desativado
  // usado apenas se o projeto precisar de banco local via FFI.
  // ------------------------------------------------------
  // sqfliteFfiInit();
  // databaseFactory = databaseFactoryFfi;

  // Inicializa a formatação de datas no padrão do Brasil.
  await initializeDateFormatting('pt_BR', null);

  // MultiProvider injeta todos os ViewModels na árvore de Widgets.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => ClienteViewModel()),
        ChangeNotifierProvider(create: (_) => FuncionarioViewModel()),
        ChangeNotifierProvider(create: (_) => ServicoViewModel()),
        ChangeNotifierProvider(create: (_) => PagamentoViewModel()),
        ChangeNotifierProvider(create: (_) => AgendamentoViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

// Widget raiz do aplicativo
// Define tema, idioma e página inicial
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Acessa o LoginViewModel para saber se o usuário está logado
    final loginVm = Provider.of<LoginViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove banner de debug
      title: 'Sistema de Agendamento',
      theme: ThemeData(
        primarySwatch: Colors.pink, // Cor principal do app
        scaffoldBackgroundColor: const Color.fromARGB(255, 245, 245, 245),
        useMaterial3: true, // Usa Material Design 3
      ),

      // Localização do app (para PT-BR)
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'), 
      ],

      // Define página inicial dinamicamente:
      home: loginVm.logado ? const HomePage() : const LoginPage(),
    );
  }
}
