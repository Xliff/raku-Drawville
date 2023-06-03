use v6;

use Drawville::Raw::Definitions;

class Polygon {
  has Polygon $!p;

  submethod BUILD ( :$polygon ) {
    $!p = $polygon if $polygon;
  }

  method new {
    my $polygon = new_polygon();

    $polygon ?? self.bless( :$polygon ) !! Nil;
  }

  method add_vertex (Point() $vertex) {
    add_vertex($!p, $vertex);
  }

  method close_polygon {
    close_polygon($!p);
  }

  method free_polygon {
    free_polygon($!p);
  }

  method get_center {
    get_polygon_center($!p);
  }

  method optimize_memory {
    optimize_polygon_memory($!p);
  }

  method transform (Mat3() $transformations) {
    transform_polygon($!p, $transformations);
  }

}
