-module(geom).
-export([area/1]).

-spec(area(atom(), number(), number()) -> number()).

area(rectangle, A, B) when A >= 0, B >= 0 -> 
	A * B;
area(triangle, A, B) when A >= 0, B >=0 ->
	A * B / 2.0;
area(ellipse, A, B) when A >=0, B>=0 ->
	math:pi() * A * B;
area(_, _, _) -> 0.

area({X, A, B}) ->
	area(X, A, B).
