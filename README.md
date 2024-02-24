A Filter Paradise, This Widget contains 2 style of Filtering, DropDown Filter selection or FilterToggle.
You can use this for any model data or just enumerations. 

## Features

- `FilterDropdown` Allows you to select from a dropdown list of `FilterDropdownItems<T>`, or a modal list instead.
- `FilterToggle` Create n size of items and have the option to toggle between the selections.


## Usage

```dart
import 'package:flutter/material.dart';
import 'package:ruki_filter/ruki_filter.dart';

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


```

## API Reference

### FilterDropdownMenu
| Property       | Description                                                                 | Type                      |
|----------------|-----------------------------------------------------------------------------|---------------------------|
| value          | The currently selected value                                                | dynamic                   |
| child          | The child widget to display                                                 | Widget                    |
| items          | The list of items to display in the dropdown menu                           | List<DropdownMenuItem>    |
| onSelected     | Callback function that is called when an item is selected                   | Function(dynamic)         |
| filled         | Whether the dropdown menu should be filled with a background color          | bool                      |
| inputFillColor | The background color of the filled dropdown menu                            | Color?                    |
| borderRadius   | The border radius of the dropdown menu container                            | double                    |
| borderWidth    | The width of the border of the dropdown menu container                      | double                    |
| inputStyle     | The style of the text in the dropdown menu                                  | TextStyle                 |
| labelAlign     | The alignment of the text in the dropdown menu                              | TextAlign                 |
| width          | The maximum width of the dropdown menu                                      | double?                   |


### FilterToggle
| Property       | Description                                                                 | Type                      |
|----------------|-----------------------------------------------------------------------------|---------------------------|
| currentFilter  | The currently selected filter                                               | T                         |
| filters        | The list of available filters                                               | List<T>                   |
| spacing        | The spacing between filter buttons                                          | double                    |
| onSelected     | Callback function that is called when a filter is selected                  | Function(T)               |
