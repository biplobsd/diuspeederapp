import 'package:diuspeeder/app/appbar_custom.dart';
import 'package:diuspeeder/app/view/mark_as_done_page/cubit/markasdone_cubit.dart';
import 'package:diuspeeder/core/auth_BLC/cubit/authblc_cubit.dart';
import 'package:diuspeeder/core/auth_BLC/model/course_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:lottie/lottie.dart';

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

class MarkAsDoneScreen extends StatelessWidget {
  const MarkAsDoneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? value;
    Map<String, dynamic>? data;
    return Scaffold(
      appBar: const MyAppbar(
        title: Text('Mark as done'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: BlocConsumer<MarkasdoneCubit, MarkasdoneState>(
                    listener: (context, state) {
                      if (state is MarkasdoneIdealState) {
                        var courseId = BlocProvider.of<MarkasdoneCubit>(context)
                            .course[0]
                            .id
                            .toString();
                        value = courseId;
                        BlocProvider.of<MarkasdoneCubit>(context)
                            .gettingDoneButtons(courseId);
                      }
                    },
                    builder: (context, state) {
                      return DropdownButton(
                        icon: IconButton(
                          icon: Lottie.asset(
                            'assets/lotties/loadingGet.json',
                            animate: state is MarkasdoneGettingDataState,
                          ),
                          onPressed: state is MarkasdoneLoadingState
                              ? null
                              : () {
                                  BlocProvider.of<MarkasdoneCubit>(context)
                                      .refresh(value);
                                },
                        ),
                        hint: Text(
                          state is MarkasdoneGettingDataState
                              ? 'Fetching recent courses...'
                              : 'Select Course',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        isExpanded: true,
                        value: value,
                        items: state is MarkasdoneGettingDataState
                            ? null
                            : BlocProvider.of<MarkasdoneCubit>(context)
                                .course
                                .map<DropdownMenuItem<String>>(
                                    (CourseData value) {
                                return DropdownMenuItem<String>(
                                  value: value.id.toString(),
                                  child: Text(
                                    value.fullname,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                  ),
                                );
                              }).toList(),
                        onChanged: state is MarkasdoneLoadingState
                            ? null
                            : (v) {
                                value = v.toString();

                                BlocProvider.of<MarkasdoneCubit>(context)
                                    .gettingDoneButtons(value.toString());
                              },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
                  builder: (context, state) {
                    if (state is MarkasdoneLoadingState ||
                        state is MarkasdoneMarkState ||
                        state is MarkasdoneUnmarkState) {
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
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${(perc * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: 20,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                height: MediaQuery.of(context).size.height * .61,
                decoration: BoxDecoration(
                  color: Theme.of(context).hoverColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.topRight,
                child: BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
                  builder: (context, state) {
                    if (state is MarkasdoneGettingButtonsState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    data =
                        BlocProvider.of<MarkasdoneCubit>(context).markButtons;
                    if (data == null) {
                      return Container();
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data!['markButtons'].length as int,
                      itemBuilder: (BuildContext ctx, int index) {
                        final e =
                            data!['markButtons'][index] as Map<String, dynamic>;
                        return TextButton.icon(
                          style: ButtonStyle(
                            alignment: Alignment.centerLeft,
                            foregroundColor: MaterialStateProperty.all(
                              (e['isMarkDone'] as bool)
                                  ? Colors.lightBlue
                                  : Colors.red,
                            ),
                          ),
                          onPressed: () {
                            BlocProvider.of<MarkasdoneCubit>(context)
                                .markAsDone(
                              data!['sesskey'].toString(),
                              e['cmid'].toString(),
                              value!,
                              !(e['isMarkDone'] as bool),
                            );
                          },
                          icon: (e['isSending'] as bool)
                              ? const Icon(Icons.cached_sharp)
                              : (e['isMarkDone'] as bool)
                                  ? const Icon(Icons.check_circle)
                                  : const Icon(Icons.cancel),
                          label: Text(
                            '${e["cmid"]} | ${e["title"]}',
                            maxLines: 1,
                            style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<MarkasdoneCubit, MarkasdoneState>(
          builder: (context, state) {
            var buttonText = 'Mark as Done';
            if (state is MarkasdoneLoadingState) {
              buttonText = 'Touching...';
            } else if (state is MarkasdoneMarkState) {
              buttonText = 'Unmark';
            }

            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: state is MarkasdoneLoadingState ||
                      state is MarkasdoneGettingDataState ||
                      state is MarkasdoneGettingButtonsState
                  ? null
                  : () {
                      BlocProvider.of<MarkasdoneCubit>(context).markAll();
                    },
              child: Text(
                buttonText,
              ),
            );
          },
        ),
      ),
    );
  }
}
