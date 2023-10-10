
class WorkoutLog {
  String id;
  String date;
  int? day;
  List<WorkoutLogEntry> exerciseArray;
  WorkoutLog({
    required this.id,
    required this.date,
    required this.day,
    required this.exerciseArray,
  });

  // factory WorkoutLog.fromPlan(WorkoutDay day, DateTime selectedTime) {
  //   return WorkoutLog(
  //       id: profileInfoProvider.profileInfo["_id"],
  //       date: formatDate(selectedTime),
  //       day: int.parse(day.name.substring(4)),
  //       exerciseArray: parseWorkoutDay(day));
  // }

  // static List<WorkoutLogEntry> parseWorkoutDay(WorkoutDay day) {
  //   List<WorkoutLogEntry> exerciseArray = [];
  //   exerciseArray.addAll(day.warmupExercises.map((e) => WorkoutLogEntry.fromExercise(e, true)).toList());
  //   exerciseArray.addAll(day.workoutExercises.map((e) => WorkoutLogEntry.fromExercise(e, false)).toList());
  //   exerciseArray.addAll(day.cooldownExercises.map((e) => WorkoutLogEntry.fromExercise(e, true)).toList());
  //   return exerciseArray;
  // }

  factory WorkoutLog.fromJson(Map<String, dynamic> json) {
    return WorkoutLog(
        id: json["user"],
        date: json["date"],
        // Handle backward compatibility with backend
        day: json["day"] != null ? json["day"] is String ? 9: json["day"]: 9,
        exerciseArray: parseExerciseArray(json["exerciseArray"]));
  }
  factory WorkoutLog.fromJsonLastWeek(Map<String, dynamic> json, String date) {
    return WorkoutLog(
        id: json["user"],
        date: date,
        day: json["day"] ?? 9,
        exerciseArray: parseExerciseArray(json["exerciseArray"]));
  }

  static List<WorkoutLogEntry> parseExerciseArray(List<dynamic> exerciseArray) {
    if (exerciseArray.isEmpty) {
      return [];
    }
    return exerciseArray
        .map<WorkoutLogEntry>((json) => WorkoutLogEntry.fromJson(json))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "date": date,
      "day": day ?? 9,
      "exerciseArray": exerciseArray.map((e) => e.toJson()).toList(),
    };
  }
}

class WorkoutLogEntry {
  final String workoutName;
  List<SetRow> warmUpRows = [];
  List<SetRow> setRows = [];
  String muscleGroup;
  String notes;
  bool isUnitInSecs;

  WorkoutLogEntry({
    required this.workoutName,
    required this.muscleGroup,
    required this.warmUpRows,
    required this.setRows,
    required this.notes,
    this.isUnitInSecs = true,
  });

  // factory WorkoutLogEntry.fromExercise(Exercise exercise, bool isWarmUp) {
  //   return WorkoutLogEntry(
  //       workoutName: exercise.name,
  //       muscleGroup: "Abs",
  //       warmUpRows: isWarmUp ? generateSetRows(exercise.sets, exercise.reps) : [],
  //       setRows: isWarmUp ? [] : generateSetRows(exercise.sets, exercise.reps),
  //       notes: "",
  //       isUnitInSecs: checkIsReps(exercise.reps));
  // }

  static List<SetRow> generateSetRows(int sets, String reps) {
    List<SetRow> setArray = [];
    String rep = reps.split(' ')[0];
    if(reps.endsWith('reps')) { 
      rep = rep.split('-')[1];
    }
    int repCount = int.tryParse(rep) != null ? int.parse(rep) : 0;
    for (int i = 0; i < sets; ++i) {
      setArray.add(SetRow(weight: 0, reps: repCount));
    }
    return setArray;
  }

  static bool checkIsReps(String reps) {
    if (reps.endsWith("reps")) {
      return false;
    } else {
      return true;
    }
  }

  factory WorkoutLogEntry.fromJson(Map<String, dynamic> json) {
    return WorkoutLogEntry(
      workoutName: json["name"],
      muscleGroup: json["muscleGroup"] == null ? "Abs" : json["muscleGroup"],
      warmUpRows: parseLogEntry(json["warmupSets"]),
      setRows: parseLogEntry(json["sets"]),
      notes: json["notes"],
      isUnitInSecs: json["IsUnitInSecs"] == null ? false : json["IsUnitInSecs"],
    );
  }

  static List<SetRow> parseLogEntry(List<dynamic> setRows) {
    if (setRows.isEmpty) {
      return [];
    }
    return setRows.map<SetRow>((json) => SetRow.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "name": workoutName,
      "muscleGroup": muscleGroup,
      "sets": setRows.map((e) => e.toJson()).toList(),
      "warmupSets": warmUpRows.map((e) => e.toJson()).toList(),
      "notes": notes,
      "IsUnitInSecs": isUnitInSecs,
      "videoLink": "videolink",
    };
  }
}

class SetRow {
  double weight;
  int reps;

  SetRow({
    required this.weight,
    required this.reps,
  });

  factory SetRow.fromJson(Map<String, dynamic> json) {
    return SetRow(
        weight:
            json["weight"] is int ? json["weight"].toDouble() : json["weight"],
        reps: json["reps"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "weight": weight,
      "reps": reps,
    };
  }
}
