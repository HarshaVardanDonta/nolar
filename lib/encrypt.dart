import 'package:encrypt/encrypt.dart';

class EncryptData{
//for AES Algorithms

  static Encrypted? encrypted;
  static var decrypted;


  static encryptAES(plainText){
    final key = Key.fromUtf8('nolarnolarnolarnolarnolarnolarno');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted!.base16;
  }

  static decryptAES(plainText){
    final key = Key.fromUtf8('nolar');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key));
    decrypted = encrypter.decrypt(encrypted!, iv: iv);
    return (decrypted);
  }
}