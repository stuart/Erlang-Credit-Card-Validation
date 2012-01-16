-module(credit_card).
-export([is_valid/1, type/1]).
-author({author, "Stuart Coyle","stuart.coyle@gmail.com"}).

%% Returns a boolean value of whether the card is valid or not.
is_valid(N) ->
  N2 = lists:reverse(list_to_integers(N)),
  sum_digits(N2) rem 10 =:= 0.

%% Returns an atom describing the type of the card
%% Possible outputs are: amex, visa, mastercard, discover, unknown
type(N) ->
  type_(N, string:len(N)). 

sum_digits(N) ->
  sum_digits(N,0).
  
sum_digits([],Acc) ->
  Acc;

sum_digits([Odd], Acc) ->
  Acc + Odd;
  
sum_digits(List, Acc) ->
  [Odd|Tail] = List,
  [Even|Remainder] = Tail,
  sum_digits(Remainder, Acc + digital_root(Even * 2) + Odd).

digital_root(N) ->
   1 + (N-1) rem 9.
   
list_to_integers(N) ->
  lists:map(fun(E) -> list_to_integer([E]) end, N).


%% 34* or 37*
type_([$3|[Second|_]], Length) when Length =:= 15, Second =:= $4; Second =:= $7 ->
  amex;

%% 4*
type_([$4|_],Length) when Length =:= 13; Length =:= 16 ->
  visa;

%% 51-55*
type_([$5|[Second|_]], Length) when Length =:= 16, Second >= $1, Second =< $5 ->
  mastercard;

%% 6011*
type_([$6|[$0|[$1|[$1|_]]]], Length) when Length =:= 16 ->
  discover; 

type_(_, _) ->
  unknown.
  