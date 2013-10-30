-module(geom).
-export([area/1]).

pArea(Shape, A, B) when A >= 0, B >=0 ->
	case Shape of
		rectangle -> 
			A * B;
		triangle ->
			A * B / 2.0;
		ellipse ->
			math:pi() * A * B
	end;

pArea(_, _, _) -> 0.

area({X, A, B}) ->
	pArea(X, A, B).
