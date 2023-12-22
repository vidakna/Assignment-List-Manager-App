import 'package:assignment_list/screens/notes_by_category.dart';
import 'package:assignment_list/services/category_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../screens/categories_screen.dart';
import '../screens/home_screen.dart';

class DrawerNavigaton extends StatefulWidget {
  @override
  _DrawerNavigatonState createState() => _DrawerNavigatonState();
}

class _DrawerNavigatonState extends State<DrawerNavigaton> {
  List<Widget> _categoryList=<Widget>[];
  CategoryService _categoryService=CategoryService();

@override
initState(){
  super.initState();
  getAllCategories();
}
  getAllCategories() async{
    var categories=await _categoryService.readCategories();

    categories.forEach((category){
      setState(() {
       
        _categoryList.add(InkWell(
          onTap: (() => Navigator.push(context, new MaterialPageRoute(builder: (context)=>new NotesByCategory(category:category ['name'],)))),
          child: ListTile(
           title: Text(category['name']),
          ),
        ));
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
     
      child: Drawer(
        child: ListView(
          
          children: <Widget>[
             SizedBox(
             // height: 230,
      //          child: DrawerHeader(
      //           child: Text('Recipe Keeper',style: TextStyle(color:Colors.white)),
      //            decoration: const BoxDecoration(
      //   image: DecorationImage(
      //     image: NetworkImage(
      //       'https://m.media-amazon.com/images/I/81VdUdc2aKL.png'
      //       ),
      //       fit: BoxFit.fill,
      //       ),
      // ),
      //          ),
             ),
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                // backgroundImage: NetworkImage(
                //     'https://toppng.com/uploads/preview/user-account-management-logo-user-icon-11562867145a56rus2zwu.png'),
              ),
              
              accountName: Text('Tharindu Maduranga'),
              accountEmail: Text('madurangairugalbandara@gmail.com'),
              decoration: BoxDecoration(color: Color.fromARGB(255, 2, 38, 68)),
            ),
            
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen())),
            ),
            ListTile(
              leading: Icon(Icons.view_list),
              title: Text('categories'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CategoriesScreen())),
            ),
            Divider(),
            Column(
              children: _categoryList,
            )
          ],
        ),
      ),
    );
  }
}
