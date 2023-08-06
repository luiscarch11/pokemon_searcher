import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class InfiniteList<T, H> extends StatefulWidget {
  const InfiniteList._({
    Key? key,
    required this.data,
    this.itemsBuilder,
    this.listBuilder,
    this.separatorBuilder,
    required this.dataIsOver,
    required this.onFinishScrolling,
    this.headerBuilder,
    this.controller,
    this.shouldShowHeaderCondition,
    this.headerGetter,
    this.context,
    this.loadMoreText,
    required this.hasHeaders,
    this.stickyHeaderBuilder,
    this.isListViewExpandedRequired = false,
    required this.isLoading,
  })  : assert((itemsBuilder != null && listBuilder != null) || (listBuilder == null)),
        super(key: key);

  static InfiniteList<T, void> unheaded<T>({
    required List<T> data,
    ScrollController? controller,
    required bool isLoading,
    bool dataIsOver = false,
    Widget Function(T)? separatorBuilder,
    required VoidCallback onFinishScrolling,
    required Widget Function(T individualData, int index) itemsBuilder,
    Widget Function(ListView builtList, bool isLoading)? listBuilder,
    required String? loadMoreText,
    bool isListViewExpandedRequired = false,
  }) {
    return InfiniteList<T, void>._(
      separatorBuilder: separatorBuilder,
      data: data,
      controller: controller,
      isLoading: isLoading,
      dataIsOver: dataIsOver,
      onFinishScrolling: onFinishScrolling,
      itemsBuilder: itemsBuilder,
      listBuilder: listBuilder,
      hasHeaders: false,
      isListViewExpandedRequired: isListViewExpandedRequired,
    );
  }

  static InfiniteList headed<T, H>({
    required BuildContext context,
    required List<T> data,
    Widget Function(H header, Key key)? headerBuilder,
    required ScrollController controller,
    required bool isLoading,
    required Widget Function(BuildContext context, H header) stickyHeaderBuilder,
    bool dataIsOver = false,
    required VoidCallback onFinishScrolling,
    required bool Function(H currentHeaderValue, H currentDataHeaderValue) shouldShowHeaderCondition,
    required H Function(T individualData) headerGetter,
    required Widget Function(T individualData, int index) itemsBuilder,
    Widget Function(ListView builtList, bool isLoading)? listBuilder,
  }) {
    return InfiniteList<T, H>._(
      context: context,
      headerBuilder: headerBuilder,
      stickyHeaderBuilder: stickyHeaderBuilder,
      hasHeaders: true,
      shouldShowHeaderCondition: shouldShowHeaderCondition,
      headerGetter: headerGetter,
      data: data,
      itemsBuilder: itemsBuilder,
      listBuilder: listBuilder,
      dataIsOver: dataIsOver,
      onFinishScrolling: onFinishScrolling,
      controller: controller,
      isLoading: isLoading,
    );
  }

  final BuildContext? context;
  final List<T> data;
  final ScrollController? controller;
  final bool isLoading;
  final Widget Function(BuildContext context, H header)? stickyHeaderBuilder;
  final Widget Function(H header, Key key)? headerBuilder;
  final bool dataIsOver;
  final bool hasHeaders;
  final VoidCallback onFinishScrolling;
  final bool Function(H currentHeaderValue, H currentDataHeaderValue)? shouldShowHeaderCondition;
  final H Function(T individualData)? headerGetter;
  final Widget Function(T individualData)? separatorBuilder;
  final String? loadMoreText;
  final bool isListViewExpandedRequired;
  final Widget Function(
    T individualData,
    int index,
  )? itemsBuilder;
  final Widget Function(ListView builtList, bool isLoading)? listBuilder;

  @override
  InfiniteListState<T, H> createState() => InfiniteListState<T, H>();
}

class InfiniteListState<T, H> extends State<InfiniteList<T, H>> {
  bool overlayRemoved = false;
  late ScrollController controller;

  Map<GlobalKey, H> headersAndKeys = <GlobalKey, H>{};
  late double lastFirstHeaderPosition;
  GlobalKey key = GlobalKey();

  final stickyHeaderPosition = 40.0;
  OverlayEntry? sticky;

