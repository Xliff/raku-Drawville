use v6;

use Drawville::Raw::Definitions;
use Drawville::Raw::Mat3;

class Drawville::Mat3 {
  has mat3 $!m;

  method new_mat3 {
    my $mat = new_mat3($!m);

    $mat ?? self.bless( :$mat ) !! Nil
  }

  method clone_mat3 {
    clone_mat3($!m);
  }

  method combine_mat3 (mat3 $to) {
    my $mat = combine_mat3($!m, $b, $to);

    $mat ?? self.bless( :$mat ) !! Nil
  }

  method free_mat3 {
    free_mat3($!m);
  }

  method is_identity_matrix {
    so is_identity_matrix($!m);
  }

  method reset_mat3 {
    reset_mat3($!m);
  }

  method rotate_mat3 (Num() $angle) {
    my gfloat $a = $angle;

    my $mat = rotate_mat3($!m, $angle);

    $mat ?? self.bless( :$mat ) !! Nil
  }

  method scale_mat3 (Num() $x_delta, Num() $y_delta) {
    my gfloat ($x, $y) = ($x_delta, $y_delta);

    my $mat = scale_mat3($!m, $x, $y);

    $mat ?? self.bless( :$mat ) !! Nil
  }

  method shear_mat3 (Num() $x_delta, Num() $y_delta) {
    my gfloat ($x, $y) = ($x_delta, $y_delta);

    my $mat = shear_mat3($!m, $x, $y);

    $mat ?? self.bless( :$mat ) !! Nil
  }

  method to_string_mat3 {
    to_string_mat3($!m);
  }

  method translate_mat3 Num() $x_delta, Num() $y_delta) {
    my gfloat ($x, $y) = ($x_delta, $y_delta);

    my $mat = translate_mat3($!m, $x_delta, $y_delta);

    $mat ?? self.bless( :$mat ) !! Nil
  }

}
