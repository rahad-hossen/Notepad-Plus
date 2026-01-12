
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class myDB{

  myDB._();
  static final myDB getinstance = myDB._();
  static final String DB_TABLE = 'NoteTable';
  static final String TITLE = 'title';
  static final String DESCRIPTION = 'description';
  static String SIRIAL_NO = "sirial_no";


  Database? PersonalNOTE;

  Future<Database?> getDB() async{
    if(PersonalNOTE!= null){
      return await PersonalNOTE;
    }else{
      return await openDB();
    }
  }

  Future<Database> openDB() async {
    Directory Path = await getApplicationDocumentsDirectory();
    String DBPath = join(Path.path, "Note.db");
    return await openDatabase(DBPath, onCreate: (db, version){
      db.execute('create table $DB_TABLE($SIRIAL_NO integer primary key autoincrement, $TITLE text, $DESCRIPTION text)');

    },version: 1);

  }

  Future<bool> NewNote({required String title,required String description}) async {

    var db = await getDB();

    int ifTrue = await db!.insert(DB_TABLE, {TITLE : title, DESCRIPTION : description});
    return ifTrue>0;

  }

  Future<List<Map<String,dynamic>>> GetAllNotes() async {
    var db = await getDB();
    List<Map<String,dynamic>> allData = await db!.query(DB_TABLE);
    return allData;
  }

  Future<bool> UpdateNote({required String title,required String description,required String SirialNo}) async {
    
    var db = await getDB();
    int workable = await db!.update(DB_TABLE, {

      TITLE : title,
      DESCRIPTION : description
    },where: "SIRIAL_NO = ?",whereArgs: [SirialNo]);
    return workable > 0;
  }

  Future<bool> DeleteNote({required String sirialNo}) async {
    var db = await getDB();

    int isDeleted = await db!.delete(DB_TABLE , where: "SIRIAL_NO = ?",whereArgs: [sirialNo]);


    return isDeleted>0;

  }




}





