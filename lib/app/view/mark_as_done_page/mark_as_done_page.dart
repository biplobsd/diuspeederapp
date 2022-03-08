import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:diuspeeder/app/view/mark_as_done_page/cubit/markasdone_cubit.dart';
import 'package:diuspeeder/core/auth_BLC/cubit/authblc_cubit.dart';
import 'package:diuspeeder/core/auth_BLC/model/course_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';

class MarkAsDonePage extends StatelessWidget {
  const MarkAsDonePage({Key? key}) : super(key: key);
  static const String pathName = '/markAsDonePage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MarkasdoneCubit(
        authblcCubit: BlocProvider.of<AuthblcCubit>(context),
      ),
      child: const MarkAsDoneScreen(),
    );
  }
}

class MarkAsDoneScreen extends StatefulWidget {
  const MarkAsDoneScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MarkAsDoneScreen> createState() => _MarkAsDoneScreenState();
}

class _MarkAsDoneScreenState extends State<MarkAsDoneScreen> {
  Future<void> dialogHelpInfo({
    required BuildContext context,
    required String title,
    required String helpImgPath,
  }) async {
    await showDialog<dynamic>(
      context: context,
      builder: (cnt) => AlertDialog(
        title: Text(title),
        content: InteractiveViewer(
          panEnabled: false,
          minScale: 0.5,
          maxScale: 1,
          child: Image.asset(
            helpImgPath,
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
            child: const Text('Okay'),
          )
        ],
      ),
    );
  }

  late String? value = null;
  Map<String, dynamic>? data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('Mark as done'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
                builder: (context, state) {
                  if (state is MarkasdoneGettingDataState) {
                    return const Text('Getting enrolled course data');
                  }
                  return DropdownButton(
                    icon: IconButton(
                      icon: const Icon(Icons.cached_sharp),
                      onPressed: () {
                        BlocProvider.of<MarkasdoneCubit>(context)
                            .refresh(value);
                      },
                    ),
                    hint: const Text('Select Course'),
                    isExpanded: true,
                    value: value,
                    items: BlocProvider.of<MarkasdoneCubit>(context)
                        .course
                        .map<DropdownMenuItem<String>>((CourseData value) {
                      return DropdownMenuItem<String>(
                        value: value.id.toString(),
                        child: Text(
                          value.fullname,
                          maxLines: 1,
                          style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (v) {
                      value = v.toString();
                      setState(() {
                        BlocProvider.of<MarkasdoneCubit>(context)
                            .gettingDoneButtons(value.toString());
                      });
                    },
                  );
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
                  builder: (context, state) {
                    if (state is MarkasdoneSelectedState) {
                      var perc = BlocProvider.of<MarkasdoneCubit>(context)
                          .getProgressBarValue();
                      if (perc.isNaN) {
                        perc = 0;
                      }
                      return GFProgressBar(
                        animateFromLastPercentage: true,
                        animation: true,
                        lineHeight: 20,
                        alignment: MainAxisAlignment.spaceBetween,
                        percentage: perc,
                        backgroundColor: Colors.black26,
                        progressBarColor: GFColors.INFO,
                        child: Text(
                          '${(perc * 100).toStringAsFixed(0)}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white54),
                        ),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                height: MediaQuery.of(context).size.height * .55,
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: SingleChildScrollView(
                  child: BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
                    builder: (context, state) {
                      data =
                          BlocProvider.of<MarkasdoneCubit>(context).markButtons;
                      if (state is MarkasdoneGettingButtonsState) {
                        return const Text('Getting cmid buttons.');
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (data != null)
                            ...data!['markButtons'].map(
                              (Map<String, dynamic> e) => TextButton.icon(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(
                                    (e['isMarkDone'] as bool)
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    BlocProvider.of<MarkasdoneCubit>(context)
                                        .markAsDone(
                                      data!['sesskey'].toString(),
                                      e['cmid'].toString(),
                                      value!,
                                      !(e['isMarkDone'] as bool),
                                    );
                                    data;
                                  });
                                },
                                icon: (e['isMarkDone'] as bool)
                                    ? const Icon(Icons.check_circle)
                                    : const Icon(Icons.cancel),
                                label: Text(
                                  '${e["cmid"]} | ${e["title"]}',
                                  maxLines: 1,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.infinity, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          onPressed: () {
            BlocProvider.of<MarkasdoneCubit>(context).markAll();
          },
          child: const Text('Mark as Done'),
        ),
      ),
    );
  }
}
