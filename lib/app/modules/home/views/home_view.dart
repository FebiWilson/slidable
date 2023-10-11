import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:slidable/app/modules/home/views/Custom_Slidable.dart';
import 'package:slidable/app/modules/home/views/workout_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final textTheme = ThemeData().textTheme;
  final WorkoutLog workoutLog =
      WorkoutLog(id: "id", date: "", day: 9, exerciseArray: [
    WorkoutLogEntry(
        workoutName: "Plank",
        muscleGroup: "Abs",
        warmUpRows: [SetRow(weight: 5, reps: 10)],
        setRows: [SetRow(weight: 5, reps: 15)],
        notes: "")
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          GetBuilder<HomeController>(
            builder: (controller) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: workoutLog.exerciseArray.length,
                itemBuilder: (context, index) {
                  final entry = workoutLog.exerciseArray[index];
                  return _buildWorkoutLogEntryCard(
                    context,
                    entry,
                  );
                },
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 70, vertical: 8)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF485946)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)))),
              onPressed: () {
                // pageController.nextPage(
                //     duration: const Duration(
                //         milliseconds: 200),
                //     curve: Curves.easeOut);
              },
              child: Text(
                "Add Exercise",
                style: textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          )
        ],
      )),
    );
  }

  Widget _buildWorkoutLogEntryCard(
      BuildContext context, WorkoutLogEntry entry) {
    bool isSlidableOpen = false; // To control whether the Slidable is open

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: Colors.white,
      child: GestureDetector(
        // GestureDetector to capture swipe gestures
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            // Swiping right
            isSlidableOpen = true;
            print(true);
          } else if (details.delta.dx < 0) {
            // Swiping left
            isSlidableOpen = false;
            print(false);
          }
          controller.update();
        },
        child: Stack(
          children: [
            if (isSlidableOpen)
              Slidable(
                endActionPane: ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.6,
                  children: [
                    SlidableAction(
                      flex: 1,
                      backgroundColor: Colors.red,
                      onPressed: (context) {
                        // Handle action
                      },
                      icon: Icons.delete,
                    ),
                  ],
                ),
                child:
                    Container(), // You can use an empty container as the child
              ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 5),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                entry.workoutName,
                                overflow: TextOverflow.visible,
                                textAlign: TextAlign.left,
                                style: textTheme.headlineMedium!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      FontAwesomeIcons.arrowLeft,
                      size: 15,
                    )
                  ],
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Handle button tap
                        },
                        child: Text(
                          "+ Warm Up",
                          style: textTheme.headlineMedium!.copyWith(
                            color: Color(0xFF485946),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    color: Colors.grey,
                    height: 1.0,
                    thickness: 0.25,
                  ),
                  _buildWarmUpList(context, entry.warmUpRows, entry, true),
                  _buildWarmUpList(context, entry.setRows, entry, false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWarmUpList(BuildContext context, List<SetRow> rows,
      WorkoutLogEntry entry, bool isWarmUp) {
    bool isSlidableOpen = true;
    return GetBuilder<HomeController>(
      builder: (controller) {
        List<TextEditingController> _weightcontrollers =
            <TextEditingController>[];
        List<TextEditingController> _repcontrollers = <TextEditingController>[];
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows.length,
          itemBuilder: (context, index) {
            SetRow row = rows[index];
            _weightcontrollers.add(TextEditingController(
                text: row.weight.toStringAsFixed(1).endsWith("0")
                    ? row.weight.toStringAsFixed(0)
                    : row.weight.toStringAsFixed(1)));
            _repcontrollers
                .add(TextEditingController(text: row.reps.toString()));

            return GestureDetector(
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0) {
                  // Swiping right
                  isSlidableOpen = true;
                  print("true");
                } else if (details.delta.dx < 0) {
                  // Swiping left
                  isSlidableOpen = false;
                  print("false");
                }
                controller.update();
              },
              child: Stack(
                children: [Slidable(
                  enabled: false,
                  startActionPane: null,
                  endActionPane: ActionPane(
                    motion: const StretchMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        onPressed: (context) {
                          // isWarmUp
                          //     ? controller.deleteWarmUpRow(entry, index)
                          //     : controller.deleteSetRow(entry, index);
                        },
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        minVerticalPadding: 0,
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                            padding: const EdgeInsets.all(8.0),
                            width: 35,
                            height: 35,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(2, 2),
                                    blurRadius: 10.0),
                              ],
                            ),
                            child: isWarmUp
                                ? ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                        Colors.black, BlendMode.srcIn),
                                    child: Image.asset(
                                      'assets/stretch.png',
                                      height: 15,
                                      width: 15,
                                    ))
                                : Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: textTheme.headlineMedium!.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))),
                        title: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(2, 2),
                                  blurRadius: 10.0),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                const SizedBox(width: 30.0),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              isDense: true, suffixText: 'kg'),
                                          controller: _weightcontrollers[index],
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.end,
                                          onTap: () {
                                            _weightcontrollers[index].selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        _weightcontrollers[index]
                                                            .value
                                                            .text
                                                            .length);
                                          },
                                          onChanged: (value) {
                                            // controller.updateWeight(
                                            //     row, double.tryParse(value) ?? 0);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30.0),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            suffixText:
                                                entry.isUnitInSecs ? 's' : 'reps',
                                          ),
                                          controller: _repcontrollers[index],
                                          onTap: () {
                                            _repcontrollers[index].selection =
                                                TextSelection(
                                                    baseOffset: 0,
                                                    extentOffset:
                                                        _repcontrollers[index]
                                                            .value
                                                            .text
                                                            .length);
                                          },
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.right,
                                          onChanged: (value) {
                                            // controller.updateReps(
                                            //     row, int.tryParse(value) ?? 0);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 30.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.grey,
                        height: 1.0,
                        thickness: 0.25,
                      ),
                    ],
                  ),
                ),
              ]),
            );
          },
        );
      },
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({
    Key? key,
    required this.workoutLogEntry,
    required this.note,
  }) : super(key: key);
  final WorkoutLogEntry workoutLogEntry;
  final String note;
  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _workoutNoteController = TextEditingController();
  final controller = Get.find<HomeController>();
  @override
  void initState() {
    super.initState();
    _workoutNoteController = TextEditingController(text: widget.note);
  }

  @override
  void dispose() {
    _workoutNoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      surfaceTintColor: Colors.white,
      content: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                textInputAction: TextInputAction.done,
                controller: _workoutNoteController,
                maxLength: 200,
                maxLines: null,
                autofocus: widget.note != "" ? false : true,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Workout Note',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a workout note.';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // controller.updateNote(
              //     widget.workoutLogEntry, _workoutNoteController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
