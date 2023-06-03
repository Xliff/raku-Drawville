use v6.c;

use NativeCall;

unit package Drawville::Raw::Definitions;

constant drawville is export = '/usr/local/lib/libdrawville.so';

our $AUTO-WIDTH  is export;
our $AUTO-HEIGHT is export;

constant Color is export := uint32;
our enum ColorEnum is export <
  BLACK
  WHITE
>;

constant OriginPoint is export := uint32;
our enum OriginPointEnum is export <UL LL C UR LR>;

constant ScalingMethod is export := uint32;
our enum ScalingMethodEnum <
  NEAREST_NEIGHBOR
>;

constant gint is export := int32;

class Mat3 is repr<CStruct> is export {
  HAS CArray[num32] @.m[9] is CArray;

  method p ($x, $y) is rw {
    @.m[$x * $y + $x];
  }
}

class Canvas is repr<CStruct> is export {
  has size_t        $.width   is rw;
  has size_t        $.height  is rw;
  has size_t        $.cwidth  is rw;
  has size_t        $.cheight is rw;

  has CArray[uint8] $.canvas;
}

class Point is repr<CStruct> is export {
  has num32 $.x is rw;
  has num32 $.y is rw;

  method transform (Mat3() $m) {
    transform_point(self, $m);
  }

}

sub transform_point (Point $p, Mat3 $m)
  returns Point
  is      export
  is      native(drawville)
{ * }

our @pixmap is export;

class Pixmap {

  method p ($x, $y) {
    @pixmap[$x * $y + $x];
  }

}

constant pixmap is export = Pixmap.new;

multi sub postcircumfix:<[ ]> (Pixmap $p, $x, $y) is rw  is export {
  $p.p($x, $y);
}

our $DEBUG is export  = 0;

sub cast ($cast-to, $obj) is export {
  nativecast($cast-to, $obj);
}

sub resolveNativeType (\T) is export {
  say "Resolving { T.^name } to its Raku equivalent...";
  do given T {
    when num32 | num64     { Num }

    when int8  | uint8  |
         int16 | uint16 |
         int32 | uint32 |
         int64 | uint64
                           { Int }

    when str               { Str }

    default                {
      do if T.REPR eq <CPointer CStruct>.any {
        T
      } else {
        # cw: I don't know if this is the best way to handle this.
        die "Do not know how to handle a type of { .^name }!";
      }
    }
  }
}

sub checkForType (\T, $v is copy) is export {
  if T !=== Nil {
    unless $v ~~ T {
      #say "Attempting to convert a { $v.^name } to { T.^name }...";
      my $resolved-name = resolveNativeType(T).^name;
      $resolved-name ~= "[{ T.of.^name }]" if $resolved-name eq 'CArray';
      #say "RN: { $resolved-name }";
      if $v.^lookup($resolved-name) -> $m {
        #say "Using coercer at { $v.^name }.$resolved-name...";
        $v = $m($v);
      }
      # Note reversal of usual comparison. This is due to the fact that
      # nativecall types must be compatible with the value, not the
      # other way around. In all other cases, T and $v should have
      # the same type value.
      die "Value does not support { $v.^name } variables. Will only accept {
        T.^name }!" unless T ~~ $v.WHAT;
    }
  }
  $v;
}

sub ArrayToCArray(\T, Array() $a, :$size = $a.elems, :$null = False)
  is export
{
  enum Handling <P NP>;
  my $handling;
  my $ca = (do given (T.REPR // '') {
    when 'P6opaque' {
      when T ~~ Str                     { $handling = P;  CArray[T]          }

      proceed
    }

    when 'CPointer' | 'P6str'  |
         'P6num'    | 'P6int'           { $handling = P;  CArray[T]          }
    when 'CStruct'  | 'CUnion'          { $handling = NP; CArray[Pointer[T]] }

    default {
      "ArrayToCArray does not know how to handle a REPR of '$_' for type {
       T.^name }"
    }
  });

  say "CA: { $ca.^name } / { $size }" if $DEBUG;

  return $ca unless $a.elems;
  $ca = $ca.new;
  for ^$size {
    my $typed = checkForType(T, $a[$_]);

    $ca[$_] = $handling == P ?? $typed !! cast(Pointer[T], $typed)
  }
  if $null {
    $ca[$size] = do given T {
      when Int             { 0          }
      when Num             { 0e0        }
      when Str             { Str        }
      when $handling == P  { T          }
      when $handling == NP { Pointer[T] }
    }
  }

  $ca;
}
