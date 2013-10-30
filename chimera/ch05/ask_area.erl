-module(ask_area).
-export([geom/0, get_number/1]).

geom() ->
	Response = io:get_line("R(ectangle, T(riangle, E(llipse? "),
	FirstChar = string:sub_string(Response, 1, 1),
	ShapeAtom = char_to_shape(FirstChar),
	Dimension = process_shape(ShapeAtom),
	Dimension.

char_to_shape(Value) -> 
	case string:to_lower(Value) of
		"r" -> rectangle;
		"t" -> triangle;
		"e" -> ellipse;
		 _ -> Value
	end.


process_shape(ShapeAtom) 
		when ShapeAtom == triangle
		; ShapeAtom == triangle
		; ShapeAtom == ellipse
		->
			Base = prompt("base"),
			Height = prompt("height"),
			calculate({ShapeAtom, Base, Height});

process_shape(Value) ->
	string:concat("Unknown entry: ", Value).


	
prompt(Message) ->
	io:get_line(string:concat(string:concat("Enter ",  Message), " > ")).

get_number(Input) ->
	Stripped = string:strip(Input, both, $\n), %why the bloody hell doesn't this stip off the LF?
	Float =	string:to_float(Stripped),
	if
		is_float(Float) ->
			Float;
		true ->
			string:to_integer(Stripped)
	end.

calculate(Tuple)
	when is_tuple(Tuple) ->
		{Shape, AAA, BBB} = Tuple,
		NumAAA = get_number(AAA),
		NumBBB = get_number(BBB),

		if
			is_number(NumAAA) == false ->
				Result = string:concat("Error in first number: ", AAA);
			is_number(NumBBB) == false ->
				Result = string:concat("Error in second number: ", BBB);
			true ->
				Result = 0 
		end,

		if 
			Result =/= 0 ->
				Result;
			true ->
				geom:area(Tuple)	
		end.

