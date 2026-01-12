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
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.blue.shade100),
      ),
      home: const MyHomePage(title: 'Note Pad+'),
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

  myDB db = myDB.getinstance;
  List<Map<String,dynamic>> Notes = [];
  @override
  void initState() {
    
    getData();
    
  }
  
  Future<void> getData() async {
    Notes = await db.GetAllNotes();
  }
  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Notes.isNotEmpty ? ListView.builder(itemBuilder: (context,index){
        return ListTile(title: Text(Notes[index][myDB.TITLE].toString()),subtitle: Text(Notes[index][myDB.DESCRIPTION].toString()),trailing: Text(Notes[index][myDB.SIRIAL_NO].toString()),);
      },itemCount: Notes.length,): Center(child: Text("No note avaiable")),
      floatingActionButton: FloatingActionButton(onPressed: () async {
        bool check = await db.NewNote(title: "Today is the best day forever.", description: "Hellow Bangladesh, today is the best day in our life because in a day we travel in full bangladesh,That's why we are!!");

        if (check){
          setState(() {
            getData();
          });
        }

      },child: Icon(Icons.add),),

    );
  }
}
