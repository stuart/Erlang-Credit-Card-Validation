#!/usr/local/bin/escript

main(Args) ->
  Output = lists:map(fun(N) -> {credit_card:type(N), N, valid(N)} end, Args),
  io:format("~p~n", [Output]).
  
valid(N) ->
  case credit_card:is_valid(N) of
    true ->
      valid;
    false -> 
      invalid
  end.