import 'package:databse/local_db.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NotePad',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue.shade100)),
      home: const MyHomePage(title: 'Notepad-Plus'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController TitleIn = TextEditingController();
  TextEditingController DescriptIn = TextEditingController();
  myDB db = myDB.getinstance;
  List<Map<String, dynamic>> Notes = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    var Notes_ = await db.GetAllNotes();
    setState(() {
      Notes = Notes_;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Notes.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(Notes[index][myDB.TITLE].toString()),
                  subtitle: Text(Notes[index][myDB.DESCRIPTION].toString()),
                  trailing: Column(
                    children: [
                      InkWell(
                          child: Icon(Icons.edit),
                        onTap: (){

                            TitleIn.text = Notes[index][myDB.TITLE].toString();
                            DescriptIn.text = Notes[index][myDB.DESCRIPTION].toString();


                          showModalBottomSheet(
                            context: context,
                            builder: (contex) {
                              return getBottomSheet(false,index);
                            },
                          );
                        },
                      ),
                      InkWell(
                        child: Icon(Icons.delete),
                        onTap: () async {

                          bool isDeleted = await db.DeleteNote(sirialNo: Notes[index][myDB.SIRIAL_NO].toString());
                          if (isDeleted){
                            getData();
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text("Note Deleted Successfully"))
                            // );
                          }

                        },
                      ),
                    ],
                  ),
                  leading:Text(Notes[index][myDB.SIRIAL_NO].toString()),
                );
              },
              itemCount: Notes.length,
            )
          : Center(child: Text("No note avaiable")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          showModalBottomSheet(
            context: context,
            builder: (contex) {
              return getBottomSheet(true,0);
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget getBottomSheet(bool isEdit, int index){
    return Padding(
      padding: EdgeInsets.only(left: 50,right: 50),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 20),
            isEdit ? Text(
              "Add Note",
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ): Text(
              "Edit Note",
              style: TextStyle(
                fontSize: 30,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: double.infinity,
              child: TextField(
                controller: TitleIn,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: isEdit?  Text("Write your title.."):Text("Update your title.."),
                  label: Text('Title'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: TextField(
                controller: DescriptIn,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hint: isEdit? Text("Write your description.."):Text("Update your description..") ,
                  label: Text('Description'),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child:OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel',style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)
                      ),

                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child:OutlinedButton(
                    onPressed: () async {
                      String Title = TitleIn.text.toString();
                      String DesIn = DescriptIn.text.toString();
                      bool check;
                      if (isEdit){
                        check = await db.NewNote(title: Title.isNotEmpty?Title:"Empty Added", description: DesIn.isNotEmpty?DesIn:"Empty des Added");
                      }else{
                        check = await db.UpdateNote(title: Title, description: DesIn, SirialNo: Notes[index][myDB.SIRIAL_NO].toString());
                      }

                      if (check){

                        setState(() {
                          getData();
                        });
                        TitleIn.clear();
                        DescriptIn.clear();
                      }

                    },
                    child: isEdit ? Text('Insert',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),):Text('Update',style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(10)
                      ),

                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }



}
