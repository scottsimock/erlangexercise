-module(cards).
-export([make_deck/0, show_deck/1]).

make_deck() ->
	[ {Card, Suit} ||
		Card <- ["A", "K", "Q", "J", 10, 9, 8, 7, 6, 5, 4, 3, 2],
		Suit <- [spades, hearts, clubs, diamonds]
	].

show_deck(Deck) ->
	lists:foreach(fun(Item) -> io:format("~p~n", [Item]) end, Deck).
