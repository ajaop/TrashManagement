// env/env.dart

import 'package:envify/envify.dart';
part 'env.g.dart';

@Envify()
abstract class Env {
  @Envify(name: 'GOOGLE_API_KEY')
  static const googleApiKey = _Env.googleApiKey;

  @Envify(name: 'GOOGLE_API_KEY_2')
  static const googleApiKey2 = _Env.googleApiKey2;

  @Envify(name: 'PAYSTACK_TEST_PUBLIC_KEY')
  static const paystackTestPublicKey = _Env.paystackTestPublicKey;

  @Envify(name: 'PAYSTACK_SECRET_TEST_KEY')
  static const paystackSecretTestKey = _Env.paystackSecretTestKey;
}
