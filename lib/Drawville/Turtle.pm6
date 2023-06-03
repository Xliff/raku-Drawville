use v6;

use Drawville::Canvas;

sub rad ($deg) { $deg * pi / 180 }

class Drawville::Turtle is Drawville::Canvas {
  has $.pos-x;
  has $.pos-y;
  has $.rotation;
  has $.brush-on;

  method up   { $!brush-on = False }
  method down { $!brush-on = True  }

  method left  ($angle) { $!rotation += $angle }
  method right ($angle) { $!rotation -= $angle }

  method back ($step) { self.forward( -$step ) }

  method forward ($step) {
    my $x = $!pos-x + $!rotation.&rad.cos * $step;
    my $y = $!pos-y + $!rotation.&rad.sin * $step;

    my $prev-brush-state = $.brush-on;
    $!brush-on = True;
    self.move($x, $y);
    $!brush-on = $prev-brush-state;

    self.set_pixel( |$_ ) for self.line($.pos-x, $.pos-y, $x, $y);
  }

}
