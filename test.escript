#!/usr/local/bin/escript

main(Args) ->
  true = code:add_pathz(filename:dirname(escript:script_name()) ++ "/ebin"),
  eunit:test(Args).