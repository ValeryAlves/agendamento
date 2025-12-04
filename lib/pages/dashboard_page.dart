import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';

/// PÁGINA PRINCIPAL DO DASHBOARD
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  // VARIÁVEIS DE ESTADO DO DASHBOARD
  int totalAgendamentos = 0;       // Total geral
  int totalHoje = 0;               // Agendamentos somente do dia
  int totalSemana = 0;             // Agendamentos da semana atual
  int totalNaoRealizados = 0;      // Agendamentos marcados como não realizados

  // Listas completas de dados (exibidas na tela)
  List<Map<String, dynamic>> agendamentosHoje = [];
  List<Map<String, dynamic>> agendamentosSemana = [];

  @override
  void initState() {
    super.initState();
    _carregarDados(); // Carrega dados ao abrir a tela
  }

  /// FUNÇÃO QUE CONSULTA O BANCO E ATUALIZA OS DADOS DO DASHBOARD
  Future<void> _carregarDados() async {
    try {
      final db = DatabaseHelper.instance; // Instância do banco
      final hoje = DateFormat('dd/MM/yyyy').format(DateTime.now());

      // Cálculo automático do início e fim da semana (segunda a domingo)
      final now = DateTime.now();
      final inicioSemana = DateFormat('dd/MM/yyyy')
          .format(now.subtract(Duration(days: now.weekday - 1)));
      final fimSemana = DateFormat('dd/MM/yyyy')
          .format(now.add(Duration(days: 7 - now.weekday)));

      // BUSCA DOS TOTAIS NO DATABASE
      final total = await db.getTotalAgendamentos();
      final hojeCount = await db.getAgendamentosPorData(hoje);
      final semanaCount = await db.getAgendamentosEntreDatas(
        inicioSemana,
        fimSemana,
      );
      final naoRealizados = await db.getAgendamentosNaoRealizados();

      // QUERIES DETALHADAS (com joins no cliente/serviço)
      final dbConn = await DatabaseHelper.database;

      // Agendamentos do dia com nome do cliente e serviço
      final hojeList = await dbConn.rawQuery(
        '''
        SELECT a.*, c.nome AS cliente, s.nome AS servico
        FROM agendamento a
        LEFT JOIN cliente c ON c.id = a.idCliente
        LEFT JOIN servico s ON s.id = a.idServico
        WHERE a.data = ?
        ORDER BY a.hora ASC
        ''',
        [hoje],
      );

      // Agendamentos da semana
      final semanaList = await dbConn.rawQuery(
        '''
        SELECT a.*, c.nome AS cliente, s.nome AS servico
        FROM agendamento a
        LEFT JOIN cliente c ON c.id = a.idCliente
        LEFT JOIN servico s ON s.id = a.idServico
        WHERE a.data BETWEEN ? AND ?
        ORDER BY a.data ASC, a.hora ASC
        ''',
        [inicioSemana, fimSemana],
      );

      // Atualiza o estado da tela
      setState(() {
        totalAgendamentos = total;
        totalHoje = hojeCount;
        totalSemana = semanaCount;
        totalNaoRealizados = naoRealizados;

        agendamentosHoje = hojeList;
        agendamentosSemana = semanaList;
      });
    } catch (e) {
      // Log de erro no console
      debugPrint('❌ Erro ao carregar dados do dashboard: $e');
    }
  }

  /// ESTRUTURA DA PÁGINA
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color.fromARGB(255, 255, 243, 251),
        centerTitle: true,
      ),

      // Permite atualizar arrastando para baixo
      body: RefreshIndicator(
        onRefresh: _carregarDados,

        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            // Cartões de resumo superior
            _buildCard('Agendamentos de Hoje', totalHoje, Icons.today),
            _buildCard(
              'Agendamentos da Semana',
              totalSemana,
              Icons.calendar_view_week,
            ),
            _buildCard(
              'Todos os Agendamentos',
              totalAgendamentos,
              Icons.list_alt,
            ),
            _buildCard(
              'Não Realizados',
              totalNaoRealizados,
              Icons.cancel_outlined,
            ),

            // LISTA DE AGENDAMENTOS DE HOJE
            const SizedBox(height: 24),
            const Text(
              "📅 Agendamentos de Hoje",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ..._buildAgendamentoList(agendamentosHoje),

            // LISTA DA SEMANA
            const SizedBox(height: 24),
            const Text(
              "🗓️ Agendamentos da Semana",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            ..._buildAgendamentoList(agendamentosSemana),
          ],
        ),
      ),
    );
  }

  /// WIDGET AUXILIAR — CARTÃO DE RESUMO (Totais)
  Widget _buildCard(String title, int value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,

      child: ListTile(
        // Ícone dentro de um círculo
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: Icon(icon, color: Colors.pink.shade700),
        ),

        // Título do cartão
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        // Valor exibido à direita
        trailing: Text(
          '$value',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.pink,
          ),
        ),
      ),
    );
  }

  /// WIDGET AUXILIAR — LISTA DE AGENDAMENTOS (Dia e Semana)
  List<Widget> _buildAgendamentoList(List<Map<String, dynamic>> lista) {
    // Caso a lista esteja vazia
    if (lista.isEmpty) {
      return [
        const Text(
          "Nenhum agendamento encontrado.",
          style: TextStyle(color: Colors.grey),
        ),
      ];
    }

    // Monta cartões individuais para cada agendamento
    return lista.map((ag) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          // Ícone: realizado / pendente
          leading: Icon(
            ag['realizado'] == 1 ? Icons.check_circle : Icons.schedule,
            color: ag['realizado'] == 1 ? Colors.green : Colors.orange,
          ),

          // Nome do cliente + tipo de serviço
          title: Text(
            "${ag['cliente'] ?? 'Cliente não informado'} - ${ag['servico'] ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          // Data + hora
          subtitle: Text("Data: ${ag['data']} - Hora: ${ag['hora']}"),

          // Ícone de pagamento
          trailing: ag['pago'] == 1
              ? const Icon(Icons.attach_money, color: Colors.green)
              : const Icon(Icons.money_off, color: Colors.red),
        ),
      );
    }).toList();
  }
}
