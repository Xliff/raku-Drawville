use v6;

use NativeCall;

use Drawville::Raw::Definitions;

unit package Drawville::Raw::Polygon;

### /usr/local/include/drawville/polygon.h

sub add_vertex (Polygon $p, Point $vertex)
  returns size_t
  is      native(drawville)
  is      export
{ * }

sub close_polygon (Polygon $polygon)
  is      native(drawville)
  is      export
{ * }

sub free_polygon (Polygon $p)
  is      native(drawville)
  is      export
{ * }

sub get_polygon_center (Polygon $polygon)
  returns Point
  is      native(drawville)
  is      export
{ * }

sub new_polygon
  returns Polygon
  is      native(drawville)
  is      export
{ * }

sub optimize_polygon_memory (Polygon $polygon)
  returns bool
  is      native(drawville)
  is      export
{ * }

sub transform_polygon (Polygon $p, Mat3 $transformation)
  is      native(drawville)
  is      export
{ * }
