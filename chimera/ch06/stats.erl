-module(stats).
-export([minimum/1, maximum/1, range/1]).

minimum(List) 
	when is_list(List) ->
		[Head|Tail] = List,
		get_smallest(Tail, Head).

maximum(List) ->
	[Head|Tail] = List,
	get_largest(Tail, Head).


range(List) ->
	[Head|Tail] = List,
	Largest = get_largest(Tail, Head),
	Smallest = get_smallest(Tail, Head),
	[Smallest, Largest].


get_largest([Head|Tail], Largest) ->
	if
		Head > Largest ->
			NewHighest = Head;
		true ->
			NewHighest = Largest
	end,

	get_largest(Tail, NewHighest);

get_largest([], Largest) -> Largest.


get_smallest([Head|Tail], Smallest) ->
	if
		Smallest > Head ->
			NewLowest = Head;
		true -> 
			NewLowest = Smallest
	end,

	get_smallest(Tail, NewLowest);

get_smallest([], Smallest) -> Smallest.


