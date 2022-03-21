import 'package:diuspeeder/app/view/login_page/cubit/loginpage_cubit.dart';
import 'package:diuspeeder/app/widgets/bottom_credit.dart';
import 'package:diuspeeder/core/auth_BLC/cubit/authblc_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({required this.wantThisPage, Key? key}) : super(key: key);

  static const pathName = '/login';
  final String wantThisPage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginpageCubit(),
      child: LoginPageScreen(
        wantThisPage: wantThisPage,
      ),
    );
  }
}

class LoginPageScreen extends StatelessWidget {
  LoginPageScreen({
    required this.wantThisPage,
    Key? key,
  }) : super(key: key);
  final String wantThisPage;

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    late bool isCheck;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context)
                        .primaryIconTheme
                        .color!
                        .withOpacity(0.5),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: Image.asset(
                          'assets/BLC logo.png',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Login your BLC',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall!
                                .copyWith(fontSize: 20),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 10,
                            ),
                            child: Text(
                              'It is need for comminitec with your BLC account. '
                              'Without accessing no feature will be working.',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: 25,
                        child: BlocBuilder<LoginpageCubit, LoginpageState>(
                          builder: (context, state) {
                            if (state is LoginpageErrorState) {
                              return Text(
                                state.msg,
                                style: const TextStyle(color: Colors.red),
                              );
                            } else {
                              return BlocBuilder<AuthblcCubit, AuthblcState>(
                                builder: (context, state) {
                                  if (state is AuthblcErrorState) {
                                    return const Text(
                                      'Invalidlogin',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  }
                                  return Container();
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      style: Theme.of(context).textTheme.caption,
                      controller: _username,
                      onChanged: (_) => BlocProvider.of<LoginpageCubit>(context)
                          .errorMsg(_username.text, _password.text),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.account_circle),
                        labelStyle: const TextStyle(height: 3.5),
                        label: const Text('Username/Email address'),
                        // hintText: 'biplobsd11@gmail.com',
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      style: Theme.of(context).textTheme.caption,
                      controller: _password,
                      onChanged: (_) => BlocProvider.of<LoginpageCubit>(context)
                          .errorMsg(_username.text, _password.text),
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        prefixIcon: const Icon(Icons.lock),
                        labelStyle: const TextStyle(height: 3.5),
                        label: const Text('Password'),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        BlocBuilder<LoginpageCubit, LoginpageState>(
                          builder: (context, state) {
                            if (state is LoginpageSaveDataState) {
                              isCheck = true;
                            } else {
                              isCheck = false;
                            }
                            return Checkbox(
                              value: isCheck,
                              onChanged: (s) =>
                                  BlocProvider.of<LoginpageCubit>(context)
                                      .saveData(
                                isCheck: s,
                              ),
                            );
                          },
                        ),
                        Text(
                          'Remember username on this device',
                          style: Theme.of(context).textTheme.caption,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<AuthblcCubit, AuthblcState>(
                      listener: (context, state) {
                        if (state is AuthblcLoginState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Login Successful'),
                            ),
                          );
                          Navigator.of(context)
                              .pushReplacementNamed(wantThisPage);
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthblcLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is AuthblcLoginState) {
                          return ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthblcCubit>(context).logout();
                            },
                            child: const Text('Logout'),
                          );
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(double.infinity, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            BlocProvider.of<AuthblcCubit>(context).login(
                              user: _username.text,
                              pass: _password.text,
                              isSave: isCheck,
                            );
                          },
                          child: const Text(
                            'LOGIN',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WhoCreated(),
    );
  }
}
