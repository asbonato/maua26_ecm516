// server.dart provisório
import 'dart:io';

import 'package:terrario_api/src/config/app_config.dart';
import 'package:terrario_api/src/config/mysql_dart.dart';
import 'package:terrario_api/src/models/terrario.dart';
import 'package:terrario_api/src/repositories/mysql_terrario_repository.dart';
import 'package:terrario_api/src/repositories/terrario_repository.dart';

Future<void> main() async{
  final config = AppConfig.fromEnv();
  final pool = criarPool(config);
  await aguardarBanco(pool);

  final repository = MySqlTerrarioRepository(pool);

  // ---- Testes extras adicionados para testar todo o CRUD; não estão na apostila ----

  // 1. Inserir um novo terrário tropical
  final novo = await repository.inserir(Terrario(
    apelido: 'Mata Atlântica no meu Quintal',
    bioma: Bioma.tropical,
    umidadeAlvo: 80,
    volumeLitros: 45.5,
    dataMontagem: DateTime(2026, 10, 17),
  ));
  stdout.writeln('Inserido:');
  _imprimir(novo);

  // 2. Consultar o terrário recém-inserido por id
  final porId = await repository.buscarPorId(novo.id!);
  stdout.writeln('Busca por id ${novo.id}:');
  _imprimir(porId);

  // 3. Consultar o terrário recém-inserido por apelido
  final porApelido = await repository.buscarPorApelido(novo.apelido);
  stdout.writeln('Busca por apelido "${novo.apelido}":');
  _imprimir(porApelido);

  // 4. Alterar o apelido do terrário recém-inserido
  final alterado = await repository.atualizar(
    novo.id!,
    novo.copyWith(apelido: 'Mata Atlântica na minha Varanda'),
  );
  stdout.writeln('Alterado id ${novo.id}:');
  _imprimir(alterado);

  // 5. Listar todos os terrários após a alteração
  final paginaAlterada = await repository.listar(const FiltroTerrario());
  stdout.writeln('Total no banco após a alteração: ${paginaAlterada.total}');
  paginaAlterada.itens.forEach(_imprimir);

  // 6. Remover o terrário recém-inserido
  final removido = await repository.remover(novo.id!);
  stdout.writeln('Removido id ${novo.id}: $removido');

  // ---- Fim dos testes extras adicionados para testar todo o CRUD; não estão na apostila ----

  // 7. Listar todos os terrários (como já estava)
  final pagina = await repository.listar(const FiltroTerrario());
  stdout.writeln('Total no banco: ${pagina.total}');
  for (final t in pagina.itens) {
    stdout.writeln(' ${t.id} - ${t.apelido} '
      '(${t.bioma.name}, ${t.umidadeAlvo}%)'
    );
  }

  // Fecha o pool para que o processo consiga terminar
  await pool.close();

}

// ---- Testes extras adicionados para testar todo o CRUD; não estão na apostila ----

/// Imprime um terrário no mesmo formato da listagem.
void _imprimir(Terrario? t) {
  if (t == null) {
    stdout.writeln(' (não encontrado)');
    return;
  }
  stdout.writeln(' ${t.id} - ${t.apelido} '
    '(${t.bioma.name}, ${t.umidadeAlvo}%)'
  );
}

// ---- Fim dos testes extras adicionados para testar todo o CRUD; não estão na apostila ----

// server.dart original
// import 'dart:io';

// import 'package:shelf/shelf.dart';
// import 'package:shelf/shelf_io.dart' as shelf_io;
// import 'package:terrario_api/src/config/app_config.dart';

// /// Future<T> é o equivalente em Dart à Promise do JavaScript: um valor
// /// que ainda não chegou. `async` marca a função que devolve um Future e
// /// `await` pausa a execução até ele completar, exatamente como no 
// /// JavaScript.
// Future<void> main() async{
//   final config = AppConfig.fromEnv();

//   Response handler(Request request) {
//     return Response.ok('API de Terrarios no ar\n');
//   }

//   /// InternetAddres.anyIPv4 (0.0.0.0) é obrigatório dentro de contêiners:
//   /// ouvir apenas em localhost tornaria o servidor inacessível fora dele.
//   final servidor = await shelf_io.serve(
//     handler,
//     InternetAddress.anyIPv4,
//     config.serverPort,
//   );

//   stdout.writeln('Servidor ouvido em http://localhost:${servidor.port}');
//   stdout.writeln(config);

// }
