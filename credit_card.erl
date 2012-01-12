-module(credit_card).
-export([is_valid/1, type/1]).
-include("credit_card.hrl").

is_valid(N) ->
  N2 = lists:reverse(list_to_integers(N)),
  sum_digits(N2) rem 10 =:= 0.

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

type(N) ->
  type_(N, string:len(N)). 
  
%% 34* or 37*
type_([51|[Second|_]], Length) when Length =:= 15, Second =:= 52; Second =:= 55 ->
  amex;

%% 4*
type_([52|_],Length) when Length =:= 13; Length =:= 16 ->
  visa;

%% 51-55*
type_([53|[Second|_]], Length) when Length =:= 16, Second >= 49, Second =< 53 ->
  mastercard;

%% 6011*
type_([54|[48|[49|[49|_]]]], Length) when Length =:= 16 ->
  discover; 
  
type_(_, _) ->
  invalid.
  