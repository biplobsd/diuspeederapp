import 'package:diuspeeder/app/view/glass_morphism.dart';
import 'package:diuspeeder/app/view/menus_page/menus_page.dart';
import 'package:diuspeeder/auth_BLC/cubit/authblc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({required this.title, Key? key}) : super(key: key);
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
      child: GlassMorphism(
        blur: 20,
        opacity: 0.01,
        child: AppBar(
          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          elevation: 1,
          title: title,
          actions: [
            BlocBuilder<AuthblcCubit, AuthblcState>(
              builder: (context, state) {
                if (state is AuthblcLoginState) {
                  final userData =
                      BlocProvider.of<AuthblcCubit>(context).userData;
                  final userPicUrl = userData.userpictureurl;
                  final userFirstName = userData.firstname;

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        PopupMenuButton<String>(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.network(
                                    userPicUrl,
                                  ),
                                ),
                              ),
                              Text(userFirstName),
                            ],
                          ),
                          onSelected: (v) {
                            switch (v) {
                              case 'Logout':
                                BlocProvider.of<AuthblcCubit>(context).logout();
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  MenuesPage.pathName,
                                );
                                break;
                              case 'Home':
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  MenuesPage.pathName,
                                );
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {'Logout', 'Home'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                    ),
                  );
                } else if (state is AuthblcLoadingState) {
                  return Tooltip(
                    message: 'Logging your account...',
                    child: Container(
                      padding: const EdgeInsets.only(
                        bottom: 10,
                        left: 10,
                        right: 30,
                        top: 10,
                      ),
                      child: Lottie.asset(
                        'assets/lotties/loginAccount.json',
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
