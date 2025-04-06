import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt;

class AESHelper {
  static final _key =
      encrypt.Key.fromUtf8('my32lengthsupersecretnooneknows1'); // 32 chars
  static final _iv = encrypt.IV.fromLength(16);

  static Uint8List encryptFile(Uint8List fileBytes) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final encrypted = encrypter.encryptBytes(fileBytes, iv: _iv);
    return encrypted.bytes;
  }

  static Uint8List decryptFile(Uint8List encryptedBytes) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_key));
    final decrypted = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: _iv,
    );
    return Uint8List.fromList(decrypted);
  }
}
