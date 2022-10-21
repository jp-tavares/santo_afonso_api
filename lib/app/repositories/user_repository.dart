import 'package:mysql1/mysql1.dart';
import 'package:santo_afonso_api/app/core/database/database.dart';
import 'package:santo_afonso_api/app/core/exceptions/email_already_registered.dart';
import 'package:santo_afonso_api/app/core/helpers/crypt_helper.dart';
import 'package:santo_afonso_api/app/entities/user.dart';

class UserRepository {
  Future<void> save(User user) async {
    MySqlConnection? conn;
    try {
      conn = await Database().openConnection();

      await Future.delayed(const Duration(seconds: 1));

      final isUserRegistered = await conn.query(
        'select * from usuario where email = ? ',
        [
          user.email
        ],
      );
      if (isUserRegistered.isEmpty) {
        await conn.query(
          ''' 
            insert into usuario 
            values(?,?,?,?)
          ''',
          [
            null,
            user.name,
            user.email,
            CryptHelper.generatedSha256Hash(user.password)
          ],
        );
        print(isUserRegistered.isEmpty);
      } else {
        print('isUserRegistered ta vazio');
        throw EmailAlreadyRegistered();
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
