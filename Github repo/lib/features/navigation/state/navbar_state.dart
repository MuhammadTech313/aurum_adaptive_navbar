import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Breakpoints for responsive layout decisions
enum NavBreakpoint { mobile, tablet, desktop }

/// Central state for the Meridian Bar.
///
/// Drives: scroll compression, category selection, search expansion,
/// panel visibility, and accent color propagation.
class NavbarState extends ChangeNotifier {
  // ─── Scroll ─────────────────────────────────────────────
  double _scrollOffset = 0;
  bool _isScrolled = false;

  double get scrollOffset => _scrollOffset;
  bool   get isScrolled   => _isScrolled;

  void onScroll(double offset) {
    _scrollOffset = offset;
    final wasScrolled = _isScrolled;
    _isScrolled = offset > 60.0;
    if (_isScrolled != wasScrolled) notifyListeners();
  }

  // ─── Active Category ────────────────────────────────────
  int _activeCategoryIndex = 0;

  int get activeCategoryIndex => _activeCategoryIndex;

  void setCategory(int index) {
    if (_activeCategoryIndex == index) return;
    _activeCategoryIndex = index;
    notifyListeners();
  }

  // ─── Hovered Category (for panel + strip preview) ───────
  int? _hoveredCategoryIndex;

  int? get hoveredCategoryIndex => _hoveredCategoryIndex;

  /// The displayed strip position — hovered overrides active
  int get displayCategoryIndex => _hoveredCategoryIndex ?? _activeCategoryIndex;

  void setHoveredCategory(int? index) {
    if (_hoveredCategoryIndex == index) return;
    _hoveredCategoryIndex = index;
    notifyListeners();
  }

  // ─── Search ─────────────────────────────────────────────
  bool _isSearchExpanded = false;
  bool _isSearchFocused  = false;
  String _searchQuery    = '';

  bool   get isSearchExpanded => _isSearchExpanded;
  bool   get isSearchFocused  => _isSearchFocused;
  String get searchQuery       => _searchQuery;

  void expandSearch() {
    _isSearchExpanded = true;
    notifyListeners();
  }

  void focusSearch() {
    _isSearchExpanded = true;
    _isSearchFocused  = true;
    notifyListeners();
  }

  void blurSearch() {
    _isSearchFocused = false;
    if (_searchQuery.isEmpty) {
      _isSearchExpanded = false;
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery      = '';
    _isSearchExpanded = false;
    _isSearchFocused  = false;
    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // ─── Category Panel ─────────────────────────────────────
  bool _isPanelVisible = false;
  int  _panelCategoryIndex = 0;

  bool get isPanelVisible     => _isPanelVisible;
  int  get panelCategoryIndex => _panelCategoryIndex;

  void showPanel(int categoryIndex) {
    _panelCategoryIndex = categoryIndex;
    _isPanelVisible = true;
    notifyListeners();
  }

  void hidePanel() {
    _isPanelVisible = false;
    notifyListeners();
  }

  // ─── Responsive ─────────────────────────────────────────
  NavBreakpoint _breakpoint = NavBreakpoint.desktop;

  NavBreakpoint get breakpoint => _breakpoint;
  bool get isMobile  => _breakpoint == NavBreakpoint.mobile;
  bool get isTablet  => _breakpoint == NavBreakpoint.tablet;
  bool get isDesktop => _breakpoint == NavBreakpoint.desktop;

  void updateBreakpoint(double width) {
    final NavBreakpoint bp;
    if (width < 768) {
      bp = NavBreakpoint.mobile;
    } else if (width < 1024) {
      bp = NavBreakpoint.tablet;
    } else {
      bp = NavBreakpoint.desktop;
    }
    if (bp == _breakpoint) return;
    _breakpoint = bp;
    notifyListeners();
  }

  // ─── Derived Getters ────────────────────────────────────
  /// On tablet, always show compressed state
  bool get isCompressed => _isScrolled || isTablet;
}