import 'package:linkify/linkify.dart';

final _phoneNumberRegex = RegExp(r'^(.*?)([0-9]+)', dotAll: true, caseSensitive: false);

class PhoneNumberLinkifier extends Linkifier {
  const PhoneNumberLinkifier();

  @override
  List<LinkifyElement> parse(elements, options) {
    final list = <LinkifyElement>[];
    elements.forEach((element) {
      if (element is TextElement) {
        var match = _phoneNumberRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          final text = element.text.replaceFirst(match.group(0), '');

          if (match.group(1) != null && match.group(1).isNotEmpty) {
            list.add(TextElement(match.group(1)));
          }

          if(match.group(2) != null && match.group(2).isNotEmpty) {
            if(match.group(2).length == 10) {
              list.add(PhoneNumberElement(match.group(2)));
            } else {
              list.add(TextElement(match.group(2)));
            }
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    });

    return list;
  }
}

class PhoneNumberElement extends LinkableElement {
  final String phoneNumber;

  PhoneNumberElement(this.phoneNumber) : super(phoneNumber, 'tel:$phoneNumber');

  @override
  String toString() {
    return "PhoneNumberElement: '$phoneNumber' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  bool equals(other) =>
      other is PhoneNumberElement &&
          super.equals(other) &&
          other.phoneNumber == phoneNumber;

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;


}