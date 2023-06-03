use v6;

use NativeCall;

use Drawville::Raw::Definitions;

unit package Drawville::Raw::Stamp;

### /usr/local/include/drawville/stamp.h

sub apply_matrix (Stamp $s)
  is      native(drawville)
  is      export
{ * }

sub draw_stamp_outline (Canvas $c, Color $color, Stamp $s)
  returns gint
  is      native(drawville)
  is      export
{ * }

sub fill_shape (Canvas $c, Color $color, Stamp $s)
  returns gint
  is      native(drawville)
  is      export
{ * }

sub fill_triangle (
  Canvas $canvas,
  Color  $color,
  Point  $v1,
  Point  $v2,
  Point  $v3
)
  is      native(drawville)
  is      export
{ * }

sub free_stamp (Stamp $s)
  is      native(drawville)
  is      export
{ * }

sub get_stamp_center (Stamp $stamp)
  returns Point
  is      native(drawville)
  is      export
{ * }

sub new_circle_stamp (size_t $steps, size_t $radius)
  returns Stamp
  is      native(drawville)
  is      export
{ * }

sub new_polygon_stamp (Polygon $p)
  returns Stamp
  is      native(drawville)
  is      export
{ * }

sub new_rectangle_stamp (size_t $width, size_t $height)
  returns Stamp
  is      native(drawville)
  is      export
{ * }
