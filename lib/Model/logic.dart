import 'package:money_management_app/Model/db_data.dart';

class PriceLogic {



 int subtract(int sum, List<TodoItem> todoList) {
   int _todoListSum = 0;
   int result = 0;
   for (var todo in todoList) {
     _todoListSum += todo.price;
   }

   result = sum - _todoListSum;
   if (result < 0) {
     return -1;
   }

   return result;
 }

}