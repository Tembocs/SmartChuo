# A General Flexible Flutter Table

This is a specification for a Flutter based general data table.
-  The table should be scrollable vertically and horizontally.
-  It should have header row with cells are that adjustable together with the rest of the column width.
-  Row height should also be adjustable.
-  It should have fixed header row, meaning on scrolling vertically the header row remains at the top and does not disappear.
-  The most left column should also have capability to be fixed on the left side even when scrolling horizontally toward the left.
-  Likewise, the most right column should also have capability to be fixed on the right side even when scrolling horizontally toward the right. This will enable to have widgets that should always be visible.
-  Ech cell should accommondate a Flutter widget by default.
-  Should be able to show and hide the grid lines, be it the vertical ones only, or the horizontal ones or all.
-  It should automatically add ellipses when things overflow in a column cell.
-  User should be able to set alternate row colors if they needed to.
-  Header row can have separate color if user want to.
-  It should have capability to set pages for large data with user ability to set the number of rows per page. It should also have indicators for number of pages, back and forward buttons and number of items so far.
-  It should also have a builder method when user want to use such a method in circumstances where it make sense.
-  The Table should have a flat bare look leaving any decoration to the user.