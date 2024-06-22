import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:try_hive/Model/boxes.dart';
import 'package:try_hive/Model/notepaddata.dart';
import 'package:try_hive/Screens/data_manipulation/edit.dart';
import 'package:try_hive/controllers/theme_controller.dart';
import 'package:try_hive/controllers/todo_controller.dart';
import 'package:try_hive/services/theme/colors.dart';

class NotesDisplayWidget extends StatelessWidget {
  NotesDisplayWidget({super.key, required this.todoController});
  final controller = Get.put(TodoController());
  final ThemeController themeController = Get.put(ThemeController());

  final TodoController todoController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ValueListenableBuilder<Box<NotePadData>>(
        valueListenable: Boxes.getNotePadData().listenable(),
        builder: (context, box, _){
          final notedata = box.values.toList();
          return ListView(
            children: [
              ...List.generate(notedata.length, (index) => GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesEdit(npd: notedata[index]))
                  );
                },
                onLongPress: (){
                  controller.addToSelected(notedata[index]);
                },
                child: Container(
                  color: controller.isPresent(notedata[index].key) ? Colors.transparent : Colors.red.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Obx(
                      () => Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.85,
                        ),
                        decoration: BoxDecoration(
                          color: CustomColors.lightGrey.value,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(-2, -2),
                              color: CustomColors.upperShadow.value,
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              offset: const Offset(2, 2),
                              color: CustomColors.lowerShadow.value,
                              blurRadius: 5,
                            ),
                          ]
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notedata[index].title != "" ? notedata[index].title.toString() : notedata[index].note.toString(),
                                style: TextStyle(
                                  fontFamily: "Rancho",
                                  fontSize: 20,
                                  letterSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.textColor.value,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Visibility(
                                visible: notedata[index].title != "",
                                child: Text(
                                  notedata[index].note.toString().split("\n").first.trimRight(),
                                  style: TextStyle(
                                    fontFamily: "Rancho",
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                    color: CustomColors.lightTextColor.value,
                                  ),
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              const SizedBox(height: 7),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  todoController.dateFormat(notedata[index].createdAt),
                                  style: TextStyle(
                                    fontFamily: "Rancho", 
                                    fontSize: 13,
                                    letterSpacing: 1.2,
                                    color: CustomColors.grey.value.withOpacity(.75),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
            ],
          );
        }
      ),
    );
  }
}