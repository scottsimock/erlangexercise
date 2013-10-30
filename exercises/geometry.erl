-module(geometry).
-export([area/1]).

area({rectangle,Width,Height}) -> Width * Height;
area({square,Side}) -> Side * Side;
area({circle,Radius}) -> math:pi() * (Radius * Radius);
area({right_triangle,Base, Height}) -> 1/2 * Base * Height.
