use v6;

use NativeCall;

use Drawville::Raw::Definitions;

class Drawville::Canvas {
  has Canvas $!c;

  submethod BUILD ( :$canvas ) {
    $!c = $canvas;
  }

  method new_canvas (Int() $width,Int() $height) {
    my size_t ($w, $h) = ($width, $height);

    my $canvas = new_canvas($w, $h);

    $canvas ?? self.bless( :$canvas ) !! Nil;
  }

  method create_buffer {
    new_buffer($!c);
  }

  method clear {
    clear($!c);
  }

  multi method draw (@buffer) {
    samewith( ArrayToCArray(Str, @buffer) );
  }
  method draw (CArray[Str] $buffer) {
    draw($!c, $buffer);
  }

  method fill (Int() $color) {
    my Color $c = $color;

    fill($!c, $color);
  }

  multi method normalize (Int $c) { $c       }
  multi method normalize (Num $c) { $c.round }

  multi method normalize (*@a) {
    do gather for @a {
      take self.normalize($_)
    }
  }

  method line ($x1 is copy, $x2 is copy, $y1 is copy, $y2 is copy) {
    ($x1, $x2, $y1, $y2) = self.normalize($x1, $x2, $y1, $y2);

    my $xdiff = ($x1, $x2).max - ($x1, $x2).min;
    my $ydiff = ($y1, $y2).max - ($y1, $y2).min;

    my $xdir = $x1 < $x2 ?? 1 !! -1;
    my $ydir = $y1 < $y2 ?? 1 !! -1;

    my $r = max($xdiff, $ydiff);

    do gather for 0..$r {
      my ($x, $y) = ($x1, $y1);

      $y += $_ * $ydiff / $r * $ydir;
      $x += $_ * $xdiff / $r * $xdir;

      take ($x, $y);
    }
  }

  method free_buffer {
    free_buffer($!c);
  }

  method free_canvas {
    free_canvas($!c);
  }

  method get_pixel (Int() $x, Int() $y) {
    my gint ($xx, $yy) = ($x, $y);

    get_pixel($!c, $xx, $yy);
  }

  multi method set_pixel (Int() $x, Int() $y, :$color => WHITE) {
    self.set_pixel($color, $x, $y);
  }
  method set_pixel (Int() $color, Int() $x, Int() $y) {
    my Color  $c        =  $color;
    my gint  ($xx, $yy) = ($x, $y);

    set_pixel($!c, $color, $xx, $yy);
  }

  method set_pixel_unsafe (Int() $color, Int() $x, Int() $y) {
    my Color  $c        =  $color;
    my gint  ($xx, $yy) = ($x, $y);

    set_pixel_unsafe($!c, $color, $xx, $yy);
  }

  method transform_canvas (mat3() $transformations, Int() $sm, Int() $crop) {
    my bool          $c = $crop;
    my ScalingMethod $s = $sm;

    transform_canvas($!c, $transformations, $s, $c);
  }

}