  @override
  void initState() {
    if (sticky != null) {
      _removeOverlay(widget.context!);
    }
    if (headersAndKeys.isNotEmpty) {
      sticky = _getStickyHeader(headersAndKeys.values.first);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _insertOverlay(widget.context!);
      });
    }
    controller = widget.controller ?? ScrollController();
    controller.addListener(
      () => _scrollControllerListener(context),
    );
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(() => _scrollControllerListener(context));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    H? currentHeader = widget.headerGetter?.call(widget.data.first);
    final listView = ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      separatorBuilder: (__, index) => widget.separatorBuilder?.call(widget.data[index]) ?? const Divider(),
      itemCount: widget.data.length,
      controller: headersAndKeys.isNotEmpty ? null : controller,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final currentItemHeader = widget.headerGetter?.call(widget.data[index]);
        final shouldShowHeader = widget.shouldShowHeaderCondition?.call(
              currentHeader as H,
              currentItemHeader as H,
            ) ??
            false;
        if (shouldShowHeader) {
          final newHeaderKey = GlobalKey();
          headersAndKeys.addAll({
            newHeaderKey: currentItemHeader as H,
          });
          currentHeader = currentItemHeader;
          return Column(
            children: [
              widget.headerBuilder?.call(currentHeader as H, newHeaderKey) ??
                  Text(
                    currentHeader.toString(),
                    key: newHeaderKey,
                  ),
              widget.itemsBuilder!.call(
                widget.data[index],
                index,
              ),
            ],
          );
        }

        return Column(
          children: [
            widget.itemsBuilder!.call(
              widget.data[index],
              index,
            ),
            if (!widget.dataIsOver && (index + 1) == widget.data.length && !widget.isLoading) ...[
              const SizedBox(
                height: 30,
              ),
              TextButton(
                onPressed: widget.onFinishScrolling,
                child: Text(
                  widget.loadMoreText ?? 'Load more',
                ),
              ),
            ]
          ],
        );
      },
    );
    return widget.listBuilder != null
        ? widget.listBuilder!.call(
            listView,
            widget.isLoading,
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isListViewExpandedRequired) Expanded(child: listView) else listView,
                if (widget.isLoading) ...[
                  const SizedBox(
                    height: 30,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 40.0),
                    child: SizedBox.square(
                      dimension: 25,
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
  }

  void _insertOverlay(BuildContext context) {
    Overlay.of(context).insert(sticky!);
    overlayRemoved = false;
  }

  void _removeOverlay(BuildContext context) {
    if (!overlayRemoved) sticky?.remove();
    overlayRemoved = true;
  }

  void _scrollControllerListener(BuildContext context) {
    if (_shouldCallOnScrollFinish) widget.onFinishScrolling.call();
    if (widget.hasHeaders) _manageStickyHeader();
  }

  void _manageStickyHeader() {
    if (headersAndKeys.isNotEmpty) {
      double firstHeaderPosition;
      final context = key.currentContext;
      if (context == null) {
        firstHeaderPosition = lastFirstHeaderPosition;
      } else {
        firstHeaderPosition = context.yAxis;
      }
      lastFirstHeaderPosition = firstHeaderPosition;
      if (firstHeaderPosition >= stickyHeaderPosition) {
        _removeOverlay(context!);
      } else {
        headersAndKeys.forEach(_showOrHideStickyHeader);
      }
    }
  }

  OverlayEntry _getStickyHeader(H headerValue) {
    return OverlayEntry(
      builder: (_) => _stickyBuilder(headerValue),
    );
  }

  Widget _stickyBuilder(H headerValue) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Positioned(
          top: stickyHeaderPosition,
          left: 50.0,
          right: 50.0,
          height: 40,
          child: Material(
            color: Colors.transparent,
            child: widget.stickyHeaderBuilder!(
              context,
              headerValue,
            ),
          ),
        );
      },
    );
  }

  void _showOrHideStickyHeader(GlobalKey<State<StatefulWidget>> key, H value) {
    final context = key.currentContext;
    if (context == null) return;

    final currentPosition = context.yAxis;

    if (_currentHeaderPositionIsCloseToSticky(currentPosition)) {
      if (sticky != null) _removeOverlay(context);
      sticky = _getStickyHeader(value);
      _insertOverlay(context);
    }
  }

  bool _currentHeaderPositionIsCloseToSticky(double currentHeaderPosition) {
    return currentHeaderPosition >= stickyHeaderPosition - 10 && currentHeaderPosition <= stickyHeaderPosition + 10;
  }

  bool get _shouldCallOnScrollFinish {
    return controller.position.pixels >= controller.position.maxScrollExtent - 30 &&
        !widget.isLoading &&
        !widget.dataIsOver;
  }
}

extension _BuildContextExtension on BuildContext {
  double get yAxis {
    final renderBox = findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero).dy;
  }
}
