import 'package:flutter/material.dart';
import 'package:ruki_filter/ruki_filter.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }

}

enum Filter { all, active, completed }

class MyHomePage extends StatelessWidget {
  final String title;
  const MyHomePage({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Filter Button Example:"),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: FilterToggle<Filter>(
                filters: Filter.values,
                currentFilter: Filter.all,
                onSelected: (filter) {
                  print(filter);
                },
              ),
            ),
          ),

          const Text("Filter Dropdown Example:"),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 400,
              height: 40,
              child: Row(
                children: [
                   Expanded(
                     child: FilterDropdownMenu<Filter>(
                      type: DropdownType.menu,
                       items: Filter.values.map((e) => FilterDropdownItem<Filter>(child: Text(e.toString().split('.').last), value: e)).toList(),
                       currentValue: Filter.all,
                       onSelected: (filter) {
                                         print(filter);
                       },
                     ),
                   ),
                   Spacer(),
                   Expanded(
                     child: FilterDropdownMenu<Filter>(
                       items: Filter.values.map((e) => FilterDropdownItem<Filter>(child: Text(e.toString().split('.').last), value: e)).toList(),
                       currentValue: Filter.all,
                       onSelected: (filter) {
                                         print(filter);
                       },
                     ),
                   ),
                   Spacer(),
                   Expanded(
                     child: FilterDropdownMenu<Filter>(
                       items: Filter.values.map((e) => FilterDropdownItem<Filter>(child: Text(e.toString().split('.').last), value: e)).toList(),
                       currentValue: Filter.all,
                       onSelected: (filter) {
                                         print(filter);
                       },
                     ),
                   ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}
