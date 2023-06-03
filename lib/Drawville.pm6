use v6;

use NativeCall;

use Drawville::Raw::Definitions;

class Drawville {

  proto method get_clamed_min_max (|)
  { * }

  multi method get_clamed_min_max (
    Int() $a,
    Int() $b,
    Int() $c,
    Int() $clamp_min,
    Int() $clamp_max
  ) {
    samewith($a, $b, $c, $clamp_min, $clamp_max, $, $);
  }
  multi method get_clamped_min_max (
    Int() $a,
    Int() $b,
    Int() $c,
    Int() $clamp_min,
    Int() $clamp_max,
          $min        is rw,
          $max        is rw
  ) {
    my gint ($aa, $bb, $cc, $cmn, $cmx) = ($a, $b, $c, $clamp_min, $clamp_max);
    my gint ($mn, $mx)                  =  0 xx 2;

    get_clamped_min_max($aa, $bb, $cc, $cmn, $cmx, $mn, $mx);

    ($min, $max) = ($mn, $mx);
  }

  proto method get_console_size (|)
  { * }

  multi method get_console_size {
    samewith($, $);
  }
  multi method get_console_size ($width is rw, $height is rw) {
    my size_t ($w, $h) = 0 xx 2;

    my $rv = so get_console_size($w, $h);
    say "{ $rv }/{ $w }/{ $h }";
    ($width, $height) = ($w, $h);
  }

  method init {
    init_library();
  }

}

INIT {
  Drawville.init;
  ($AUTO-WIDTH, $AUTO-HEIGHT) = Drawville.get_console_size;
  say "Console dimensions are { $AUTO-WIDTH }x{ $AUTO-HEIGHT }";
}


### /usr/local/include/drawville/utils.h

sub get_clamped_min_max (
  gint $a,
  gint $b,
  gint $c,
  gint $clamp_min,
  gint $clamp_max,
  gint $min        is rw,
  gint $max        is rw
)
  is      native(drawville)
  is      export
{ * }

sub get_console_size (
  size_t $width  is rw,
  size_t $height is rw
)
  returns bool
  is      native(drawville)
  is      export
{ * }

sub init_library
  is      native(drawville)
  is      export
{ * }
