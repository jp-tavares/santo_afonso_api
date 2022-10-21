import 'package:mysql1/mysql1.dart';
import 'package:santo_afonso_api/app/core/database/database.dart';
import 'package:santo_afonso_api/app/core/helpers/crypt_helper.dart';
import 'package:santo_afonso_api/app/entities/user.dart';

class UserRepository {
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      print("Antes de abrir conexão");

      conn = await Database().openConnection();
      Future.delayed(const Duration(seconds: 1));
      print("Depois de abrir conexão");
      final isUserRegistered = await conn.query(
        'select * from usuario where email = ? ',
        [
          user.email
        ],
      );
      print('isUserRegistered.isEmpty');
      if (isUserRegistered.isEmpty) {
        await conn.query(
          ''' 
            inset into usuario 
            values(?,?,?)
          ''',
          [
            user.name,
            user.email,
            CryptHelper.generatedSha256Hash(user.password)
          ],
        );
      } else {
        throw Exception();
      }
    } on MySqlException catch (e, s) {
      print(e);
      print(s);
      throw Exception();
    } finally {
      await conn?.close();
    }
  }
}
