String detectCardBrand(String cardNumber) {
  final cleaned = cardNumber.replaceAll(' ', '');

  if (RegExp(r'^4').hasMatch(cleaned)) {
    return 'visa';
  }

  if (RegExp(r'^(5[1-5]|2(2[2-9]|[3-6][0-9]|7[01]|720))')
      .hasMatch(cleaned)) {
    return 'mastercard';
  }

  if (RegExp(r'^(34|37)').hasMatch(cleaned)) {
    return 'amex';
  }

  return 'unknown';
}
