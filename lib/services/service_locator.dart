import 'package:chefs_mind/services/storage_service/shared_preferences_storage.dart';
import 'package:get_it/get_it.dart';

import 'api_service.dart';

final locator = GetIt.instance;

void setupGetIt() {
  locator.registerSingleton<ApiService>(ApiService());
  locator.registerSingleton<SharedPreferencesStorage>(SharedPreferencesStorage());
}