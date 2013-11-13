-module(cards).
-export([ make_deck/0, show_deck/1, shuffle/1, cut/1, compare/2 ]).

make_deck() ->
	[ {Card, Suit} ||
		Card <- ["A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2],
		Suit <- [spades, hearts, clubs, diamonds]
	].

show_deck(Deck) ->
	lists:foreach(fun(Item) -> io:format("~p~n", [Item]) end, Deck).

%% @doc Function will randomly shuffle a deck of cards 
shuffle(Deck) -> shuffle(Deck, []).

%% If there are no more cards in the original deck, just return the shuffled deck
shuffle([], Acc) -> Acc;

%% Randomly split the original deck into two lists.
%% Retain the first list and pop off the Head of the second list
%% Add the Tail of the second list to the first and add the Head to the shuffled list
shuffle(List, Acc) ->
	{Leading, [H | T]} = lists:split(random:uniform(length(List)) -1, List),
	shuffle(Leading ++ T, [H | Acc]).

cut(Deck) ->
	Length = erlang:length(Deck),
	CutAt = random:uniform(Length),
	Bottom = lists:nthtail(CutAt, Deck),
	Top = lists:nthtail( Length - CutAt, lists:reverse(Deck) ),
	Top ++ Bottom.

compare(MyCard,TheirCard) ->
	{MyValue,_} = MyCard,
	{TheirValue, _} = TheirCard,
	MyInteger = value_to_integer(MyValue),
	TheirInteger = value_to_integer(TheirValue),
	compare( MyInteger - TheirInteger ).

compare(Diff) when Diff > 0 -> 1;
compare(Diff) when Diff =:= 0 -> 0;
compare(_) -> -1.


value_to_integer(CardValue) ->
	case CardValue of
		"A" -> 14;
		"K" -> 13;
		"Q" -> 12;
		"J" -> 11;
		_ -> CardValue
	end.
