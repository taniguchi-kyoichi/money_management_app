import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_management_app/Model/db_data.dart';

class PriceLogic {



 int subtract(List<TodoItem> todoList) {



   int _todoListSum = 0;
   int result = 0;
   for (var todo in todoList) {
     _todoListSum += todo.price;
   }

   if (result < 0) {
     return -1;
   }

   return result;
 }



}