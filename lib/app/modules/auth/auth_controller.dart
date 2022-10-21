import 'dart:async';
import 'dart:convert';
import 'package:santo_afonso_api/app/core/exceptions/email_already_registered.dart';
import 'package:santo_afonso_api/app/entities/user.dart';
import 'package:santo_afonso_api/app/repositories/user_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part 'auth_controller.g.dart';

class AuthController {
  final _userRepository = UserRepository();

  @Route.post('/register')
  Future<Response> register(Request request) async {
    try {
      final userRq = User.fromJson(await request.readAsString());
      print(_userRepository.toString());
      await _userRepository.save(userRq);

      return Response(200, headers: {
        'Content-Type': 'application/json',
      });
    } on EmailAlreadyRegistered catch (e, s) {
      print(e);
      print(s);
      return Response(400,
          body: jsonEncode(
            {
              'error': 'E-mail já cadastrado.'
            },
          ),
          headers: {
            'Content-Type': 'application/json'
          });
    } catch (e, s) {
      print(e);
      print(s);
      return Response.internalServerError();
    }
  }

  Router get router => _$AuthControllerRouter(this);
}
