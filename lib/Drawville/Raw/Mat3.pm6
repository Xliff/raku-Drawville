use v6;

use NativeCall;

use Drawville::Raw::Definitions;

unit package Drawville::Raw::Mat;

### /usr/local/include/drawville/mat3.h

sub clone_mat3 (mat3 $m)
  returns mat3
  is      native(drawville)
  is      export
{ * }

sub combine_mat3 (mat3 $a, mat3 $b, mat3 $to)
  is      native(drawville)
  is      export
{ * }

sub free_mat3 (mat3 $m)
  is      native(drawville)
  is      export
{ * }

sub is_identity_matrix (mat3 $m)
  returns bool
  is      native(drawville)
  is      export
{ * }

sub new_mat3
  returns mat3
  is      native(drawville)
  is      export
{ * }

sub reset_mat3 (mat3 $m)
  is      native(drawville)
  is      export
{ * }

sub rotate_mat3 (mat3 $m, gfloat $angle)
  is      native(drawville)
  is      export
{ * }

sub scale_mat3 (mat3 $m, gfloat $x_delta, gfloat $y_delta)
  is      native(drawville)
  is      export
{ * }

sub shear_mat3 (mat3 $m, gfloat $x_delta, gfloat $y_delta)
  is      native(drawville)
  is      export
{ * }

sub to_string_mat3 (mat3 $m)
  returns CArray[Str]
  is      native(drawville)
  is      export
{ * }

sub translate_mat3 (mat3 $m, gfloat $x_delta, gfloat $y_delta)
  is      native(drawville)
  is      export
{ * }
