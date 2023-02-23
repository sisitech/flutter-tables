import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'hello': 'Hello World',
          'Add': 'Adding',
          'empty_field': "This field must not be empty"
        },
        'swa_KE': {
          'hello': 'Habari Yako',
          'Add': 'Ongeze',
          'Login': 'Ingia',
          'Submit': 'Wasilisha',
          'Delete ?': 'Futa ?',
          'Delete': 'Futa',
          'Cancel': 'Wacha',
          'Signing in...': 'Naingia...',
          'Contact name': 'Jina la mhusika',
          'Name': 'Jina',
          "Delete shop @name# ?": "Futa duka @name# ?",
          'Teacher Type': 'Cheo cha Mwalimu',
          'Username': 'Kitambulisho',
          'Active': 'Inatumika',
          "TSC": "tsc",
          "Managed by @contact_name#": "Inatunzwa na @contact_name#",
          "Shop's name @name#": "Jina la Duka ni @name#",
          'hello_one': 'habari @name @age 1',
          "empty_field": "Linahitajika",
          "Faield..": "Imefeli..",
          'Modified': 'Ilibadilishwa Lini',
          'Password': 'Neno Siri',
          'School emis Code / Phone number': 'Kodi ya Shule / Nambari ya simu',
        },
        'de_DE': {
          'hello': 'Hallo Welt',
        }
      };
}
