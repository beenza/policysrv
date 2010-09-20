-module(policysrv_app).
-behaviour(application).

-export([start/2, stop/1]).

start(_, _) ->
  policysrv_sup:start_link().

stop(_) ->
  ok.
