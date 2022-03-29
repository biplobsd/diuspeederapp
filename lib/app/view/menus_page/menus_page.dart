import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:diuspeeder/app/view/login_page/login_page.dart';
import 'package:diuspeeder/app/view/menus_page/model/menus.dart';
import 'package:diuspeeder/app/widgets/bottom_credit.dart';
import 'package:diuspeeder/app/widgets/glass_morphism.dart';
import 'package:diuspeeder/core/auth_BLC/cubit/authblc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuesPage extends StatelessWidget {
  const MenuesPage({Key? key}) : super(key: key);
  static const pathName = '/menus';

  @override
  Widget build(BuildContext context) {
    return MenueScreen();
  }
}

class MenueScreen extends StatelessWidget {
  const MenueScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('DIUSpeeder'),
      ),
      body: const MenuItemWidgets(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.7, color: Colors.white10),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        height: 40,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: GlassMorphism(
            blur: 30,
            opacity: 0.01,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const WhoCreated(),
                InkWell(
                  onTap: () async {
                    const sourceCodeUrl =
                        'https://github.com/biplobsd/DIUSpeederApp';
                    if (!await launch(
                      sourceCodeUrl,
                    )) throw Exception('Could not launch $sourceCodeUrl');
                  },
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(10),
                        child: Image.asset('assets/githubLogo.png'),
                      ),
                      Text(
                        'View source code',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuItemWidgets extends StatelessWidget {
  const MenuItemWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: menus.length,
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
      itemBuilder: (ctx, index) => Stack(
        children: [
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.blueGrey.withOpacity(0.1),
                  BlendMode.dstATop,
                ),
                image: menus[index].image,
              ),
              borderRadius: BorderRadius.circular(15),
              gradient: menus[index].gradient,
            ),
            margin: const EdgeInsets.only(bottom: 15),
            child: InkWell(
              onTap: () {
                if (!menus[index].isComingSoon) {
                  if (menus[index].isLoginRequired) {
                    if (BlocProvider.of<AuthblcCubit>(context).state
                        is AuthblcLoginState) {
                      Navigator.of(context).pushNamed(menus[index].pageOpen);
                    } else {
                      Navigator.of(context).pushNamed(
                        LoginPage.pathName,
                        arguments: menus[index].pageOpen,
                      );
                    }
                  } else {
                    Navigator.of(context).pushNamed(menus[index].pageOpen);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'This option is coming soon 🥺. Stay with us. ',
                      ),
                    ),
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    menus[index].icon,
                    size: 50,
                    color: menus[index].titleIconColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    menus[index].title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: menus[index].titleIconColor.withOpacity(0.8),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          if (menus[index].isComingSoon)
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: FittedBox(
                  child: Text(
                    'Coming soon',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
