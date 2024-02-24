import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DropdownType {
  list,
  menu,
  checkboxList,
  checkboxMenu,
  radioList,
  radioMenu
}

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
  final List<T>? selectedItems;
  final Function(T) onSelected;
  final Function(List<T>)? onMultiSelected;
  final double? width;
  final double? height;
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
  final Color? borderColor;
  final bool enableBorder;
  final int elevation;
  final bool enableFeedback;
  final bool filled;
  final bool closeDialogOnExitOnly;
  final int maxLines;
  final double minFontSize;
  final EdgeInsets inputPadding;
  final OutlineInputBorder? inputBorder;
  final OutlineInputBorder? focuseBorder;

  FilterDropdownMenu(
      {super.key,
      this.type = DropdownType.list,
      this.items = const [],
      this.onMultiSelected,
      this.selectedItems,
      required this.currentValue,
      required this.onSelected,
      this.focusColor,
      this.hoverColor,
      this.menuColor,
      this.enableFeedback = true,
      this.elevation = 4,
      this.borderRadius = 5,
      this.width,
      this.height,
      this.labelText = "",
      this.hintText = "",
      this.maxLines = 1,
      this.minFontSize = 10,
      this.inputStyle,
      this.labelStyle,
      this.borderWidth = 1,
      this.labelAlign = TextAlign.left,
      this.inputFillColor,
      this.filled = true,
      this.closeDialogOnExitOnly = true,
      this.inputBorder,
      this.focuseBorder,
      this.enableBorder = true,
      this.borderColor,
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
  late List<T> selectedItems;
  @override
  void initState() {
    currentValue = widget.currentValue;
    selectedItems = widget.selectedItems ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildDropDown();
  }

  Widget _buildDropDown() {
    Widget child = Container();
    switch (widget.type) {
      case DropdownType.list:
        child = _buildList();
        break;
      case DropdownType.menu:
        child = _buildMenu();
        break;
      case DropdownType.checkboxList:
        child = _buildCheckboxList();
        break;
      case DropdownType.checkboxMenu:
        child = _buildCheckboxMenu();
        break;
      case DropdownType.radioList:
        child = _buildList(showRadio: true);
        break;
      case DropdownType.radioMenu:
        child = _buildMenu(showRadio: true);
        break;
    }
    return Container(child: child);
  }

  _handleMultiSelect(bool e, T? value,
      {void Function(void Function())? customSetState}) {
    if (value == null) return;
    if (selectedItems.contains(value)) {
      selectedItems.remove(value);
    } else {
      selectedItems.add(value);
    }
    widget.onMultiSelected?.call(selectedItems);
    if (customSetState != null) {
      customSetState(() {});
    }
    setState(() {});
  }

  _buildCheckboxList() {
    return StatefulBuilder(builder: (context, setState) {
      return Container(
          width: widget.width,
          constraints: BoxConstraints(maxHeight: widget.height ?? 60),
          child: DropdownButtonFormField<T>(
            padding: const EdgeInsets.all(1),
            focusColor: widget.focusColor,
            enableFeedback: widget.enableFeedback,
            dropdownColor: widget.menuColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            hint: AutoSizeText(
              widget.hintText,
              maxLines: widget.maxLines,
              minFontSize: widget.minFontSize,
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
              focusedBorder: widget.enableBorder
                  ? (widget.focuseBorder ?? widget.inputBorder)
                  : InputBorder.none,
              border: (widget.enableBorder
                  ? widget.inputBorder ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: widget.borderWidth,
                          color: widget.borderColor ??
                              Theme.of(context).primaryColor,
                        ),
                      )
                  : InputBorder.none),
            ),
            value: currentValue,
            selectedItemBuilder: (BuildContext context) {
              return widget.items
                  .map((e) => DropdownMenuItem(
                        value: e.value,
                        child: selectedItems.isNotEmpty
                            ? Text(
                                "${widget.hintText == "" ? currentValue.toString().contains(".") ? currentValue.toString().split(".").last : currentValue.toString() : widget.hintText}(${selectedItems.length})")
                            : e.child,
                      ))
                  .toList();
            },
            items: widget.items
                .map((e) => DropdownMenuItem(
                      value: e.value,
                      key: ValueKey(e.value),
                      child: IgnorePointer(
                        ignoring: true,
                        child: CheckboxListTile(
                          title: e.child,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: selectedItems.contains(e.value),
                          onChanged: (v) {
                            if (!widget.closeDialogOnExitOnly) {
                              Navigator.of(context).pop();
                            }
                            _handleMultiSelect(v!, e.value,
                                customSetState: setState);
                          },
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (v) =>
                _handleMultiSelect(true, v, customSetState: setState),
          ));
    });
  }

  _buildList({bool showRadio = false}) {
    return Container(
      width: widget.width,
      constraints: BoxConstraints(maxHeight: widget.height ?? 60),
      child: DropdownButtonFormField<T>(
          padding: const EdgeInsets.all(1),
          focusColor: widget.focusColor,
          enableFeedback: widget.enableFeedback,
          dropdownColor: widget.menuColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          hint: AutoSizeText(
            widget.hintText,
            minFontSize: widget.minFontSize,
            maxLines: widget.maxLines,
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
             focusedBorder: widget.enableBorder
                  ? (widget.focuseBorder ?? widget.inputBorder)
                  : InputBorder.none,
              border: (widget.enableBorder
                  ? widget.inputBorder ??
                      OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius),
                        borderSide: BorderSide(
                          width: widget.borderWidth,
                          color: widget.borderColor ??
                              Theme.of(context).primaryColor,
                        ),
                      )
                  : InputBorder.none),
          ),
          value: currentValue,
          selectedItemBuilder: (BuildContext context) {
            return widget.items
                .map((e) => DropdownMenuItem(
                      value: e.value,
                      child: e.child,
                    ))
                .toList();
          },
          items: widget.items
              .map((e) => DropdownMenuItem(
                    value: e.value,
                    child: showRadio
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                child: Icon(
                                    currentValue == e.value
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: e.value == currentValue
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.color),
                              ),
                              Expanded(flex: 3, child: e.child)
                            ],
                          )
                        : e.child,
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
          }),
    );
  }

  _buildMenu({bool showRadio = false}) {
    String val = currentValue.toString().contains(".")
        ? currentValue.toString().split('.').last
        : currentValue.toString();
    return InkWell(
      onTap: () {
        popUpDialog(context, showRadio: showRadio);
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
              child: AutoSizeText(val,
                  maxLines: widget.maxLines,
                  minFontSize: widget.minFontSize,
                  style: widget.inputStyle,
                  textAlign: widget.labelAlign),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  popUpDialog(BuildContext context,
      {bool multiSelect = false, bool showRadio = false}) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setstate) {
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
                            (e) => multiSelect
                                ? CheckboxListTile(
                                    title: e.child,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    value: selectedItems.contains(e.value),
                                    onChanged: (v) => _handleMultiSelect(
                                        v!, e.value,
                                        customSetState: setstate),
                                  )
                                : ListTile(
                                    leading: showRadio
                                        ? Icon(
                                            currentValue == e.value
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_unchecked,
                                            color: e.value == currentValue
                                                ? Theme.of(context).primaryColor
                                                : Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.color)
                                        : null,
                                    title: e.child,
                                    onTap: () {
                                      setstate(() {
                                        currentValue = e.value;
                                      });
                                      widget.onSelected(e.value);
                                      Navigator.of(dialogContext).pop();
                                      setState(() {});
                                    },
                                  ),
                          )
                          .toList()
                          .animate(interval: 100.ms)
                          .fade(duration: 200.ms, curve: Curves.easeInOutCubic)
                          .slide(
                              begin: const Offset(0, 0.5),
                              end: const Offset(0, 0)),
                    ),
                  )),
            ),
          );
        });
      },
    );
  }

  Widget _buildCheckboxMenu() {
    String val = selectedItems.isEmpty
        ? widget.hintText.isNotEmpty
            ? widget.hintText
            : currentValue.toString().contains(".")
                ? currentValue.toString().split(".").last
                : currentValue.toString()
        : "${widget.hintText == "" ? currentValue.toString().contains(".") ? currentValue.toString().split(".").last : currentValue.toString() : widget.hintText}(${selectedItems.length})";
    return InkWell(
      onTap: () {
        popUpDialog(context, multiSelect: true);
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
              child: AutoSizeText(
                val,
                maxLines: widget.maxLines,
                minFontSize: widget.minFontSize,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
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
                    child: AutoSizeText(
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
