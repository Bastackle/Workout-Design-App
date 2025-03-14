import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addForm extends StatefulWidget {
  const addForm({super.key});

  @override
  State<addForm> createState() => _addFormState();
}

class _addFormState extends State<addForm> {
  final activityController = TextEditingController();
  final timeController = TextEditingController();
  final calController = TextEditingController();

  CollectionReference workoutCollection = 
      FirebaseFirestore.instance.collection('Workout');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF303030),
        title: Text(
          'Add a Workout',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF303030),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'New Workout', style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),),
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: activityController,
                      autofocus: true,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Add a Workout's Name",
                        hintStyle: TextStyle(
                            color: Colors.white70
                        ),
                        icon: Icon(Icons.title, color: Colors.white,),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: timeController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Time',
                              hintStyle: TextStyle(
                                color: Colors.white70
                              ),
                              icon: Icon(Icons.timelapse, color: Colors.white,)
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text('minutes', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: calController,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Calories Burned',
                                hintStyle: TextStyle(
                                    color: Colors.white70
                                ),
                                icon: Icon(Icons.local_fire_department, color: Colors.white,)
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text('calories', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    SizedBox(height: 30,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (){
                            workoutCollection.add({
                              'activity': activityController.text,
                              'time': timeController.text,
                              'calories': calController.text
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF607D8B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)
                            )
                          ),
                          child: Text('Add', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white
                          ),)
                      ),
                    )
                  ],
                )
            ),
          ),
        ),
      ),
    );
  }
}
