typedef LogSanitizer = String Function(String input);

class DefaultSanitizers {
  static String redactEmails(String s) {
    final email = RegExp(r'[\w\.\-]+@[\w\.\-]+\.\w+');
    return s.replaceAll(email, '[REDACTED_EMAIL]');
  }

  static String redactPhones(String s) {
    final phone = RegExp(r'\+?\d[\d\s\-]{7,}\d');
    return s.replaceAll(phone, '[REDACTED_PHONE]');
  }

  static String applyAll(String s) {
    return redactPhones(redactEmails(s));
  }
}
