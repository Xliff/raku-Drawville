use v6.c;

use NativeCall;

unit package Drawville::Raw::Definitions;

constant drawville is export = 'drawville';

constant Color is export := uint32;
our enum ColorEnum is export <
  BLACK
  WHITE
>;

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
