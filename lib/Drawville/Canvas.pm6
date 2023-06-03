use v6;

use NativeCall;

use Drawville::Raw::Definitions;
use Drawville::Raw::Canvas;

class X::Drawville::BufferUndefined is Exception {
  method message { '<buffer> must be defined!' }
}

class X::Drawville::Canvas::InvalidOrigin is Exception {
  method message { 'An invalid <origin> value was specified' }
}

class Drawville::Canvas {
  has Canvas $!c;
  has        $!buffer-created;
  has        $!buffer;

  submethod BUILD ( :$canvas ) {
    say "Canvas dimensions are { $AUTO-WIDTH }x{ $AUTO-HEIGHT }"
      unless $canvas;
    $!c      = $canvas // new_canvas($AUTO-WIDTH, $AUTO-HEIGHT);

    $!buffer = self.create_buffer;
  }

  submethod DESTROY {
    self!free_buffer if $!buffer;
    self!free_canvas;
  }

  method debug ($prefix = '') {
    state $d = 0;
    say "{ $prefix ?? $prefix ~ ' - ' !! '' }D{ $d++ }: { $!c.gist }";
  }

  method new_canvas (Int() $width,Int() $height) {
    my size_t ($w, $h) = ($width, $height);

    my $canvas = new_canvas($w, $h);

    $canvas ?? self.bless( :$canvas ) !! Nil;
  }

  method create_buffer ( :$force = False ) {
    return if $!buffer-created && $force.not;
    $!buffer-created = True unless $!buffer-created;
    new_buffer($!c);
  }

  method clear {
    clear($!c);
  }

  multi method draw_to_buffer {
    draw($!c, $!buffer);
  }
  multi method draw_to_buffer (CArray[Str] $buffer) {
    X::Drawville::BufferUndefined.new.throw unless $buffer;
    self.set_buffer($buffer);
    samewith();
  }

  multi method set_buffer (@buffer) {
    self.set_buffer( ArrayToCArray(uint8, @buffer) );
  }
  multi method set_buffer (CArray[uint8] $buffer) {
    X::Drawville::BufferUndefined.new.throw unless $buffer;
    $!buffer = $buffer
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

  method line ($x1 is copy, $y1 is copy, $x2 is copy, $y2 is copy) {
    ($x1, $x2, $y1, $y2) = self.normalize($x1, $x2, $y1, $y2);

    my $xdiff = ($x1, $x2).max - ($x1, $x2).min;
    my $ydiff = ($y1, $y2).max - ($y1, $y2).min;

    my $xdir = $x1 <= $x2 ?? 1 !! -1;
    my $ydir = $y1 <= $y2 ?? 1 !! -1;

    my $r = max($xdiff, $ydiff);

    my @p = do gather for 0 .. $r {
      my ($x, $y) = ($x1, $y1);

      $y += ($_ * $ydiff) / $r * $ydir if $ydiff;
      $x += ($_ * $xdiff) / $r * $xdir if $xdiff;

      take ($x, $y);
    }
    @p;
  }

  method !free_buffer {
    free_buffer($!buffer);
    $!buffer = Nil;
  }

  method !free_canvas {
    free_canvas($!c);
  }

  method get_pixel (Int() $x, Int() $y) {
    my gint ($xx, $yy) = ($x, $y);

    get_pixel($!c, $xx, $yy);
  }


  method adjust-point ($x, $y, $_) {
    my gint ($xx, $yy) = ($x, $y);

    when UL { }

    when UR { $xx = $!c.width  - $xx }

    when LL { $yy = $!c.height - $yy }

    when LR { $xx = $!c.width  - $xx;
              $yy = $!c.height - $yy }

    when C  { $xx = $!c.width  / 2 + $xx;
              $yy = $!c.height / 2 + $yy; }

    default {
      X::Drawville::Canvas::InvalidOrigin.new.throw;
    }

    ($xx, $yy);
  }

  multi method set_pixel (
    Int() $x,
    Int() $y,

    :$color = WHITE,
    :$origin = UL
  ) {
    samewith($color, $x, $y, :$origin);
  }
  multi method set_pixel (Int() $color, Int() $x, Int() $y, :$origin = UL) {
    my Color  $c =  $color;

    set_pixel( $!c, $color, |self.adjust-point($x, $y, $origin) );
  }

  multi method set_pixel_unsafe (
    Int() $x,
    Int() $y,

    :$color = WHITE,
    :$origin = UL
  ) {
    samewith($color, $x, $y, :$origin);.
  }
  method set_pixel_unsafe (Int() $color, Int() $x, Int() $y, :$origin = UL) {
    my Color  $c =  $color;

    set_pixel_unsafe( $!c, $color, |self.adjust-point($x, $y, $origin) );
  }

  method size {
    ($!c.width, $!c.height);
  }

  method transform_canvas (Mat3() $transformations, Int() $sm, Int() $crop) {
    my bool          $c = $crop;
    my ScalingMethod $s = $sm;

    transform_canvas($!c, $transformations, $s, $c);
  }

  method Str ( :$encoding = 'utf8' ) {
    self.draw_to_buffer;
    for ^$!c.height {
      .say with $!buffer[$_];
    }
  }

}

constant Canvas is export(:alias) = Drawville::Canvas;
constant C      is export(:a)     = Canvas;
