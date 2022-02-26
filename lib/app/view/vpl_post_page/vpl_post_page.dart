import 'dart:async';
import 'dart:io';

import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:diuspeeder/app/view/vpl_post_page/cubit/vplp_cubit.dart';
import 'package:diuspeeder/auth_BLC/cubit/authblc_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';

class VPLPostPage extends StatelessWidget {
  VPLPostPage({Key? key}) : super(key: key);
  static const pathName = '/vpl_post';

  final TextEditingController pidController = TextEditingController();
  final TextEditingController senddataController = TextEditingController();
  final TextEditingController fileNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VplpCubit(),
      child: VPLPostScreen(
        pidController: pidController,
        fileNameController: fileNameController,
        senddataController: senddataController,
      ),
    );
  }
}

class VPLPostScreen extends StatelessWidget {
  const VPLPostScreen({
    Key? key,
    required this.pidController,
    required this.fileNameController,
    required this.senddataController,
  }) : super(key: key);

  final TextEditingController pidController;
  final TextEditingController fileNameController;
  final TextEditingController senddataController;

  Future<void> selectFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;

    final path = result.files.single.path!;
    try {
      senddataController.text = File(path).readAsStringSync();
      fileNameController.text = basename(path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('VPL posting'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<VplpCubit, VplpState>(
                builder: (context, state) {
                  return TextField(
                    style: Theme.of(context).textTheme.subtitle1,
                    controller: pidController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      errorText: state is VplpostPageIdEmptyState
                          ? 'Page id is required.'
                          : null,
                      filled: true,
                      labelStyle: const TextStyle(height: 4),
                      border:
                          const OutlineInputBorder(borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          showDialog<dynamic>(
                            context: context,
                            builder: (cnt) => AlertDialog(
                              title: const Text('Getting page ID'),
                              content: InteractiveViewer(
                                panEnabled: false,
                                minScale: 0.5,
                                maxScale: 1,
                                child: Image.asset(
                                  'assets/vplcopypageid.gif',
                                  width: 350,
                                  height: 350,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(cnt).pop();
                                  },
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      label: const Text('Page ID'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: fileNameController,
                style: Theme.of(context).textTheme.subtitle1,
                decoration: const InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  labelStyle: TextStyle(height: 3.5),
                  label: Text('File Name (optional)'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton.icon(
                onPressed: () {
                  selectFile(context);
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Choose a file'),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .5,
                child: BlocBuilder<VplpCubit, VplpState>(
                  builder: (context, state) {
                    return TextField(
                      textAlignVertical: TextAlignVertical.top,
                      expands: true,
                      controller: senddataController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        errorText: state is VplpostCodeFieldEmptyState
                            ? 'Code field is emtpy'
                            : null,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelStyle: const TextStyle(
                          height: 3.5,
                        ),
                        label: const Text('Input your text/code'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BlocConsumer<VplpCubit, VplpState>(
        listener: (context, state) {
          if (state is VplpostSuccessState) {
            showDialog<dynamic>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Success'),
                content: Lottie.asset(
                  'assets/lotties/64787-success.json',
                  height: 300,
                  width: 300,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Okay',
                    ),
                  ),
                ],
              ),
            );
          } else if (state is VplpostunsuccessState) {
            showDialog<dynamic>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Unsuccess'),
                content: Lottie.asset(
                  'assets/lotties/31490-no-connection.json',
                  height: 300,
                  width: 300,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Okay',
                    ),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is VplpLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();

                if (pidController.text.isEmpty) {
                  BlocProvider.of<VplpCubit>(context)
                      .setErrorPageId(VplpostPageIdEmptyState());
                  return;
                } else if (senddataController.text.isEmpty) {
                  BlocProvider.of<VplpCubit>(context)
                      .setErrorPageId(VplpostCodeFieldEmptyState());
                  return;
                }

                late String parsePageId;

                parsePageId = int.parse(
                  pidController.text,
                  onError: (source) {
                    return int.parse(
                      Uri.parse(pidController.text).queryParameters['id']!,
                    );
                  },
                ).toString();
                pidController.text = parsePageId;

                BlocProvider.of<VplpCubit>(context).setLoadingState();
                BlocProvider.of<AuthblcCubit>(context)
                    .vplPosting(
                      parsePageId,
                      fileNameController.text,
                      senddataController.text,
                    )
                    .then(
                      (value) => BlocProvider.of<VplpCubit>(context)
                          .postSuccess(result: value),
                    );
              },
              child: const Text('Upload'),
            ),
          );
        },
      ),
    );
  }
}
