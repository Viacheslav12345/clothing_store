import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazka/features/presentation/landing.dart';
import 'package:kazka/features/presentation/main_screen/main_screen.dart';
import 'package:kazka/features/presentation/main_screen/tabs/basket_and_order/basket/basket_cubit/basket_cubit.dart';
import 'package:kazka/features/presentation/main_screen/tabs/basket_and_order/order/orders_cubit/orders_cubit.dart';
import 'package:kazka/features/presentation/main_screen/tabs/favorites/cubit/favorite_cubit.dart';
import 'package:kazka/features/presentation/main_screen/tabs/home/products_bloc/products_bloc.dart';
import 'package:kazka/features/presentation/main_screen/tabs/home/product_swiping_card/card_provider.dart';
import 'package:kazka/features/presentation/main_screen/tabs/profile/current_user_bloc/current_user_bloc.dart';
import 'package:kazka/features/presentation/main_screen/tabs/profile/manager_product_pages/product_form_bloc/product_form_bloc.dart';
import 'package:kazka/locator_service.dart';
import 'package:kazka/router/router.dart';
import 'package:kazka/theme/theme.dart';
import 'package:provider/provider.dart';

class KazkaApp extends StatelessWidget {
  const KazkaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (context) => CardProvider(),
          child: const MainScreen(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider(
              lazy: false, //if exception
              create: (context) => (sl<FirebaseAuth>().currentUser != null)
                  ? (sl<CurrentUserBloc>()..add(LoadedCurrentUser()))
                  : sl<CurrentUserBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<ProductFormBloc>(),
            ),
            BlocProvider(
              create: (context) => sl<ProductsBloc>()..add(LoadAllProducts()),
            ),
            BlocProvider(
              create: (context) => sl<FavoriteCubit>()..loadFavProduct(),
            ),
            BlocProvider(
                create: (context) => sl<BasketCubit>()..loadBasketProducts()),
            BlocProvider(create: (context) => sl<OrdersCubit>()),
          ],
          child: const LandingPage(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        routes: routes,
        initialRoute: "/",
      ),
    );
  }
}
