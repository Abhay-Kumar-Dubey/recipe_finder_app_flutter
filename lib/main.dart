import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recipe_finder_app/app/modules/favourite_recipe_page/bloc/favorites_bloc.dart';
import 'package:recipe_finder_app/app/modules/recipe_detail_page/bloc/recipe_detail_bloc.dart';
import 'package:recipe_finder_app/app/modules/recipe_list_page/bloc/recipe_list_bloc.dart';
import 'package:recipe_finder_app/app/modules/recipe_list_page/recipe_list_page.dart';
import 'package:recipe_finder_app/app/services/favorites_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await FavoritesService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) => RecipeListBloc()),
          BlocProvider(create: (BuildContext context) => RecipeDetailBloc()),
          BlocProvider(create: (BuildContext context) => FavoritesBloc()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const RecipeListPage(),
        ),
      ),
    );
  }
}
