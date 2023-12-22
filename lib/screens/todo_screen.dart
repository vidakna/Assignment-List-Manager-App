import 'package:assignment_list/models/notes.dart';
import 'package:assignment_list/services/notes_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/category_service.dart';
import 'package:assignment_list/screens/home_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
   var _noteService=noteService()  ;
   List<Note> _noteList=<Note>[];
  var _todoTitleController =TextEditingController();
  
  var _todoDescriptionController=TextEditingController();
  
  var _todoDateController=TextEditingController();
  
  var _selectedValue;
  
  var _categories =<DropdownMenuItem>[];
  final GlobalKey<ScaffoldState> _globalKey=GlobalKey<ScaffoldState>();

@override
void initState(){

  super.initState();
  _loadCategories();
  getAllNotes();
}
getAllNotes() async{
    _noteService=noteService();
    _noteList=<Note>[];

    var notes= await _noteService.readNotes();

   notes.forEach((note){
    setState(() {
      var model=Note();
      model.id=note['id'];
      model.title=note['title'];
      model.description=note['description'];
      model.category=note['category'];
      model.todoDate=note['todoDate'];
      model.isFinished=note['isFinished'];
      _noteList.add(model);

    });
   });

   }
  _loadCategories() async{
    var _categoryService=CategoryService();
    var categories =await _categoryService.readCategories();
    categories.forEach((category){
     setState(() {
       _categories.add(DropdownMenuItem(
        child: Text(category['name']),
        value:category['name'],
       ));
     });
    });
  }
  DateTime _dateTime=DateTime.now();

  _selectedTodoDate(BuildContext context) async{
    var _pickedDate =await showDatePicker(
      context: context, initialDate: _dateTime, firstDate: DateTime(2000), lastDate: DateTime(2100));

      if(_pickedDate!=null){
        setState(() {
          _dateTime=_pickedDate;
          _todoDateController.text=DateFormat('yyyy-MM-dd').format(_pickedDate);
        });
      }
  }
  _showSuccessSnakBar(message){
    var _snackBar = SnackBar(content: message);
     ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
             backgroundColor: Color.fromARGB(255, 147, 198, 240),

      key: _globalKey,
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 16, 10, 56),
       title: Text('Create Your Note'),
      ),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        
        child: Column(
          children:<Widget>[
            TextField(
              controller:_todoTitleController,
              decoration:InputDecoration(
                labelText: 'Title',
                hintText: 'Write work Title',
              ) ,
            ),
            TextField(
              controller:_todoDescriptionController,
              decoration:InputDecoration(
                labelText: 'Description',
                hintText: 'Write Note Description',
              ) ,
            ),
            TextField(
              controller:_todoDateController,
              decoration:InputDecoration(
                labelText: 'Date',
                hintText: 'Pick a date',
                prefixIcon: InkWell(
                  onTap: (){
                    _selectedTodoDate(context);
                  },
                  child: Icon(Icons.calendar_today),
                )
              ) ,
            ),
            DropdownButtonFormField(
              value:_selectedValue,
              items:_categories,
              hint:Text('Category'),
              onChanged:(value){
                setState(() {
                  _selectedValue=value;
                });
              }
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
             style: ElevatedButton.styleFrom(
    // background
             onPrimary: Colors.black, // foreground
        ),
     onPressed: () async{ 
      var todoObject=Note();

      todoObject.title=_todoTitleController.text;
       todoObject.description=_todoDescriptionController.text;
        todoObject.isFinished=0;
         todoObject.category=_selectedValue.toString();
          todoObject.todoDate=_todoDateController.text;
        
        var _noteService=noteService();
        var result=await _noteService.saveNotes(todoObject);
         
        if(result>0){
          _showSuccessSnakBar(Text('Save'));
           getAllNotes();
           // _loadCategories();
           Navigator.pop(context);
          // getAllCategories();
        } 
         
        print(result);
     },
     child: Text('Save',style: TextStyle(color:Colors.white),),
     ),
     
          ]
        ),
      )
    );
  }
}