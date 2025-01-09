import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/task_bloc.dart';
import 'blocs/task_event.dart';
import 'blocs/task_state.dart';
import 'blocs/category_bloc.dart';
import 'blocs/category_event.dart';
import 'screens/task_list_screen.dart';
import 'screens/category_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TaskBloc()..add(FetchTasks()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc()..add(FetchCategories()),
        ),
      ],
      child: MaterialApp(
        title: 'Task & Category App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MainMenu(),
      ),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<String> images = [
    'assets/images/image1.jpg',
    'assets/images/image2.jpeg',
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // White Background
          Container(
            color: Colors.white,
          ),

          // Content Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    'Welcome Teacher!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Let’s make a note for your tasks.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // Circular Image Slider
                  SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: ClipOval(
                            child: Image.asset(
                              images[index],
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Slider Indicator
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(images.length, (index) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: _currentIndex == index ? 12 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentIndex == index ? Colors.blue : Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Jumlah Tugas
                  BlocBuilder<TaskBloc, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoaded) {
                        return Text(
                          'Kamu punya ${state.tasks.length} daftar tugas.',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        );
                      } else if (state is TaskError) {
                        return Text(
                          'Error: ${state.message}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        );
                      }
                      return const Text(
                        'Kamu belum memiliki daftar tugas.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black54,
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  // Task Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TaskListScreen()),
                      );
                    },
                    icon: const Icon(Icons.task, size: 28),
                    label: const Text(
                      'View Task List',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoryListScreen()),
                      );
                    },
                    icon: const Icon(Icons.category, size: 28),
                    label: const Text(
                      'View Category List',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
