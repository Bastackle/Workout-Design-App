import 'package:exercise/addForm.dart';
import 'package:exercise/updateForm.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int screenIndex = 0;
  final mobileScreen = [
    home(),
    search(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'WorkOut APP',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
          centerTitle: true,
          elevation: 4,
          backgroundColor: const Color(0xFF37474F),
        ),
      body: mobileScreen[screenIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            screenIndex = 0;
          });
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => addForm()))
              .then((_) {
                setState(() {
                  screenIndex = 0;
                });
          });
        },
        shape: const CircleBorder(),
        elevation: 6,
        backgroundColor: const Color(0xFF607D8B),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: const Color(0xFF455A64), // น้ำเงินเทาอ่อน
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 0),
              _buildNavItem(Icons.search, 1),
              const SizedBox(width: 48), // Space for FAB
              _buildNavItem(Icons.widgets, 2, isDisabled: true),
              _buildNavItem(Icons.person, 3, isDisabled: true),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNavItem(IconData icon, int index, {bool isDisabled = false}) {
    return IconButton(
      onPressed: isDisabled
          ? null
          : () {
            setState(() {
              screenIndex = index;
            });},
      icon: Icon(
        icon,
        color: screenIndex == index
            ? Colors.white// น้ำเงินเทาสว่าง
            : const Color(0xFFB0BEC5),
        size: 28,
      ),
    );
  }
}

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  CollectionReference workoutCollection = 
      FirebaseFirestore.instance.collection('Workout');
  int screenIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF303030),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: StreamBuilder(
            stream: workoutCollection.snapshots(),
            builder: ((context, snapshot) {
              if(snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    var dataIndex = snapshot.data!.docs[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context){
                              Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => updateForm(),
                                settings: RouteSettings(arguments: dataIndex))
                              );
                            },
                            backgroundColor: Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context){
                              workoutCollection.doc(dataIndex.id).delete();
                            },
                            backgroundColor: Color(0xFFFE4A49),
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ]
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        color: Color(0xFF424242),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                          child: ListTile(
                            leading: Icon(
                              Icons.fitness_center,
                              color: Colors.white,
                              size: 40,
                            ),
                            title: Text(
                              dataIndex['activity'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            subtitle: Text(
                              'Calories Burned: ${dataIndex['calories']} cal',
                              style: TextStyle(
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )
                    );
                  }),
                );
              } else {
                return Text('No data');
              }
            })
        ),
      )
    );
  }
}

class search extends StatelessWidget {
  const search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Search')
          ],
        ),
      ),
    );
  }
}


