import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DropdownType { list, menu }

/// This is a widget that creates a dropdown menu with a list of items
/// There are two types of dropdowns, [DropdownType.list] and [DropdownType.menu]
/// [DropdownType.list] is a dropdown that shows a list of items
/// [DropdownType.menu] is a dropdown that shows a menu of items
/// The [items] parameter is a list of [FilterDropdownItem] that contains the items to be displayed
/// The [currentValue] parameter is the current value of the dropdown
/// The [onSelected] parameter is a function that is called when an item is selected

class FilterDropdownMenu<T> extends StatefulWidget {
  final DropdownType type;
  final List<FilterDropdownItem<T>> items;
  final T currentValue;
  final Function(T) onSelected;
  final double? width;
  final String labelText;
  final String hintText;
  final TextStyle? labelStyle;
  final TextStyle? inputStyle;
  final TextAlign labelAlign;
  final double borderWidth;
  final double borderRadius;
  final Color? inputFillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Color? menuColor;
  final int elevation;
  final bool enableFeedback;
  final bool filled;
  final EdgeInsets inputPadding;
  final OutlineInputBorder? inputBorder;

  FilterDropdownMenu(
      {super.key,
      this.type = DropdownType.list,
      this.items = const [],
      required this.currentValue,
      required this.onSelected,
      this.focusColor,
      this.hoverColor,
      this.menuColor,
      this.enableFeedback = true,
      this.elevation = 4,
      this.borderRadius = 5,
      this.width,
      this.labelText = "",
      this.hintText = "",
      this.inputStyle,
      this.labelStyle,
      this.borderWidth = 1,
      this.labelAlign = TextAlign.left,
      this.inputFillColor,
      this.filled = true,
      this.inputBorder,
      this.inputPadding =
          const EdgeInsets.symmetric(horizontal: 8, vertical: 1)})
      : assert(items.isNotEmpty,
            "[items] must have at least One item, size: ${items.length}"),
        assert(items.any((element) => element.value == currentValue),
            " items must contain currentValue,currentValue:{$currentValue} ");

  @override
  FilterDropdownMenuState<T> createState() => FilterDropdownMenuState<T>();
}

class FilterDropdownMenuState<T> extends State<FilterDropdownMenu<T>> {
  TextEditingController controller = TextEditingController();
  late T currentValue;

  @override
  void initState() {
    currentValue = widget.currentValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDropDown();
  }

  Widget _buildDropDown() {
    return Container(
        child: widget.type == DropdownType.list ? _buildList() : _buildMenu());
  }

  _buildList() {
    return DropdownButtonFormField<T>(
        padding: const EdgeInsets.all(1),
        focusColor: widget.focusColor,
        enableFeedback: widget.enableFeedback,
        dropdownColor: widget.menuColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        hint: Text(
          widget.hintText,
          style: TextStyle(
            color: Theme.of(context).textTheme.headlineMedium?.color ??
                Colors.grey,
          ),
        ),
        style: widget.inputStyle,
        isExpanded: true,
        elevation: widget.elevation,
        decoration: InputDecoration(
          contentPadding: widget.inputPadding,
          fillColor: widget.inputFillColor ??
              Theme.of(context).inputDecorationTheme.fillColor,
          filled: widget.filled,
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          border: widget.inputBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  width: widget.borderWidth,
                ),
              ),
        ),
        value: currentValue,
        items: widget.items
            .map((e) => DropdownMenuItem(
                  value: e.value,
                  child: e.child,
                ))
            .toList(),
        onChanged: (v) {
          if (v == null) {
            return;
          }
          setState(() {
            currentValue = v;
          });
          widget.onSelected(v);
        });
  }

  _buildMenu() {
    String val = currentValue.toString().contains(".")
        ? currentValue.toString().split('.').last
        : currentValue.toString();
    return InkWell(
      onTap: () {
        popUpDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: widget.filled
              ? widget.inputFillColor ??
                  Theme.of(context).inputDecorationTheme.fillColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: Theme.of(context).textTheme.headlineMedium?.color ??
                Colors.grey,
            width: widget.borderWidth,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(val,
                  style: widget.inputStyle, textAlign: widget.labelAlign),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: widget.width ?? 200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: widget.items
                        .map(
                          (e) => ListTile(
                            title: e.child,
                            onTap: () {
                              setState(() {
                                currentValue = e.value;
                              });
                              widget.onSelected(e.value);
                              Navigator.pop(dialogContext);
                            },
                          ),
                        )
                        .toList()
                        .animate(interval: 100.ms).fade(duration: 200.ms, curve: Curves.easeInOutCubic).slide(begin: const Offset(0, 0.5), end: const Offset(0, 0)),
                  ),
                )),
          ),
        );
      },
    );
  }
}

class FilterDropdownItem<T> {
  final Widget child;
  final T value;

  FilterDropdownItem({required this.child, required this.value});
}


class FilterToggle<T extends Enum> extends StatefulWidget {
  final List<T> filters;
  final Function(T) onSelected;
  final T currentFilter;
  final double spacing;

  const FilterToggle(
      {super.key,
      required this.filters,
      required this.currentFilter,
      required this.onSelected,
      this.spacing = 10});

  @override
  FilterToggleState<T> createState() => FilterToggleState<T>();
}

class FilterToggleState<T extends Enum> extends State<FilterToggle<T>> {

  late T currentFilter;

  @override
  void initState() {
    currentFilter = widget.currentFilter;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widget.filters.map(
        (e) {
          String value = e.toString().split('.').last;
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.spacing,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          currentFilter == e
                              ? Theme.of(context).primaryColor
                              : Theme.of(context)
                                  .textTheme
                                  .labelLarge!
                                  .color!
                                  .withOpacity(0.3)),
                    ),
                    child: Text(
                      value,
                      maxLines: 1,
                    ),
                    onPressed: () {
                      setState(() {
                        currentFilter = e;
                      });
                      widget.onSelected(currentFilter);
                    },
                  ),
                ),
                AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: value == e ? 32 : 0,
                    height: 4,
                    decoration: BoxDecoration(
                      color: value == e
                          ? Theme.of(context).primaryColor
                          : Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .color!
                              .withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    duration: const Duration(
                      milliseconds: 200,
                    )),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
