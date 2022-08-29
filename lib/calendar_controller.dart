import 'package:get/get.dart';

class CalendarController extends GetxController{
  Rx<DateTime> currentDateTime = DateTime.now().obs;

}