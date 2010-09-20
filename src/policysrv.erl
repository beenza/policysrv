-module(policysrv).
-export([start_link/0]).


start_link() ->
  {ok, spawn_link(fun start/0)}.


start() ->
  {ok, PolicyFile} = application:get_env(policysrv, policyfile),
  {ok, Policy} = file:read_file(PolicyFile),
  {ok, LSock} = gen_tcp:listen(843, [binary, {packet, 0},
                                     {reuseaddr, true}, {active, false}]),
  accept(LSock, Policy).


accept(LSock, Policy) ->
  {ok, Sock} = gen_tcp:accept(LSock),
  spawn(fun() -> send(Sock, Policy) end),
  accept(LSock, Policy).


send(Sock, Policy) ->
  gen_tcp:send(Sock, Policy),
  gen_tcp:close(Sock).
