use v6.c;

use NativeCall;

use Drawville::Raw::Definitions;

unit package Drawville::Raw::Canvas;

### /usr/local/include/drawville/Canvas.h

sub clear (Canvas $c)
  is      native(drawville)
  is      export
{ * }

sub draw (Canvas $c, CArray[Str] $buffer)
  is      native(drawville)
  is      export
{ * }

sub fill (Canvas $c, Color $color)
  is      native(drawville)
  is      export
{ * }

sub free_buffer (CArray[Str] $buffer)
  is      native(drawville)
  is      export
{ * }

sub free_canvas (Canvas $c)
  is      native(drawville)
  is      export
{ * }

sub get_pixel (Canvas $c, gint $x, gint $y)
  returns Color
  is      native(drawville)
  is      export
{ * }

sub new_buffer (Canvas $c)
  returns CArray[Str]
  is      native(drawville)
  is      export
{ * }

sub new_canvas (size_t $width, size_t $height)
  returns Canvas
  is      native(drawville)
  is      export
{ * }

sub set_pixel (Canvas $c, Color $color, gint $x, gint $y)
  is      native(drawville)
  is      export
{ * }

sub set_pixel_unsafe (
  Canvas $c,
  Color  $color,
  gint   $x,
  gint   $y
)
  is      native(drawville)
  is      export
{ * }

sub transform_canvas (
  Canvas        $c,
  Mat3          $transformations,
  ScalingMethod $sm,
  bool          $crop
)
  returns Canvas
  is      native(drawville)
  is      export
{ * }
