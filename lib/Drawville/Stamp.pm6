use v6;

use Drawville::Raw::Definitions;

class Drawville::Stamp {
  has Stamp $!s;

  submethod BUILD ( :$stamp ) {
    $!s = $stamp if $stamp;
  }

  multi method new (Stamp $stamp) {
    return unless $stamp;

    self.bless( :$stamp );
  }

  multi method new (Int() $steps, Int() $radius, :c(:$circle) is required) {
    self.new_circle_stamp($steps, $radius);
  }
  method new_circle_stamp (Int() $steps, Int() $radius) {
    my size_t ($s, $r) = ($step, $radius);

    my $stamp = new_circle_stamp($!s, $r);

    $stamp ?? self.bless( :$stamp ) !! Nil;
  }

  multi method new (Polygon() $p, :p(:$polygon) is required) {
    self.new_polygon_stamp($p);
  }
  method new_polygon_stamp (Polygon() $p) {
    my $stamp = new_polygon_stamp($p);

    $stamp ?? self.bless( :$stamp ) !! Nil;
  }
  multi method new (
    Int() $width,
    Int() $height,

    :r(:rect(:$rectangle) is required
  ) {
    self.new_rectangle_stamp($width, $height);
  }
  method new_rectangle_stamp (Int() $width, Int() $height) {
    my size_t ($w, $h) = ($width, $height);

    my $stamp = new_rectangle_stamp($w, $h);

    $stamp ?? self.bless( :$stamp ) !! Nil;
  }

  method apply_matrix {
    apply_matrix($!s);
  }

  method draw_outline (Canvas() $c, Int() $color, Stamp() $s) {
    my Color $c = $color;

    draw_stamp_outline($!s, $c, $s);
  }

  method fill_shape (Canvas() $c, Int() $color, Stamp() $s) {
    my Color $c = $color;

    fill_shape($!s, $color, $s);
  }

  method fill_triangle (
    Canvas() $canvas,
    Point()  $v1,
    Int()    $color,
    Point()  $v2,
    Point()  $v3
  ) {
    my Color $c = $color;

    fill_triangle($!s, $c, $v1, $v2, $v3);
  }

  method free_stamp {
    free_stamp($!s);
  }

  method get_center {
    get_stamp_center($!s);
  }

}
