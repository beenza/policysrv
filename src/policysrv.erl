-module(policysrv).
-export([start_link/0]).

-define(POLICY_FILE_REQUEST, <<"<policy-file-request/>", 0>>).
-define(BAD_REQUEST, <<"<bad-request/>", 0>>).


start_link() ->
  {ok, spawn_link(fun start/0)}.


start() ->
  {ok, PolicyFile} = application:get_env(policysrv, policyfile),
  {ok, Policy} = file:read_file(PolicyFile),
  {ok, LSock} = gen_tcp:listen(843, [binary, {packet, 0}, {send_timeout, 20000},
                                     {reuseaddr, true}, {active, false}]),
  accept(LSock, <<Policy/binary, 0>>).


accept(LSock, Policy) ->
  {ok, Sock} = gen_tcp:accept(LSock),
  spawn(fun() -> send(Sock, Policy) end),
  accept(LSock, Policy).


send(Sock, Policy) ->
  case gen_tcp:recv(Sock, size(?POLICY_FILE_REQUEST)) of
    {ok, Request} -> case Request of
                       ?POLICY_FILE_REQUEST -> gen_tcp:send(Sock, Policy);
                       _ -> gen_tcp:send(Sock, ?BAD_REQUEST)
                     end,
                     gen_tcp:close(Sock);
    {error, closed} -> pass
  end.
